//
//  OfferedServiceDetails.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 9/19/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class OfferedServiceDetails: UIViewController, iCarouselDelegate, iCarouselDataSource {
    @IBOutlet weak var picturesView: iCarousel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var selectDayButton: UIButton!
    @IBOutlet weak var selectTimeButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    var serviceImages = [UIImage]()
    var myService: JSON?
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        adjustContentViewHeight()
        print("OFFERED SERVICE DETAIL: \(myService)")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setup() {
        automaticallyAdjustsScrollViewInsets = false
        navigationBarSetup()
        
        //////
        descriptionTextView.text = myService!["service"]["description"].string
        priceLabel.text = "\(myService!["service"]["price"].float!)"
        
        picturesView.delegate = self
        picturesView.dataSource = self
        picturesView.type = .linear
        picturesView .reloadData()
        picturesView.clipsToBounds = true
        
        ////
        serviceImages.append(UIImage(named: "profileImagePlaceholder")!)
        serviceImages.append(UIImage(named: "profileImagePlaceholder")!)
        serviceImages.append(UIImage(named: "profileImagePlaceholder")!)
        picturesView.reloadData()
        ////
    }
    func navigationBarSetup() {
        navigationItem.title = myService!["service"]["title"].string
    }
    func adjustContentViewHeight() {
        print("im here")
        var contentRect = CGRect.zero
        for view in containerView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        containerViewHeight.constant = contentRect.size.height+20
    }
    //MARK: iCarousel Delegate function
    //MARK: iCarousel Delegate Function (for services images)
    func numberOfItems(in carousel: iCarousel) -> Int {
        if let serviceDectionary = myService!["serviceimage_set"] as? [NSDictionary] {
            print("my list is not empty")
        }else {
            print("my list is empty")
        }
        return 0
    }
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let tempView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        tempView.contentMode = .scaleAspectFill
        tempView.clipsToBounds = true
        tempView.image = serviceImages[index]
        return tempView
    }
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.spacing {
            return value*1.1
        }
        return value
    }
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        performSegue(withIdentifier: "ImagePreviewVC", sender: index)
    }
    @IBAction func SelectDayButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "SelectDay", sender: nil)
    }
    @IBAction func selectTimeButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "SelectTime", sender: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let myIndex = sender as? Int
        if segue.identifier == "ImagePreviewVC" {
            if let vc = segue.destination as? ImagePreview {
                if let index = myIndex {
                    vc.imageIndex = index
                    vc.image = serviceImages[index]
                }
                
            }
        }
    }
    @IBAction func requestServiceAction(_ sender: AnyObject) {
        print("will request this service")
        requestOfferedServiceWithPK(myService!["id"].int!)
    }
    func requestOfferedServiceWithPK(_ pk: Int) {
        let URL = "\(AppDelegate.URL)/request/"
        if let myToken = defaults.object(forKey: "userToken") as? String{
            print(myToken)
            let headers = [
                "Authorization": myToken
            ]
            let parameters = [
                "servicepk": pk
            ]
            Alamofire.request(URL, method: .post, parameters: parameters, headers: headers).responseJSON(completionHandler: { (response) in
                print("request")
                print(response.request!)  // original URL request
                print("response")
                print(response.response!) // URL response
                print("data")
                print(response.data!)     // server data
                print("result")
                print(response.result)   // result of response serialization

                if response.response?.statusCode == 201 {
                    if let json = response.result.value {
                        print("my json")
                        print(json)
                        let myJson = JSON(json)
                        print(myJson)
                    }
                    
                    if let mydata = String(data: response.data!, encoding: String.Encoding.utf8) {
                        print("my data from getting profile request is \(mydata)")
                    }
                }else {
                    if let mydata = String(data: response.data!, encoding: String.Encoding.utf8) {
                        print("my data from getting profile request is \(mydata)")
                    }
                }
            })

        }
    }
}
