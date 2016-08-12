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
        //loginTest()
        addingPredefinedTest()
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
        performSegueWithIdentifier("LoginVC", sender: nil)
    }
    
    //MARK: Backend testing.
    func loginTest() {
        let URL = "http://capstone-dev-clone.us-west-2.elasticbeanstalk.com/token/"
        let parameters = [
            "username": "testUser",
            "password": "testPass"
        ]
        Alamofire.request(.POST, URL, parameters: parameters, encoding: .JSON).validate().response {
            (request, response, data, error) in
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
            "username": "alebrahim",
            "password": "AliAlebrahim100",
            "email": "alebrahimcs@gmail.com"
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
    func addingPredefinedTest() {
        let URL = "http://capstone-dev-clone.us-west-2.elasticbeanstalk.com/predefinedservice/"
        var images = [UIImage]()
        for _ in 1...1 {
            images.append(UIImage(named: "profileImagePlaceholder")!)
        }
        let imagesData = imagesToBase64(images)
        let parameters = [
            "title": "service 1 title",
            "description": "service 1 description",
            "price": "11",
            "images": imagesData
        ]
        print(images.count)
        Alamofire.request(.POST, URL, parameters: parameters as! [String : AnyObject]).validate().response { (request, response, data, error) in
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
    func imagesToBase64(images: [UIImage]) -> [String]{
        var imagesData = [String]()
        for image in images {
            let imageData = UIImagePNGRepresentation(image)
            let base64String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
            imagesData.append(base64String)
        }
        print(imagesData[0])
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
        
        Alamofire.request(.GET, URL, parameters: nil/**, headers: headers*/).responseJSON { response in
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
