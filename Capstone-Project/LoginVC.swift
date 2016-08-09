//
//  LoginVC.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 5/29/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

//TODO: scrollview on this viewcontroller
import UIKit
import Alamofire

class LoginVC: UIViewController {
    
    
    // MARK: IBOutlets
    /*
     bottomView is an UIView that contain (forgot password, login button)
     an outlet to this view is needed to move it above the keyboard when it
     appear and move it back to its original position when the keyboard disappear.
    */
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    /*
     outlet to the buttom contraint of the buttom view
     it is needed to modify it when the keyboard appears and disappar
     */
    @IBOutlet weak var bottomViewButtomConstain: NSLayoutConstraint!
    
    // MARK: Variables
    var loginAttempt = 0
    
    // MARK: ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureNavigationBar()

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //observer to notify the view when the keyboard appears or disappear.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
 
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //hiding navigation controller when view disappears.
        self.navigationController?.navigationBar.hidden = true
        
    }
    // MARK: IBActions
    @IBAction func forgotPasswordButtonPressed() {
        
    }
    @IBAction func loginButtonPressed() {
        performSegueWithIdentifier("ProfileVC", sender: nil)
    }
    
    @IBAction func SeekerView() {
        performSegueWithIdentifier("SeekerFeedVC", sender: nil)
    }
    
    
    // MARK: Functions
    func setup() {
        //Tap gesture is added to hide the keyboard when the user tap on the screen.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        passwordTextField.secureTextEntry = true
        emailTextField.becomeFirstResponder()
        
    }
    func configureNavigationBar() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(cancelButtonAction))
        navigationItem.leftBarButtonItem = cancelButton
        //navigation bar title color.
        //self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orangeColor()]
        navigationItem.title = "Login"
    }
    func cancelButtonAction() {
        navigationController?.popViewControllerAnimated(true)
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    func keyboardWillShow(notification: NSNotification) {
        //getting the keyboard height to move the bottom view above the keyboard by modifying its constraint
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
        bottomViewButtomConstain.constant =  keyboardViewEndFrame.height
        bottomView.layoutIfNeeded()

    }
    func keyboardWillHide(notification: NSNotification) {
        //returning the bottom view to its original place.
        bottomViewButtomConstain.constant = 0
        bottomView.layoutIfNeeded()
    }
}



