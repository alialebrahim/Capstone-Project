//
//  WelcomeVC.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 5/29/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WelcomeVC: UIViewController {
    //MARK: backend end variable test
    var counter = 1
    var token = ""
    // MARK: ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //hiding navigation controller on this view
        self.navigationController?.navigationBarHidden = true
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //make the navigation controller appears on next views.
        self.navigationController?.navigationBarHidden = false
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //TODO: delete
        //signUpTest()
        //tokenTest()
    }
    // MARK: IBActions
    @IBAction func signupAsProviderButtonPressed() {
        //performSegueWithIdentifier("SignUpVC", sender: nil)
        //TODO: delete
        if counter == 1 {
            tokenTest()
            counter = counter + 1
        }else if counter == 2 {
            predefinedServiceTest()
            counter = counter + 1
        }
    }
    @IBAction func signupAsSeekerButtonPressed() {
        //performSegueWithIdentifier("SignUpVC", sender: nil)
    }
    @IBAction func loginButtonPressed() {
        performSegueWithIdentifier("LoginVC", sender: nil)
    }
    
    //MARK: Backend testing.
    func tokenTest() {
        let URL = "http://capstone-dev-clone.us-west-2.elasticbeanstalk.com/token/"
        let parameters = [
            "username": "testUser",
            "password": "testPassword"
        ]
        Alamofire.request(.POST, URL, parameters: parameters, encoding: .JSON).validate().response { (request, response, data, error) in
            print("request")
            print(request)
            print("response")
            print(response)
            print("data")
            print(data)
            print("string data")
            if let dataString = String(data: data!, encoding: NSUTF8StringEncoding) {
                self.token = dataString
                print(self.token)
            }
            print("error")
            print(error)
        }
    }
    func signUpTest() {
        let URL = "http://capstone-dev-clone.us-west-2.elasticbeanstalk.com/signup/"
        let parameters = [
            "username": "testUser",
            "password": "testPassword"
        ]
        
        Alamofire.request(.POST, URL, parameters: parameters, encoding: .JSON).validate().response { (request, response, data, error) in
            print("request")
            print(request)
            print("response")
            print(response)
            print("data")
            print(data)
            print("string data")
            if let dataString = String(data: data!, encoding: NSUTF8StringEncoding) {
                print(dataString)
            }
            print("error")
            print(error)
        }
    }
    func predefinedServiceTest() {
        
        print("this is the token im sending in the header : \(token)")
        let headers = [
            "Authorization": token
        ]
        let URL = "http://capstone-dev-clone.us-west-2.elasticbeanstalk.com/predefinedservice/"
        let parameters = [
            "username": "testUser",
            "password": "testPassword"
        ]
        
        Alamofire.request(.GET, URL, parameters: nil, headers: headers).responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
    }
    
    func predefinedServiceWithImagesTest() {
        let imageArray = [UIImage]()
        for _ in 1...10 {
            
        }
    }
}
