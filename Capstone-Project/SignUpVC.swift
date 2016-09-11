//
//  SignupVC.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 5/29/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import NVActivityIndicatorView
import ImageIO

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, SubmitButtonDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var profileImage: CircularImageView!
    @IBOutlet weak var emailTextfield: UITextField!
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
    // MARK: ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        detectUserCountry()
        
        //set up textfield delegate 
        emailTextfield.delegate = self
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
            userType = "S"
        }else {
            userType = "P"
        }
    }
    
    @IBAction func registerButtonPresser(sender: AnyObject) {
        registerButton.startLoadingAnimation()
    }
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
        if emailTextfield.text == "" {
            allRequiredFieldsAreFilled = allRequiredFieldsAreFilled && false
            emailTextfield.shakeView()
        }
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
        guard let email = emailTextfield.text, password = passwordTextfield.text, username = userNameTextField.text else{
            return false
        }
        /*
            whenever an input is invalid
                1- change the textfield placeholder to indicate the invalidity of the input
                2- change the placeholder color to red to grab the user attention
                3- display the error button
         */
        if !email.isValidEmail() {
            validated = validated && false
            emailTextfield.placeholder = "Invalid email"
            emailTextfield.textColor = UIColor.redColor()
            errorButtons["email"]!.hidden = false
        }
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
        let emailErrorMessage = "Please enter a valid email address."
        let emailErrorButton = ErrorButton(withMessage: emailErrorMessage, isAssociateWith: emailTextfield)
        setupErrorButton(emailErrorButton)
        errorButtons["email"] = emailErrorButton
        
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
    func signUpAction() {
        print("sign up pressed")
        /*
            before signing up
                1) check that all required fields are filled
                2) validate all user input
                3) check internet connection
                    1- connected -> perform sign up
                    2- not connected -> store input data in core data
         */
        if checkRequiredFields() {
            if validateInput() {
                //TODO: if not valid, once the user start to edit. remove the button.
                if Reachability.isConnectedToNetwork() {
                    print("connected")
                }else {
                    print("not connected")
                    //TODO: store inputed data in a locale storage
                }
            }
            
        }
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
        emailTextfield.becomeFirstResponder()
        emailTextfield.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
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
        userType = "S"
        seekerProviderSegmentedControl.tintColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        
        /*
         *
         *setup register Button
         */
        registerButton.setTitle("Register", forState: .Normal)
        registerButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        registerButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        registerButton.delegate = self
        registerButton.layer.cornerRadius = self.registerButton.frame.height / 2
        
    }
    func didAnimate(frame: CGRect) {
        let activity = NVActivityIndicatorView(frame: frame, type: .BallClipRotateMultiple, color: UIColor.whiteColor())
        contentView.addSubview(activity)
        contentView.bringSubviewToFront(activity)
        activity.startAnimation()
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    ////////////////////
    //MARK: Face Recognition
    ////////////////////
    ////////////////////
    //TODO: FIX ERRORS!
    ////////////////////
//    func centerImageViewOnFace(imageView: UIImageView) {
//        let context = CIContext(options: nil)
//        let options = [CIDetectorAccuracy: CIDetectorAccuracyLow]
//        let detector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: options)
//        let faceImage = imageView.image
//        let ciImage = CIImage(CGImage: (faceImage?.CGImage)!)
//        let features = detector.featuresInImage(ciImage)
//        
//        if features.count > 0 {
//            var face: CIFaceFeature!
//            for rect in features {
//                face = rect as! CIFaceFeature
//            }
//            var faceRect = face.bounds
//            faceRect.origin.x -= 20
//            faceRect.origin.y -= 30
//            faceRect.size.width += 40
//            faceRect.size.height += 60
//            
//            //converting from faceRect coordinate to UIImageView coordinate
//            let x = faceRect.origin.x / (faceImage?.size.width)!
//            let y = ((faceImage?.size.height)!-faceRect.origin.y-faceRect.size.height) / (faceImage?.size.height)!
//            let width = faceRect.size.width / (faceImage?.size.width)!
//            let height = faceRect.size.height / (faceImage?.size.height)!
//            
//            imageView.layer.contentsRect = CGRectMake(x, y, width, height)
//        }
//    }
    
}
