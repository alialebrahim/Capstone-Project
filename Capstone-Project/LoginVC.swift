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

class LoginVC: UIViewController, SubmitButtonDelegate {

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
    let defaults = UserDefaults.standard
    var token = ""
    var activity: NVActivityIndicatorView! = nil
    
    // MARK: ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        
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
        /*TEST CODE*/
//        navigationController?.setNavigationBarHidden(true, animated: false)
//        LoadingView.startAnimatingWithMessage("test message")
//        NSTimer.schedule(delay: 5) { timer in
//            self.navigationController?.setNavigationBarHidden(false, animated: false)
//            LoadingView.stopAnimating()
//        }
//        NSTimer.schedule(delay: 15) { timer in
//            self.navigationController?.setNavigationBarHidden(true, animated: false)
//            LoadingView.startAnimatingWithMessage("test11 message")
//        }
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    // MARK: IBActions
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        //TODO: add internet checking!
        if validateIput(emailTextField, password: passwordTextField){
            if Reachability.isConnectedToNetwork() {
                loginButton.startLoadingAnimation()
                loginTest(emailTextField.text! , mypassword: passwordTextField.text!)
            }else {
                self.alertWithMessage("check your internet connection!")
            }
        }
        
    }
    @IBAction func createAcccountButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "SignUp", sender: nil)
    }
    @IBAction func forgotYourPasswordButtonPressed(_ sender: AnyObject) {
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
        //let colors = [UIColor(hex: 0xB39DDB), UIColor(hex: 0x7E57C2)]
        //self.view.setGradientBackground(colors)
        self.view.backgroundColor = UIColor.white
        /*
         *
         *setting up logo image
         */
        let origImage = logoImageView.image!
        let tintedImage = origImage.withRenderingMode(.alwaysTemplate)
        logoImageView.image = tintedImage
        logoImageView.tintColor = UIColor(hex: 0xa85783)
        logoImageView.contentMode = .scaleAspectFit
        
        /*
         *
         *setting up textFields
         */
        emailTextField.textAlignment = .left
        emailTextField.keyboardType = .emailAddress
        passwordTextField.textAlignment = .left
        passwordTextField.keyboardType = .default
        passwordTextField.isSecureTextEntry = true
        
        /*
         *
         *setting up login button
         */
        loginButton.setTitle("Login", for: UIControlState())
        loginButton.cachedTitle = "Login"
        loginButton.setTitleColor(UIColor.white, for: UIControlState())
        loginButton.backgroundColor = UIColor(hex: 0xa85783)
        loginButton.delegate = self
        loginButton.layer.cornerRadius = self.loginButton.frame.height / 2
        
        
        navigationItem.title = "Login"
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    func keyboardWillShow(_ notification: Notification) {
        //getting the keyboard height to move the bottom view above the keyboard by modifying its constraint
//        let userInfo = notification.userInfo!
//        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
//        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
//        bottomViewButtomConstain.constant =  keyboardViewEndFrame.height
//        bottomView.layoutIfNeeded()

    }
    func keyboardWillHide(_ notification: Notification) {
        //returning the bottom view to its original place.
//        bottomViewButtomConstain.constant = 0
//        bottomView.layoutIfNeeded()
    }
    
    //MARK: Submit Button Delegate function
    func didAnimate(_ frame: CGRect) {
        activity = NVActivityIndicatorView(frame: frame, type: .ballClipRotateMultiple, color: UIColor.white)
        view.addSubview(activity)
        view.bringSubview(toFront: activity)
        activity.startAnimation()
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
	}
    func alertWithMessage(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
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
    func validateIput(_ email: UITextField, password: UITextField) -> Bool {
        var isValid = true
        if let myEmail = email.text {
            if myEmail.isEmpty {
                email.shakeView()
                isValid = isValid && false
            }
        }
        if let myPassword = password.text {
            if myPassword.isEmpty {
                password.shakeView()
                isValid = isValid && false
            }
        }
        return isValid
    }
    //MARK: BACKEND
    //TODO: Check response code and apply appropriate message
    func loginTest(_ myusername: String, mypassword: String) {
        let URL = "\(AppDelegate.URL)/login/"
        let parameters = [
            "username": myusername,
            "password": mypassword
        ]
        
        print("username -> \"\(parameters["username"])\"")
        print("password -> \"\(parameters["password"])\"")
        
        Alamofire.request(.POST, URL, parameters: parameters, encoding: .json).validate().responseJSON {
            (response) in
            print(response.request)  // original URL request
            print(response.response) // URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            if let mydata = String(data: response.data!, encoding: String.Encoding.utf8) {
                print(mydata)
            }
            //TODO: validate its not empty
            if let myResponse = response.response {
                if myResponse.statusCode == 200 {
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
                                    self.performSegue(withIdentifier: "SeekerFeedVC", sender: nil)
                                }else if myType == "provider" {
                                    self.performSegue(withIdentifier: "ProfileVC", sender: nil)
                                }
                            }
                        }
                    }
                }else {
                    print("did not login")
                    self.loginButton.returnToOriginalState()
                    self.activity.removeFromSuperview()
                    self.alertWithMessage("check your email and password")
                }
            }else {
                self.loginButton.returnToOriginalState()
                self.activity.removeFromSuperview()
                self.alertWithMessage("Server error\nPlease try again.")
            }
        }
    }

}
