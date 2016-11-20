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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //hiding navigation controller on this view
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //make the navigation controller appears on next views.
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //TODO: delete
        //loginTest()
        //addingPredefinedTest()
        //feedTest()
        
    }
    // MARK: IBActions
    @IBAction func signupAsProviderButtonPressed() {
        //performSegueWithIdentifier("SignUpVC", sender: nil)
        //TODO: delete
        if counter == 1 {
            signUpTest()
            counter = counter + 1
        }else if counter == 2 {
            loginTest()
            counter = counter + 1
        }
    }
    @IBAction func signupAsSeekerButtonPressed() {
        //performSegueWithIdentifier("SignUpVC", sender: nil)
    }
    @IBAction func loginButtonPressed() {
        performSegue(withIdentifier: "LoginVC", sender: nil)
    }
    
    //MARK: Backend testing.
    func loginTest() {
        let URL = "http://capstone-dev-clone.us-west-2.elasticbeanstalk.com/token/"
        let parameters = [
            "username": "testUser",
            "password": "testPass"
        ]
        Alamofire.request(.POST, URL, parameters: parameters, encoding: .json).validate().response {
            (request, response, data, error) in
            print("request")
            print(request)
            print("response")
            print(response)
            print("data")
            print(data)
            print("string data")
            if let dataString = String(data: data!, encoding: String.Encoding.utf8) {
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
            "username": "alebrahim",
            "password": "AliAlebrahim100",
            "email": "alebrahimcs@gmail.com"
        ]
        
        Alamofire.request(.POST, URL, parameters: parameters, encoding: .json).validate().response { (request, response, data, error) in
            print("request")
            print(request)
            print("response")
            print(response)
            print("data")
            print(data)
            print("string data")
            if let dataString = String(data: data!, encoding: String.Encoding.utf8) {
                print(dataString)
            }
            print("error")
            print(error)
        }
    }
    func addingPredefinedTest() {
        
        let URL = "http://capstone-dev-clone.us-west-2.elasticbeanstalk.com/predefinedservice/"
        var imagesDictonaryList = [[String : AnyObject]]()
        var images = [UIImage]()
        for _ in 1...3 {
            images.append(UIImage(named: "profileImagePlaceholder")!)
        }
        let imagesData = imagesToBase64(images)
        for index in 0..<3 {
            var myDictionary = [String:AnyObject]()
            myDictionary["name"] = "\(index)" as AnyObject?
            myDictionary["image"] = imagesData[index] as AnyObject?
            imagesDictonaryList.append(myDictionary)
        }
        print(imagesDictonaryList)
        let parameters = [
            "title": "service 1 title",
            "description": "service 1 description",
            "price": "11",
            "images": imagesDictonaryList
        ] as [String : Any]
        Alamofire.request(.POST, URL, parameters: parameters as? [String : AnyObject], encoding: .json).responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            if let dataString = String(data: response.data!, encoding: String.Encoding.utf8) {
                print(dataString)
            }
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
        
        
        /*
         .validate().response { (request, response, data, error) in
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
         */
        
        
    }
    func imagesToBase64(_ images: [UIImage]) -> [String]{
        var imagesData = [String]()
        for image in images {
            let imageData = UIImagePNGRepresentation(image)
            let base64String = imageData!.base64EncodedString(options: .lineLength64Characters)
            imagesData.append(base64String)
        }
        return imagesData
    }
    func feedTest() {
        
        print("this is the token im sending in the header : \(token)")
//        let headers = [
//            "Authorization": token
//        ]
        let URL = "http://capstone-dev-clone.us-west-2.elasticbeanstalk.com/predefinedservice/"
        let parameters = [
            "username": "testUser",
            "password": "testPassword"
        ]
        let p = [
            "query_last": 5
        ]
        Alamofire.request(.GET, URL, parameters: p/**, headers: headers*/).responseJSON { response in
            print(response.request)  // original URL request
            print(response.response) // URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
    }

}
