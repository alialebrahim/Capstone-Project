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
class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var profileImage: CircularImageView!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: Variables
    let imagePicker = UIImagePickerController()
    var userCountry = ""
    var errorButtons = [String: ErrorButton]()
    
    // MARK: ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureNavigationBar()
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
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //grabing the selected image
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage.contentMode = .ScaleAspectFill
            profileImage.image = pickedImage
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
    func configureNavigationBar() {
        navigationItem.title = "Sign up"
        let signUpItem = UIBarButtonItem(title: "Sign up", style: .Plain, target: self, action: #selector(signUpAction))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(cancelAction))
        
        navigationItem.rightBarButtonItem = signUpItem
        navigationItem.leftBarButtonItem = cancelItem
    }
    func cancelAction() {
        navigationController?.popViewControllerAnimated(true)
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
        contentViewHeightConstraint.constant = contentRect.size.height + 20
    }
    
    func setup() {
        /*
         tap gesture on an image is used when the user press on the image
         an image picker will present for the use to choose his profile
         picture
         */
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(selectProfileImage))
        profileImage.addGestureRecognizer(imageTapGesture)
        imagePicker.delegate = self
        
        
        // tap gesture to dismiss the keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        passwordTextfield.secureTextEntry = true
        emailTextfield.becomeFirstResponder()
        scrollView.userInteractionEnabled = true

    }
    

}
