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
    //let imagePicker = UIImagePickerController()
    var userCountry = ""
    var errorButtons = [String: ErrorButton]()
    var userType: String!
    var didChoosePicture = false
    let defaults = NSUserDefaults.standardUserDefaults()
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
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //observer to notify the view when the keyboard appears or disappear.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        createErrorButtons()
        adjustContentViewHeight()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    //MARK: IBActions
    
    @IBAction func profileImageButtonPressed(sender: AnyObject) {
        //presentViewController(imagePicker, animated: true, completion: nil)
        let alert = UIAlertController(title: nil, message: "Choose option", preferredStyle: .ActionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .Default) { (UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                imagePicker.allowsEditing = false
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }else {
                print("camera not available")
            }
        }
        let photoAction = UIAlertAction(title: "Choose Photo", style: .Default) { (UIAlertAction) in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(photoAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)

        
    }
    @IBAction func seekerProviderSegmentedControlAction(sender: AnyObject) {
        let segmentedControl = sender as! UISegmentedControl
        if segmentedControl.selectedSegmentIndex == 0 {
            userType = "seeker"
        }else {
            userType = "provider"
        }
    }
    
    @IBAction func registerButtonPresser(sender: AnyObject) {
        if checkRequiredFields() {
            if validateInput() {
                registerButton.startLoadingAnimation()
                //check internet connection
                signupUser(userNameTextField.text!, password: passwordTextfield.text!)
                print("did choose image : \(didChoosePicture)")
                print("user type : \(userType)")
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
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

        switch textField.placeholder! {
            case "Invalid email":
                textField.placeholder = "Email"
                textField.textColor = UIColor.blackColor()
                errorButtons["email"]!.hidden = !(errorButtons["email"]!.hidden)
            case "Invalid password":
                textField.placeholder = "Password"
                textField.textColor = UIColor.blackColor()
                errorButtons["password"]!.hidden = !(errorButtons["password"]!.hidden)
            case "Invalid username":
                textField.placeholder = "Username"
                textField.textColor = UIColor.blackColor()
                errorButtons["username"]!.hidden = !(errorButtons["username"]!.hidden)
        default:
            break
        }
        return true
    }
    // MARK: Image picker controller delegate function.
    func selectProfileImage() {
        //presentViewController(imagePicker, animated: true, completion: nil)
        let alert = UIAlertController(title: nil, message: "Choose option", preferredStyle: .ActionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .Default) { (UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                imagePicker.allowsEditing = false
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }else {
                print("camera not available")
            }
        }
        let photoAction = UIAlertAction(title: "Choose Photo", style: .Default) { (UIAlertAction) in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(photoAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //grabing the selected image
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            didChoosePicture = true
            profileImageButton.hidden = true
            //profileImage.contentMode = .ScaleAspectFill
            profileImage.image = pickedImage
            //centerImageViewOnFace(profileImage)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
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
        guard let /*email = emailTextfield.text,*/ password = passwordTextfield.text, username = userNameTextField.text else{
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
            userNameTextField.textColor = UIColor.redColor()
            errorButtons["username"]!.hidden = false
        }
        if !password.isValidPassword() {
            validated = validated && false
            passwordTextfield.placeholder = "Invalid password"
            passwordTextfield.textColor = UIColor.redColor()
            errorButtons["password"]!.hidden = false
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
    func setupErrorButton(button: UIButton) {
        button.addTarget(self, action: #selector(errorButtonPressed(_:)), forControlEvents: .TouchUpInside)
        contentView.addSubview(button)
        contentView.bringSubviewToFront(button)
    }
    //displays an alert that displays the error message.
    func errorButtonPressed(button: ErrorButton) {
        dismissKeyboard()
        let message = button.errorMessage
        let _ = SCLAlertView().showError("OOPS", subTitle: message)
    }
    func detectUserCountry() {
        let locale = NSLocale.currentLocale()
        if let country = locale.objectForKey(NSLocaleCountryCode) as? String {
            userCountry = country
        }
        print(userCountry)
    }
    func keyboardWillShow(notification: NSNotification) {
        //modify the scrollview when the keyboard appears.
        var userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        var contentInset = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
        scrollView.contentInset.top = 0

    }
    func keyboardWillHide(notification: NSNotification) {
        //return the scrollview to its original position when the keyboard disappear
        let contentInset:UIEdgeInsets = UIEdgeInsetsZero
        self.scrollView.contentInset = contentInset
    }

    
    func adjustContentViewHeight() {
        
        var contentRect = CGRectZero;
        for view in self.contentView.subviews {
            contentRect = CGRectUnion(contentRect, view.frame)
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
        let colors = [UIColor(hex: 0xB39DDB), UIColor(hex: 0x7E57C2)]
        self.view.setGradientBackground(colors)
        self.view.bringSubviewToFront(scrollView)
        self.view.bringSubviewToFront(contentView)
        
        contentView.backgroundColor = UIColor.clearColor()
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
        profileImage.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
         profileImage.addBorderWith(color: UIColor.whiteColor().colorWithAlphaComponent(0.7), borderWidth: 4)
        
        /*
         *
         *setup select profile image button background image
         */
        let origImage = profileImageButton.imageView?.image!
        let tintedImage = origImage!.imageWithRenderingMode(.AlwaysTemplate)
        profileImageButton.setImage(tintedImage, forState: .Normal)
        profileImageButton.tintColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        profileImageButton.contentMode = .ScaleAspectFit
        
        /*
         *
         *setup textfields
         */
        userNameTextField.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        passwordTextfield.secureTextEntry = true
        passwordTextfield.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        //emailTextfield.becomeFirstResponder()
        //emailTextfield.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        scrollView.userInteractionEnabled = true
        
        /*
         *
         *setup Segmented Control
         */
        let segAttributes: NSDictionary = [
            NSForegroundColorAttributeName: UIColor(hex: 0x7E57C2)
        ]
        
        seekerProviderSegmentedControl.setTitleTextAttributes(segAttributes as [NSObject : AnyObject], forState: UIControlState.Selected)
        seekerProviderSegmentedControl.selectedSegmentIndex = 0
        userType = "seeker"
        seekerProviderSegmentedControl.tintColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        
        /*
         *
         *setup register Button
         */
        registerButton.setTitle("Register", forState: .Normal)
        registerButton.cachedTitle = "Register"
        registerButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        registerButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        registerButton.delegate = self
        registerButton.layer.cornerRadius = self.registerButton.frame.height / 2
        
    }
    //MARK: Submit Button Delegate function
    func didAnimate(frame: CGRect) {
        activity = NVActivityIndicatorView(frame: frame, type: .BallClipRotateMultiple, color: UIColor.whiteColor())
        contentView.addSubview(activity)
        contentView.bringSubviewToFront(activity)
        activity.startAnimation()
    }
    func removeAnimation() {
        print("should stop animation")
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    func storeToken(token: String) {
        print(token)
        defaults.setObject(token, forKey: "userToken")
        
        //this is how to get the token back.
        /*****************************************************
         if let mytoken = defaults.objectForKey("userToken") {
         print("from user defaults token is \(mytoken)")
         }
         *****************************************************/
    }
    func alertWithMessage(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertController.addAction(okAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    //MARK: BACKEND REQUEST FUNCTIONS
    func signupUser(username: String, password: String) {
        print("in sign up user test ---->  user type is : \(userType)")
        let URL = "\(AppDelegate.URL)/signup/"
        let parameters = [
            "username": username,
            "password": password,
            "usertype": userType
        ]
        print("username: \(username)")
        print("password: \(password)")
        Alamofire.request(.POST, URL, parameters: parameters, encoding: .JSON).responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // URL response
            print(response.data)     // server data
            if let requestData = response.data {
                if let dataString = String(data: requestData, encoding: NSUTF8StringEncoding) {
                    print(dataString)
                }
            }
            print(response.result)   // result of response serialization
            if response.response?.statusCode == 201 {
                if let json = response.result.value {
                    print("my json")
                    print(json)
                    let myJson = JSON(json)
                    if let userID = myJson["userid"].string {
                        print("user id")
                        print(userID)
                    }
                }
                if let mydata = String(data: response.data!, encoding: NSUTF8StringEncoding) {
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
            
        }
    }
    func loginTest(myusername: String, mypassword: String) {
        let URL = "\(AppDelegate.URL)/login/"
        let parameters = [
            "username": myusername,
            "password": mypassword
        ]
        
        print("username -> \"\(parameters["username"])\"")
        print("password -> \"\(parameters["password"])\"")
        
        Alamofire.request(.POST, URL, parameters: parameters, encoding: .JSON).validate().responseJSON {
            (response) in
            if (response.response!.statusCode) == 200 {
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
            
        }
    }
    //will set country to make it part of the sign up
    func setProfile() {
        let URL = "\(AppDelegate.URL)/profile/"
        print(userCountry)
        if let myToken = defaults.objectForKey("userToken") as? String{
            print(myToken)
            let headers = [
                "Authorization": myToken
            ]
            //TODO: Add profile image if available
            let parameters = [
                "country": userCountry
            ]
            
            Alamofire.request(.PUT, URL, parameters: parameters, headers: headers, encoding: .JSON).responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let requestData = response.data {
                    if let dataString = String(data: requestData, encoding: NSUTF8StringEncoding) {
                        print("data String : \(dataString)")
                    }
                }
                
                if (response.response!.statusCode) == 200 {
                    if let json = response.result.value {
                        print("my json")
                        print(json)
                        let myJson = JSON(json)
                        if let myType = myJson["usertype"].string {
                            print("MY TYPE IS : \(myType)")
                            if myType == "seeker" {
                                self.performSegueWithIdentifier("SeekerFeedVC", sender: nil)
                            }else if myType == "provider" {
                                self.performSegueWithIdentifier("ProfileVC", sender: nil)
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
                
                
            }
        }
    }

    
}
