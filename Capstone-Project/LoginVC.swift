//
//  LoginVC.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 5/29/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import SwiftyJSON

//TODO: notificaion if email or password are incorrect!
class LoginVC: UIViewController, SubmitButtonDelegate {
//    let URL = "http://127.0.0.1:8000"
    let URL = "http://81.4.110.27"
	let username = "TomatoKetchup"
	let password = "Heinz"
	let userType = "provider"
	
	
	
	
    // MARK: IBOutlets
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var loginButton: SubmitButton!
    @IBOutlet weak var forgotYourPasswordButton: UIButton!
    
    // MARK: Variables
    var loginAttempt = 0
    let defaults = NSUserDefaults.standardUserDefaults()
    var token = ""
    var activity: NVActivityIndicatorView! = nil
    
    // MARK: ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //observer to notify the view when the keyboard appears or disappear.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
 
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    // MARK: IBActions
    @IBAction func loginButtonPressed(sender: AnyObject) {
        loginButton.startLoadingAnimation()
        loginTest(emailTextField.text! , mypassword: passwordTextField.text!)
    }
    @IBAction func createAcccountButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("SignUp", sender: nil)
    }
    @IBAction func forgotYourPasswordButtonPressed(sender: AnyObject) {
        print("forgot password")
    }
    // MARK: Functions
    func setup() {
        /*
        *
        *setting up self.view
        */
        //Tap gesture is added to hide the keyboard when the user tap on the screen.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        let colors = [UIColor(hex: 0xB39DDB), UIColor(hex: 0x7E57C2)]
        self.view.setGradientBackground(colors)
        /*
         *
         *setting up logo image
         */
        let origImage = logoImageView.image!
        let tintedImage = origImage.imageWithRenderingMode(.AlwaysTemplate)
        logoImageView.image = tintedImage
        logoImageView.tintColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        logoImageView.contentMode = .ScaleAspectFit
        
        /*
         *
         *setting up textFields
         */
        emailTextField.textAlignment = .Left
        emailTextField.keyboardType = .EmailAddress
        passwordTextField.textAlignment = .Left
        passwordTextField.keyboardType = .Default
        passwordTextField.secureTextEntry = true
        
        /*
         *
         *setting up login button
         */
        loginButton.setTitle("Login", forState: .Normal)
        loginButton.cachedTitle = "Login"
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        loginButton.delegate = self
        loginButton.layer.cornerRadius = self.loginButton.frame.height / 2
        
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    func keyboardWillShow(notification: NSNotification) {
        //getting the keyboard height to move the bottom view above the keyboard by modifying its constraint
//        let userInfo = notification.userInfo!
//        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
//        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
//        bottomViewButtomConstain.constant =  keyboardViewEndFrame.height
//        bottomView.layoutIfNeeded()

    }
    func keyboardWillHide(notification: NSNotification) {
        //returning the bottom view to its original place.
//        bottomViewButtomConstain.constant = 0
//        bottomView.layoutIfNeeded()
    }
    
    //MARK: Submit Button Delegate function
    func didAnimate(frame: CGRect) {
        activity = NVActivityIndicatorView(frame: frame, type: .BallClipRotateMultiple, color: UIColor.whiteColor())
        view.addSubview(activity)
        view.bringSubviewToFront(activity)
        activity.startAnimation()
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
	}
    func alertWithMessage(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertController.addAction(okAction)
        
        presentViewController(alertController, animated: true, completion: nil)
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
    //TODO: implement this function
    func validateIput(username: UITextField, password: UITextField) -> Bool {
        //if they are not empty return true
        //if empty shake
        //if invalid (for emails only) show error message
        return true
    }
    //MARK: BACKEND
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
            print(response.request)  // original URL request
            print(response.response) // URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            if let mydata = String(data: response.data!, encoding: NSUTF8StringEncoding) {
                print(mydata)
            }
            if (response.response!.statusCode) == 200 {
                if let json = response.result.value {
                    print("my json")
                    print(json)
                    let myJson = JSON(json)
                    if let myToken = myJson["token"].string {
                        print(myToken)
                        self.storeToken(myToken)
                        if let myType = myJson["usertype"].string {
                            print(myType)
                            if myType == "seeker" {
                                self.performSegueWithIdentifier("SeekerFeedVC", sender: nil)
                            }else if myType == "provider" {
                                self.performSegueWithIdentifier("ProfileVC", sender: nil)
                            }
                        }
                    }
                }
                
            }else {
                print("did not login")
                self.loginButton.returnToOriginalState()
                self.activity.removeFromSuperview()
                self.alertWithMessage("error in login in")
            }
            
        }
    }

}