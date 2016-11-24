//
//  SignupVC.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 5/29/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//
//TODO: Add code to sign up when user select a picture.
import UIKit
import SwiftyJSON
import Alamofire
import NVActivityIndicatorView
import ImageIO

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, SubmitButtonDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var profileImage: CircularImageView!
    //@IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var seekerProviderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var registerButton: SubmitButton!

    // MARK: Variables
    var userCountry = ""
    var errorButtons = [String: ErrorButton]()
    var userType: String!
    var didChoosePicture = false
    let defaults = UserDefaults.standard
    var activity: NVActivityIndicatorView! = nil
    // MARK: ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        detectUserCountry()
        
        //set up textfield delegate 
        //emailTextfield.delegate = self
        passwordTextfield.delegate = self
        userNameTextField.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //observer to notify the view when the keyboard appears or disappear.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createErrorButtons()
        adjustContentViewHeight()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    //MARK: IBActions
    @IBAction func profileImageButtonPressed(_ sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: "Choose option", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }else {
                //TODO: alert
                print("camera not available")
            }
        }
        let photoAction = UIAlertAction(title: "Choose Photo", style: .default) { (UIAlertAction) in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(photoAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)

        
    }
    @IBAction func seekerProviderSegmentedControlAction(_ sender: AnyObject) {
        if let segmentedControl = sender as? UISegmentedControl {
            if segmentedControl.selectedSegmentIndex == 0 {
            userType = "seeker"
            }else {
                userType = "provider"
            }
        }
    }
    
    @IBAction func registerButtonPresser(_ sender: AnyObject) {
        if checkRequiredFields() {
            if validateInput() {
                if Reachability.isConnectedToNetwork() {
                    registerButton.startLoadingAnimation()
                    signupUser(userNameTextField.text!, password: passwordTextfield.text!)
                    print("did choose image : \(didChoosePicture)")
                    print("user type : \(userType)")
                }else {
                    self.alertWithMessage("check your internet connection!")
                }
                
            }
        }
    }
    
    ///////////////
    // MARK: TextField Delegate functions
    
    /*
        this delegate function is used to change the textfield
        from invalid state (red text, invalid placeholder, and visible error button) to normal
        state (black text, normal placeholder, invisible error button)
     */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        switch textField.placeholder! {
            case "Invalid email":
                textField.placeholder = "Email"
                textField.textColor = UIColor.black
                errorButtons["email"]!.isHidden = !(errorButtons["email"]!.isHidden)
            case "Invalid password":
                textField.placeholder = "Password"
                textField.textColor = UIColor.black
                errorButtons["password"]!.isHidden = !(errorButtons["password"]!.isHidden)
            case "Invalid username":
                textField.placeholder = "Username"
                textField.textColor = UIColor.black
                errorButtons["username"]!.isHidden = !(errorButtons["username"]!.isHidden)
        default:
            break
        }
        return true
    }
    // MARK: Image picker controller delegate function.
    func selectProfileImage() {
        //presentViewController(imagePicker, animated: true, completion: nil)
        let alert = UIAlertController(title: nil, message: "Choose option", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }else {
                print("camera not available")
            }
        }
        let photoAction = UIAlertAction(title: "Choose Photo", style: .default) { (UIAlertAction) in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
            
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(photoAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //grabing the selected image
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            didChoosePicture = true
            profileImageButton.isHidden = true
            profileImage.contentMode = .scaleAspectFill
            profileImage.image = pickedImage
            //centerImageViewOnFace(profileImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    //MARK: Functions
    /*
        checkRequiredFields() checks if all required texfield are not empty
        returns true all fields are not empty and false otherwise
     */
    func checkRequiredFields() -> Bool {
        //shacking the textfield to indicate its required
        var allRequiredFieldsAreFilled = true
//        if emailTextfield.text == "" {
//            allRequiredFieldsAreFilled = allRequiredFieldsAreFilled && false
//            emailTextfield.shakeView()
//        }
        if userNameTextField.text == "" {
            allRequiredFieldsAreFilled = allRequiredFieldsAreFilled && false
            userNameTextField.shakeView()
        }
        if passwordTextfield.text == "" {
            allRequiredFieldsAreFilled = allRequiredFieldsAreFilled && false
            passwordTextfield.shakeView()
        }
        return allRequiredFieldsAreFilled
    }
    /*
        this function checks the validity of user input
        return true if valid and false otherwise
     */
    func validateInput() -> Bool {
        dismissKeyboard()
        var validated = true
        guard let /*email = emailTextfield.text,*/ password = passwordTextfield.text, let username = userNameTextField.text else{
            return false
        }
        /*
            whenever an input is invalid
                1- change the textfield placeholder to indicate the invalidity of the input
                2- change the placeholder color to red to grab the user attention
                3- display the error button
         */
//        if !email.isValidEmail() {
//            validated = validated && false
//            //emailTextfield.placeholder = "Invalid email"
//            //emailTextfield.textColor = UIColor.redColor()
//            errorButtons["email"]!.hidden = false
//        }
        if !username.isValidUsername() {
            validated = validated && false
            userNameTextField.placeholder = "Invalid username"
            userNameTextField.textColor = UIColor.red
            errorButtons["username"]!.isHidden = false
        }
        if !password.isValidPassword() {
            validated = validated && false
            passwordTextfield.placeholder = "Invalid password"
            passwordTextfield.textColor = UIColor.red
            errorButtons["password"]!.isHidden = false
        }
        return validated
    }
    /*
     error buttons are those buttons that appears when the user input invalid email, username, or password
     */
    func createErrorButtons() {
        //Email error button
        //let emailErrorMessage = "Please enter a valid email address."
        //let emailErrorButton = ErrorButton(withMessage: emailErrorMessage, isAssociateWith: emailTextfield)
        //setupErrorButton(emailErrorButton)
        //errorButtons["email"] = emailErrorButton
        
        //Password error button
        let passwordErrorMessage = "Make sure your password is 6 charecters or more and contains uppper and lower case letters."
        let passwordErrorButton = ErrorButton(withMessage: passwordErrorMessage, isAssociateWith: passwordTextfield)
        setupErrorButton(passwordErrorButton)
        errorButtons["password"] = passwordErrorButton
        
        //Username error button
        let usernameErrorMessage = "Your username must be between 6-15 charecters\nand containts\nonly letters, numbers, underscores, and hyphens."
        let usernameErrorButton = ErrorButton(withMessage: usernameErrorMessage, isAssociateWith: userNameTextField)
        setupErrorButton(usernameErrorButton)
        errorButtons["username"] = usernameErrorButton
    }
    func setupErrorButton(_ button: UIButton) {
        button.addTarget(self, action: #selector(errorButtonPressed(_:)), for: .touchUpInside)
        contentView.addSubview(button)
        contentView.bringSubview(toFront: button)
    }
    //displays an alert that displays the error message.
    func errorButtonPressed(_ button: ErrorButton) {
        dismissKeyboard()
        let message = button.errorMessage
        //let _ = SCLAlertView().showError("OOPS", subTitle: message)
    }
    func detectUserCountry() {
        let locale = Locale.current
        if let country = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as? String {
            userCountry = country
        }
        print(userCountry)
    }
    func keyboardWillShow(_ notification: Notification) {
        //modify the scrollview when the keyboard appears.
        var userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        var contentInset = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
        scrollView.contentInset.top = 0

    }
    func keyboardWillHide(_ notification: Notification) {
        //return the scrollview to its original position when the keyboard disappear
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }

    
    func adjustContentViewHeight() {
        
        var contentRect = CGRect.zero;
        for view in self.contentView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        if contentRect.size.height > contentViewHeightConstraint.constant {
            contentViewHeightConstraint.constant = contentRect.size.height + 20
        }else {
            contentViewHeightConstraint.constant = self.view.frame.height - 50
        }
        
    }
    
    func setup() {
        /*
         *setting up view
         */
        //let colors = [UIColor(hex: 0xB39DDB), UIColor(hex: 0x7E57C2)]
        //self.view.setGradientBackground(colors)
        self.view.backgroundColor = UIColor.white
        self.view.bringSubview(toFront: scrollView)
        self.view.bringSubview(toFront: contentView)
        
        contentView.backgroundColor = UIColor.clear
        /*
         tap gesture on an image is used when the user press on the image
         an image picker will present for the use to choose his profile
         picture
         */
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(selectProfileImage))
        profileImage.addGestureRecognizer(imageTapGesture)
        //imagePicker.delegate = self
        
        
        // tap gesture to dismiss the keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        /*
        *
        *setup profile image view
        */
        profileImage.backgroundColor = UIColor.white.withAlphaComponent(0.5)
         profileImage.addBorderWith(color: UIColor(hex: 0x404040), borderWidth: 4)
        
        /*
         *
         *setup select profile image button background image
         */
        let origImage = profileImageButton.imageView?.image!
        let tintedImage = origImage!.withRenderingMode(.alwaysTemplate)
        profileImageButton.setImage(tintedImage, for: UIControlState())
        profileImageButton.tintColor = UIColor(hex: 0x404040)
        profileImageButton.contentMode = .scaleAspectFit
        
        /*
         *
         *setup textfields
         */
//        userNameTextField.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        passwordTextfield.isSecureTextEntry = true
//        passwordTextfield.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        //emailTextfield.becomeFirstResponder()
        //emailTextfield.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        scrollView.isUserInteractionEnabled = true
        
        /*
         *
         *setup Segmented Control
         */
        let segAttributes: NSDictionary = [
            
            //TODO: gray
            NSForegroundColorAttributeName: UIColor.white
        ]
        
        seekerProviderSegmentedControl.setTitleTextAttributes(segAttributes as? [AnyHashable: Any], for: UIControlState.selected)
        seekerProviderSegmentedControl.selectedSegmentIndex = 0
        userType = "seeker"
        seekerProviderSegmentedControl.tintColor = UIColor(hex: 0xa85783)
        
        /*
         *
         *setup register Button
         */
        registerButton.setTitle("Register", for: UIControlState())
        registerButton.cachedTitle = "Register"
        registerButton.setTitleColor(UIColor.white, for: UIControlState())
        registerButton.backgroundColor = UIColor(hex: 0xa85783)
        registerButton.delegate = self
        registerButton.layer.cornerRadius = self.registerButton.frame.height / 2
        
        navigationItem.title = "Register"
        self.navigationController?.view.backgroundColor = UIColor.white
        
    }
    //MARK: Submit Button Delegate function
    func didAnimate(_ frame: CGRect) {
        activity = NVActivityIndicatorView(frame: frame, type: .ballClipRotateMultiple, color: UIColor.white)
        contentView.addSubview(activity)
        contentView.bringSubview(toFront: activity)
        activity.startAnimating()
    }
    //TODO: remove this
    func removeAnimation() {
        print("should stop animation")
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    func storeToken(_ token: String) {
        print(token)
        defaults.set(token, forKey: "userToken")
        
        //this is how to get the token back.
        /*****************************************************
         if let mytoken = defaults.objectForKey("userToken") {
         print("from user defaults token is \(mytoken)")
         }
         *****************************************************/
    }
    func alertWithMessage(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    //MARK: BACKEND
    //TODO: Check response code and apply appropriate message
    func signupUser(_ username: String, password: String) {
        print("in sign up user test ---->  user type is : \(userType)")
        let URL = "\(AppDelegate.URL)/signup/"
        let parameters = [
            "username": username,
            "password": password,
            "usertype": userType
        ]
        print("username: \(username)")
        print("password: \(password)")
        Alamofire.request(URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print(response.request)  // original URL request
            print(response.response) // URL response
            print(response.data)     // server data
            if let requestData = response.data {
                if let dataString = String(data: requestData, encoding: String.Encoding.utf8) {
                    print(dataString)
                }
            }
            print(response.result)   // result of response serialization
            if let myResponse = response.response {
                if myResponse.statusCode == 201 {
                    if let json = response.result.value {
                        print("my json")
                        print(json)
                        let myJson = JSON(json)
                        if let userID = myJson["userid"].string {
                            print("user id")
                            print(userID)
                        }
                    }
                    if let mydata = String(data: response.data!, encoding: String.Encoding.utf8) {
                        print(mydata)
                    }
                    //perform login test to get token
                    self.loginTest(username, mypassword: password)
                }else {
                    print("not successful")
                    self.registerButton.returnToOriginalState()
                    self.activity.removeFromSuperview()
                    self.alertWithMessage("error in signing up")
                }
            }else {
                self.alertWithMessage("Server error\nPlease try again.")
            }

        }
//        Alamofire.request(.POST, URL, parameters: parameters, encoding: .json).responseJSON { response in
//            print(response.request)  // original URL request
//            print(response.response) // URL response
//            print(response.data)     // server data
//            if let requestData = response.data {
//                if let dataString = String(data: requestData, encoding: String.Encoding.utf8) {
//                    print(dataString)
//                }
//            }
//            print(response.result)   // result of response serialization
//            if let myResponse = response.response {
//                if myResponse.statusCode == 201 {
//                    if let json = response.result.value {
//                        print("my json")
//                        print(json)
//                        let myJson = JSON(json)
//                        if let userID = myJson["userid"].string {
//                            print("user id")
//                            print(userID)
//                        }
//                    }
//                    if let mydata = String(data: response.data!, encoding: String.Encoding.utf8) {
//                        print(mydata)
//                    }
//                    //perform login test to get token
//                    self.loginTest(username, mypassword: password)
//                }else {
//                    print("not successful")
//                    self.registerButton.returnToOriginalState()
//                    self.activity.removeFromSuperview()
//                    self.alertWithMessage("error in signing up")
//                }
//            }else {
//                self.alertWithMessage("Server error\nPlease try again.")
//            }
//        }
    }
    func loginTest(_ myusername: String, mypassword: String) {
        let URL = "\(AppDelegate.URL)/login/"
        let parameters = [
            "username": myusername,
            "password": mypassword
        ]
        
        print("username -> \"\(parameters["username"])\"")
        print("password -> \"\(parameters["password"])\"")
        
        
        Alamofire.request(URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let myResponse = response.response {
                if (myResponse.statusCode) == 200 {
                    if let json = response.result.value {
                        print("my json")
                        print(json)
                        let myJson = JSON(json)
                        if let myToken = myJson["token"].string {
                            print(myToken)
                            self.storeToken(myToken)
                            self.setProfile()
                        }
                    }
                }else {
                    print("did not login")
                    self.registerButton.returnToOriginalState()
                    self.activity.removeFromSuperview()
                    self.alertWithMessage("error in login in")
                }
                
            }else {
                self.alertWithMessage("Server error\nPlease try again.")
            }

        }

//        Alamofire.request(.POST, URL, parameters: parameters, encoding: .json).validate().responseJSON {
//            (response) in
//            if let myResponse = response.response {
//                if (myResponse.statusCode) == 200 {
//                    if let json = response.result.value {
//                        print("my json")
//                        print(json)
//                        let myJson = JSON(json)
//                        if let myToken = myJson["token"].string {
//                            print(myToken)
//                            self.storeToken(myToken)
//                            self.setProfile()
//                        }
//                    }
//                }else {
//                    print("did not login")
//                    self.registerButton.returnToOriginalState()
//                    self.activity.removeFromSuperview()
//                    self.alertWithMessage("error in login in")
//                }
//
//            }else {
//                self.alertWithMessage("Server error\nPlease try again.")
//            }
//                        
//        }
    }
    //will set country to make it part of the sign up
    func setProfile() {
        let URL = "\(AppDelegate.URL)/profile/"
        print(userCountry)
        if let myToken = defaults.object(forKey: "userToken") as? String{
            print(myToken)
            let headers = [
                "Authorization": myToken
            ]
            //TODO: Add profile image if available
            var parameters = [String: AnyObject]()
            if didChoosePicture {
                //TODO: add image parameter here
                parameters = [
                    "country": userCountry as AnyObject
                ]
            }else {
                parameters = [
                    "country": userCountry as AnyObject
                ]
            }
            Alamofire.request(URL, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { (response) in
                print(response.request!)  // original URL request
                print(response.response!) // URL response
                print(response.data!)     // server data
                print(response.result)   // result of response serialization
                
                if let requestData = response.data {
                    if let dataString = String(data: requestData, encoding: String.Encoding.utf8) {
                        print("data String : \(dataString)")
                    }
                }
                if let myResponse = response.response {
                    if (myResponse.statusCode) == 200 {
                        if let json = response.result.value {
                            print("my json")
                            print(json)
                            let myJson = JSON(json)
                            if let myType = myJson["usertype"].string {
                                print("MY TYPE IS : \(myType)")
                                if myType == "seeker" {
                                    self.performSegue(withIdentifier: "SeekerFeedVC", sender: nil)
                                }else if myType == "provider" {
                                    self.performSegue(withIdentifier: "ProfileVC", sender: nil)
                                }
                            }
                        }
                    }else {
                        //did not login
                        print("did not set profile")
                        self.registerButton.returnToOriginalState()
                        self.activity.removeFromSuperview()
                        self.alertWithMessage("could not set up profile")
                    }
                }else {
                    self.alertWithMessage("Server error\nPlease try again.")
                }
            })
            
//            Alamofire.request(.PUT, URL, parameters: parameters, headers: headers, encoding: .json).responseJSON { response in
//                print(response.request)  // original URL request
//                print(response.response) // URL response
//                print(response.data)     // server data
//                print(response.result)   // result of response serialization
//                
//                if let requestData = response.data {
//                    if let dataString = String(data: requestData, encoding: String.Encoding.utf8) {
//                        print("data String : \(dataString)")
//                    }
//                }
//                if let myResponse = response.response {
//                    if (myResponse.statusCode) == 200 {
//                        if let json = response.result.value {
//                            print("my json")
//                            print(json)
//                            let myJson = JSON(json)
//                            if let myType = myJson["usertype"].string {
//                                print("MY TYPE IS : \(myType)")
//                                if myType == "seeker" {
//                                    self.performSegue(withIdentifier: "SeekerFeedVC", sender: nil)
//                                }else if myType == "provider" {
//                                    self.performSegue(withIdentifier: "ProfileVC", sender: nil)
//                                }
//                            }
//                        }
//                    }else {
//                        //did not login
//                        print("did not set profile")
//                        self.registerButton.returnToOriginalState()
//                        self.activity.removeFromSuperview()
//                        self.alertWithMessage("could not set up profile")
//                    }
//                }else {
//                    self.alertWithMessage("Server error\nPlease try again.")
//                }
//            }
        }
    }
}
