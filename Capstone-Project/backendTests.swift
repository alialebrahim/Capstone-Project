///////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//func signUpTest() {
//    let URL = "\(self.URL)/signup/"
//    let parameters = [
//        "username": self.username,
//        "password": self.password
//    ]
//    
//    Alamofire.request(.POST, URL, parameters: parameters, encoding: .JSON).responseJSON { response in
//        print(response.request)  // original URL request
//        print(response.response) // URL response
//        print(response.data)     // server data
//        if let requestData = response.data {
//            if let dataString = String(data: requestData, encoding: NSUTF8StringEncoding) {
//                self.storeToken(dataString)
//            }
//        }
//        print(response.result)   // result of response serialization
//        if response.response?.statusCode == 201 {
//            if let json = response.result.value {
//                print("my json")
//                print(json)
//                let myJson = JSON(json)
//                if let userID = myJson["userid"].string {
//                    print("user id")
//                    print(userID)
//                }
//            }
//            if let mydata = String(data: response.data!, encoding: NSUTF8StringEncoding) {
//                print(mydata)
//            }
//        }else {
//            print("not successful")
//        }
//        
//    }
//}
//func profileTest() {
//    let URL = "\(self.URL)/profile/"
//    
//    
//    /*
//     # username = models.CharField(max_length=100)
//     usertype = models.CharField(max_length=101, default="seeker") #Make this into choices
//     about = models.TextField(null=True, blank=True)
//     phone_number = models.CharField(max_length=100, null=True, blank=True)
//     email = models.EmailField(null=True, blank=True)
//     image = models.ImageField(upload_to="providers", null=True, blank=True)
//     
//     rating = models.FloatField(default=0.0)
//     country = models.CharField(max_length=100, null=True, blank=True)
//     area = models.CharField(max_length=100, null=True, blank=True)
//     street_address = models.CharField(max_length=100, null=True, blank=True)
//     */
//    if let myToken = defaults.objectForKey("userToken") as? String{
//        print(myToken)
//        let headers = [
//            "Authorization": myToken
//        ]
//        let parameters = [
//            "usertype": self.userType,
//            "about": "haha I'm funny lol xD #yolo",
//            "email": "cooldude69@yahoo.com",
//            "phone_number": "97797310",
//            "rating": 6.9,
//            "country": "Kuwait",
//            "area": "skdhb",
//            "street_address": "blah blah blah"
//            
//        ]
//        
//        Alamofire.request(.PUT, URL, parameters: parameters as? [String : AnyObject], headers: headers, encoding: .JSON).responseJSON { response in
//            print(response.request)  // original URL request
//            print(response.response) // URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
//            
//            if let requestData = response.data {
//                if let dataString = String(data: requestData, encoding: NSUTF8StringEncoding) {
//                    self.storeToken(dataString)
//                }
//            }
//            
//            
//        }
//    }
//}
//
//func logTest() {
//    let URL = "\(self.URL)/log/"
//    
//    if let myToken = defaults.objectForKey("userToken") as? String{
//        print(myToken)
//        let headers = [
//            "Authorization": myToken
//        ]
//        
//        Alamofire.request(.GET, URL, headers: headers, encoding: .JSON).responseJSON { response in
//            print(response.request)  // original URL request
//            print(response.response) // URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
//            if let dataString = String(data: response.data!, encoding: NSUTF8StringEncoding) {
//                print(dataString)
//            }
//            if let JSON = response.result.value {
//                print("JSON: \(JSON)")
//            }
//        }
//    }
//}
//func loginTest() {
//    let URL = "\(self.URL)/login/"
//    let parameters = [
//        "username": self.username,
//        "password": self.password
//    ]
//    
//    print("username -> \"\(parameters["username"])\"")
//    print("password -> \"\(parameters["password"])\"")
//    
//    Alamofire.request(.POST, URL, parameters: parameters, encoding: .JSON).validate().response {
//        (request, response, data, error) in
//        if (response?.statusCode)! == 200 {
//            if let requestData = data {
//                if let dataString = String(data: requestData, encoding: NSUTF8StringEncoding) {
//                    print("dataString-> \"\(dataString)\"")
//                    self.storeToken(dataString)
//                }
//            }
//        }else {
//            //did not login
//            print("did not login")
//        }
//        print("request")
//        print(request)
//        print("response")
//        print(response)
//        print("data")
//        print(data)
//        print("error")
//        print(error)
//    }
//    
//}
//func feedTest() {
//    
//    let URL = "http://81.4.110.27/predefinedservice/"
//    
//    Alamofire.request(.GET, URL, parameters: nil).responseJSON { response in
//        print(response.request)  // original URL request
//        print(response.response) // URL response
//        print(response.data)     // server data
//        print(response.result)   // result of response serialization
//        if let mydata = String(data: response.data!, encoding: NSUTF8StringEncoding) {
//            print(mydata)
//        }
//        if let JSON = response.result.value {
//            print("JSON: \(JSON)")
//        }
//    }
//}
//
//func storeToken(token: String) {
//    print(token)
//    defaults.setObject(token, forKey: "userToken")
//    
//    //this is how to get the token back.
//    /*****************************************************
//     if let mytoken = defaults.objectForKey("userToken") {
//     print("from user defaults token is \(mytoken)")
//     }
//     *****************************************************/
//}
//func storeUserID(userID: String) {
//    print(userID)
//    defaults.setObject(userID, forKey: "UserID")
//}
//func publicServiceCreation() {
//    /*
//     
//     “category”: string (defaulted to “other”)
//     “service”: {
//     “title” : string
//     “description” : big string
//     “price” : float
//     “status” : string (defaulted to “pending”)
//     “due_date” : models.DateTimeField(null=True, blank=True)
//     “created” : automatically set to the current server time
//     “is_special” : boolean (defaulted to “false)
//     }
//     
//     */
//    
//    if let myToken = defaults.objectForKey("userToken") as? String{
//        print(myToken)
//        let headers = [
//            "Authorization": myToken
//        ]
//        let URL = "\(self.URL)/publicservice/"
//        
//        let category = "car Services"
//        let service : [String: AnyObject] = [
//            "title" : "new service!",
//            "description" : "Check out this cool new FREE service!!!!",
//            "price" : 0.0,
//            "is_special" : false
//        ]
//        
//        let parameters = [
//            "category": category,
//            "service": service
//        ]
//        
//        Alamofire.request(.POST, URL, parameters: parameters as? [String : AnyObject], headers: headers, encoding: .JSON).responseJSON { response in
//            print(response.request)  // original URL request
//            print(response.response) // URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
//            if let mydata = String(data: response.data!, encoding: NSUTF8StringEncoding) {
//                print(mydata)
//            }
//            if let JSON = response.result.value {
//                print("JSON: \(JSON)")
//            }
//        }
//        
//    }
//}
//func getPublicService() {
//    
//    if let myToken = defaults.objectForKey("userToken") as? String{
//        print(myToken)
//        let headers = [
//            "Authorization": myToken
//        ]
//        let URL = "http://81.4.110.27/publicservice/"
//        
//        Alamofire.request(.GET, URL, parameters: nil, headers: headers).responseJSON { response in
//            print(response.request)  // original URL request
//            print(response.response) // URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
//            if let mydata = String(data: response.data!, encoding: NSUTF8StringEncoding) {
//                print(mydata)
//            }
//            if let JSON = response.result.value {
//                print("JSON: \(JSON)")
//            }
//        }
//        
//    }
//}
//
//func deletionPublicService() {
//    
//    if let myToken = defaults.objectForKey("userToken") as? String{
//        print(myToken)
//        let headers = [
//            "Authorization": myToken
//        ]
//        let URL = "http://81.4.110.27/puiblicservice/3/"
//        
//        Alamofire.request(.DELETE, URL, parameters: nil, headers: headers).responseJSON { response in
//            print(response.request)  // original URL request
//            print(response.response) // URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
//            if let mydata = String(data: response.data!, encoding: NSUTF8StringEncoding) {
//                print(mydata)
//            }
//            if let JSON = response.result.value {
//                print("JSON: \(JSON)")
//            }
//        }
//        
//    }
//}
//func getBids() {
//    if let myToken = defaults.objectForKey("userToken") as? String{
//        print("token -> '\(myToken)'")
//        let headers = [
//            "Authorization": "\(myToken)"
//        ]
//        let URL = "http://81.4.110.27/bid/1/"
//        let parameters = [
//            "bid": 1000
//        ]
//        
//        Alamofire.request(.GET, URL, parameters: parameters, headers: headers, encoding: .JSON).responseJSON { response in
//            print(response.request)  // original URL request
//            print(response.response) // URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
//            if let mydata = String(data: response.data!, encoding: NSUTF8StringEncoding) {
//                print(mydata)
//            }
//            if let JSON = response.result.value {
//                print("JSON: \(JSON)")
//            }
//        }
//        
//    }
//}
//func placeABid() {
//    if let myToken = defaults.objectForKey("userToken") as? String{
//        print("token -> '\(myToken)'")
//        let headers = [
//            "Authorization": "\(myToken)"
//        ]
//        let URL = "http://81.4.110.27/bid/1/"
//        let parameters = [
//            "bid": 1000
//        ]
//        
//        Alamofire.request(.POST, URL, parameters: parameters, headers: headers, encoding: .JSON).responseJSON { response in
//            print(response.request)  // original URL request
//            print(response.response) // URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
//            if let mydata = String(data: response.data!, encoding: NSUTF8StringEncoding) {
//                print(mydata)
//            }
//            if let JSON = response.result.value {
//                print("JSON: \(JSON)")
//            }
//        }
//        
//    }
//}
//func publicServiceUpdate() {
//    
//    if let myToken = defaults.objectForKey("userToken") as? String{
//        print(myToken)
//        let headers = [
//            "Authorization": myToken
//        ]
//        let URL = "http://81.4.110.27/publicservice/2/"
//        
//        let category = "Pet Services"
//        let service : [String: AnyObject] = [
//            "title" : "sjfbs.khdb",
//            "description" : "this is a service description ksdhfks",
//            "price" : 33.2,
//            "is_special" : false
//        ]
//        
//        let parameters = [
//            "category": category,
//            "service": service
//        ]
//        
//        Alamofire.request(.PUT, URL, parameters: parameters as? [String : AnyObject], headers: headers, encoding: .JSON).responseJSON { response in
//            print(response.request)  // original URL request
//            print(response.response) // URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
//            if let mydata = String(data: response.data!, encoding: NSUTF8StringEncoding) {
//                print(mydata)
//            }
//            if let JSON = response.result.value {
//                print("JSON: \(JSON)")
//            }
//        }
//        
//    }
//}
//func gettingOfferedService() {
//    let URL = "http://81.4.110.27/offeredservice/"
//    Alamofire.request(.GET, URL, parameters: nil, encoding: .JSON).responseJSON { response in
//        print(response.request)  // original URL request
//        print(response.response) // URL response
//        print(response.data)     // server data
//        print(response.result)   // result of response serialization
//        if let dataString = String(data: response.data!, encoding: NSUTF8StringEncoding) {
//            print(dataString)
//        }
//        if let JSON = response.result.value {
//            print("JSON: \(JSON)")
//        }
//    }
//}
//func offeredServiceCreation() {
//    if let myToken = defaults.objectForKey("userToken") as? String {
//        print("token-> \"\(myToken)\"")
//        let headers = [
//            "Authorization": myToken
//        ]
//        let URL = "\(self.URL)/offeredservice/"
//        var imagesDictonaryList = [[String : AnyObject]]()
//        var images = [UIImage]()
//        for _ in 1...3 {
//            images.append(UIImage(named: "profileImagePlaceholder")!)
//        }
//        let imagesData = imagesToBase64(images)
//        for index in 0..<3 {
//            var myDictionary = [String:AnyObject]()
//            myDictionary["name"] = "\(index)"
//            myDictionary["image"] = imagesData[index]
//            imagesDictonaryList.append(myDictionary)
//        }
//        //        print(imagesDictonaryList)
//        let service : [String: AnyObject] = [
//            "title": "random title text2",
//            "description": "service 2 description2",
//            "price": "11"
//        ]
//        let parameters = [
//            "category" :"Pets Services2",
//            "service": service,
//            "serviceimage_set": imagesDictonaryList
//        ]
//        Alamofire.request(.POST, URL, parameters: parameters as? [String : AnyObject], headers: headers, encoding: .JSON).responseJSON { response in
//            //            print(response.request)  // original URL request
//            print(response.response) // URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
//            if let dataString = String(data: response.data!, encoding: NSUTF8StringEncoding) {
//                print(dataString)
//            }
//            if let JSON = response.result.value {
//                print("JSON: \(JSON)")
//            }
//        }
//        print("heeh fuck you xD")
//    }
//}
//func imagesToBase64(images: [UIImage]) -> [String]{
//    var imagesData = [String]()
//    for image in images {
//        let imageData = UIImagePNGRepresentation(image)
//        let base64String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
//        imagesData.append(base64String)
//    }
//    return imagesData
//}
//func deleteOfferedService() {
//    if let myToken = defaults.objectForKey("userToken") as? String {
//        print(myToken)
//        let headers = [
//            "Authorization": myToken
//        ]
//        let URL = "http://81.4.110.27/offeredservice/2/"
//        Alamofire.request(.DELETE, URL, parameters: nil, headers: headers).responseJSON { response in
//            print(response.request)  // original URL request
//            print(response.response) // URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
//            if let mydata = String(data: response.data!, encoding: NSUTF8StringEncoding) {
//                print(mydata)
//            }
//            
//        }
//    }
//}
//func deleteOfferedServiceImage() {
//    if let myToken = defaults.objectForKey("userToken") as? String{
//        print(myToken)
//        let headers = [
//            "Authorization": myToken
//        ]
//        let URL = "http://81.4.110.27/offeredimages/7/"
//        
//        Alamofire.request(.DELETE, URL, parameters: nil, headers: headers).responseJSON { response in
//            print(response.request)  // original URL request
//            print(response.response) // URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
//            if let mydata = String(data: response.data!, encoding: NSUTF8StringEncoding) {
//                print(mydata)
//            }
//            if let JSON = response.result.value {
//                print("JSON: \(JSON)")
//            }
//        }
//        
//    }
//}
//func updatingOfferedService() {
//    if let myToken = defaults.objectForKey("userToken") as? String{
//        print(myToken)
//        let headers = [
//            "Authorization": myToken
//        ]
//        let URL = "http://81.4.110.27/offeredservice/2/"
//        
//        let category = "IDK Services"
//        let service : [String: AnyObject] = [
//            "title" : "kkkkkkkkk",
//            "description" : "this is a service description ksdhfks",
//            "price" : 33.2
//        ]
//        
//        let parameters = [
//            "category": category,
//            "service": service,
//            "serviceimage_set": []
//        ]
//        
//        Alamofire.request(.PUT, URL, parameters: parameters as? [String : AnyObject], headers: headers, encoding: .JSON).responseJSON { response in
//            print(response.request)  // original URL request
//            print(response.response) // URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
//            if let mydata = String(data: response.data!, encoding: NSUTF8StringEncoding) {
//                print(mydata)
//            }
//            if let JSON = response.result.value {
//                print("JSON: \(JSON)")
//            }
//        }
//        
//    }
//}
//
//}