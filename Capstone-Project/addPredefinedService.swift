//
//  addPredefinedService.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 7/8/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
//TODO: dynamic content size
//TODO: delegate to remove picture
class addService: UIViewController, UITextViewDelegate, iCarouselDelegate, iCarouselDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate, AvailableServiceHoursDelegate, AvailableServiceDaysDelegate, CategoriesVCDelegate {
 
    //MARK: Outlets
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var availableServiceDaysButton: UIButton!
    @IBOutlet weak var availableServiceHoursButton: UIButton!
    @IBOutlet weak var picturesView: iCarousel!
    @IBOutlet weak var carouselView: iCarousel!
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var chooseCategoryView: UIView!
    @IBOutlet weak var addPictureView: UIView!
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var categoryImageView: UIImageView!
    //MARK: Variables
    var currency: String?
    var availableServiceHours = [(String, String)]()
    var availableServiceDays = [Int]()
    var border: UIView!
    var pictures = [UIImage]()
    var picturesImageView = [UIImageView]()
    let imagePicker = UIImagePickerController()
    var buttonName = "Add"
    var dimView: UIView!
    let defaults = UserDefaults.standard
    var willEdit = false
    var pictureThatWillBeDeleted: UIImageView!
    var right = true
    var serviceID: Int?
    var myCategories = [String]()
    //MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dimView = UIView(frame: self.view.bounds)
        dimView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        /*
            1-this is done in the storyboard and it is needed!:
                descriptionTextView.scrollEnabled = false
            2-arow images are both hidden from the storyboard.
         */
        setup()
        carouselView.clipsToBounds = false
        configureNavigationBar()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //addLine(UIColor(hex: 0xC7C7CD), width: 1)
        titleTextField.addBottomBorderWithColor(UIColor(hex: 0xa85783), width: 1)
        priceTextField.addBottomBorderWithColor(UIColor(hex: 0xa85783), width: 1)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //rotate left arrow picture
        adjustContentViewHeight()
        if willEdit {
            if let myID = serviceID {
                offeredServiceDetails(myID)
            }
            
        }
    }
    
    //MARK: IBActions
    @IBAction func addPicturePressed() {
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func availableServiceDaysButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "availableServiceDays", sender: self)
    }
    
    @IBAction func availableServiceHoursButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "availableServiceHours", sender: self)
    }
    @IBAction func categoryButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "CategoriesVC", sender: nil)
    }
    
    //MARK: available service hours delegate function
    func shouldDismissHoursView(_ times: [(from: Date, to: Date)]) {
        dimView.removeFromSuperview()
        if !times.isEmpty {
            var from: String
            var to: String
            let formatTime = DateFormatter()
            
            formatTime.timeStyle = .short
            
            //Converting Hours to 24:00 form
            formatTime.dateFormat = "HH:mm"
            
            availableServiceHoursButton.setTitle("Available Service Times", for: UIControlState())
            for time in times {
                from = formatTime.string(from: time.from)
                to = formatTime.string(from: time.to)
                availableServiceHours.append((from, to))
            }
            print(availableServiceHours)
            
        }else {
            availableServiceHoursButton.setTitle("+Available Service Times", for: UIControlState())
        }
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: available service days delegate function
    func shouldDismissDaysView(_ days: [Int]) {
        dimView.removeFromSuperview()
        if !days.isEmpty {
            availableServiceDays = days
            print(availableServiceDays)
            availableServiceDaysButton.setTitle("Available Service Days", for: UIControlState())
        }else {
            availableServiceDaysButton.setTitle("+Available Service Days", for: UIControlState())
        }
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: iCarousel Delegate Function (for services images)
    func numberOfItems(in carousel: iCarousel) -> Int {
        return pictures.count
    }
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let tempView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressOnImage(_:)))
        tempView.isUserInteractionEnabled = true
        tempView.addGestureRecognizer(longPress)
        tempView.contentMode = .scaleAspectFill
        tempView.clipsToBounds = true
        tempView.image = pictures[index]
        picturesImageView.append(tempView)
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
    
    //MARK: Functions
    func didLongPressOnImage(_ gestureReconizer: UILongPressGestureRecognizer) {
        print("testing")
        let deleteButton = UIButton()
        deleteButton.isUserInteractionEnabled = true
        deleteButton.setTitle("test", for: UIControlState())
        deleteButton.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        deleteButton.addTarget(self, action: #selector(deletePicture), for: .touchUpInside)
        if let myView = gestureReconizer.view {
            if let imageView = myView as? UIImageView {
                print("im here")
                //TODO: Animate the view
                //TODO: figure out a way to stop gesture and remove added button!
                deleteButton.frame = myView.bounds
                pictureThatWillBeDeleted = imageView
                imageView.addSubview(deleteButton)
                animateSelectedToDeleteImage(imageView)
            }
        }
    }
    func animateSelectedToDeleteImage(_ imageView: UIImageView) {
        UIView.animate(withDuration: 0.25, animations: {
            imageView.transform = CGAffineTransform(rotationAngle: CGFloat((M_PI * (-5) / 180.0)))
        }) 
        rotateRightAnimation(imageView)
    }
    func rotateRightAnimation(_ imageView: UIImageView) {
        UIView.animate(withDuration: 0.25, delay: 0, options:  [.autoreverse, .repeat, .allowUserInteraction], animations: {
            imageView.transform = CGAffineTransform(rotationAngle: CGFloat((M_PI * (5) / 180.0)))
        }) { (completed) in
            if completed {
                print("im here")
            }
        }
    }
    func deletePicture() {
        print("testing delete picture button")
        for imageView in picturesImageView {
            if imageView == pictureThatWillBeDeleted {
                let myImage = imageView.image!
                for image in pictures {
                    if myImage == image {
                        pictures.removeObject(myImage)
                        picturesImageView.removeObject(imageView)
                        picturesView .reloadData()
                    }
                }
            }
        }
    }
    func setup() {

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
        
        automaticallyAdjustsScrollViewInsets = false
        
        imagePicker.delegate = self
        
        picturesView.delegate = self
        picturesView.dataSource = self
        picturesView.type = .linear
        picturesView .reloadData()
        picturesView.clipsToBounds = true
        
        descriptionTextView.delegate = self
        
        currency = ""
        if currency != nil {
            priceTextField.placeholder = "Price in local currency"
        }
        priceTextField.keyboardType = .numberPad
        
        //textview placeholder setup
        descriptionTextView.text = "Description"
        descriptionTextView.selectedTextRange = descriptionTextView.textRange(from: descriptionTextView.beginningOfDocument, to: descriptionTextView.beginningOfDocument)
        
        //setup textfields and textview textColor
        titleTextField.textColor = UIColor.darkText
        
        chooseCategoryView.addBottomBorderWithColor(UIColor(hex: 0x404040), width: 1)
        addPictureView.addBottomBorderWithColor(UIColor(hex: 0x404040), width: 1)
        chooseCategoryView.addLeadingBorderWithColor(UIColor(hex: 0x404040), width: 1)
        imageContainerView.addTopBorderWithColor(UIColor(hex: 0xa85783), width: 1)
        imageContainerView.addBottomBorderWithColor(UIColor(hex: 0xa85783), width: 1)
        
        //MARK: change image tint color
         let origImage = cameraImageView.image!
         let tintedImage = origImage.withRenderingMode(.alwaysTemplate)
         cameraImageView.image = tintedImage
         cameraImageView.tintColor = UIColor(hex: 0x404040)
         cameraImageView.contentMode = .scaleAspectFit
        
        let origImage1 = categoryImageView.image!
        let tintedImage1 = origImage1.withRenderingMode(.alwaysTemplate)
        categoryImageView.image = tintedImage1
        categoryImageView.tintColor = UIColor(hex: 0x404040)
        categoryImageView.contentMode = .scaleAspectFit
        
        
    }
    func configureNavigationBar() {
        if willEdit {
            let editBarButtonItem = UIBarButtonItem(title: "update", style: .plain , target: self, action: #selector(editService))
            navigationItem.rightBarButtonItem = editBarButtonItem
        }else {
            let addBarButtonItem = UIBarButtonItem(title: "Add", style: .plain , target: self, action: #selector(addService))
            navigationItem.rightBarButtonItem = addBarButtonItem
        }
        navigationItem.title = "Add Service"
    }
    func editService() {
        let title = titleTextField.text
        let description = descriptionTextView.text
        let price = priceTextField.text
        updatingOfferedService(title!, description: description!, price: price!)
    }
    func addService() {
        //BACKEND REQUEST FUNCTION
        offeredServiceCreation("food", title: titleTextField.text!, description: descriptionTextView.text!, price: priceTextField.text!)
    }
    func adjustContentViewHeight() {
        var contentRect = CGRect.zero
        for view in contentView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        contentViewHeight.constant = contentRect.size.height+20
    }
    func keyboardWillShow(_ notification: Notification) {
        var userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        var contentInset = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
        scrollView.contentInset.top = 0
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    func alertWithMessage(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    //TextView delegate functions
    /*
        textview delegate functions are used to implement textview placehold
     */
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:NSString = textView.text as NSString
        let updatedText = currentText.replacingCharacters(in: range, with:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor(hex: 0xC7C7CD)
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if textView.textColor == UIColor(hex: 0xC7C7CD) && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        
        if self.view.window != nil {
            if textView.textColor == UIColor(hex: 0xC7C7CD) {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        adjustContentViewHeight()
    }
 

    //MARK: ImagePicker delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pictures.append(pickedImage)
            picturesView.reloadData()
            
            //TODO: remove if statement
            if pictures.count == 2 {
                picturesView.scrollToItem(at: 0, animated: true)
            }else {
                picturesView.scrollToItem(at: pictures.count-2, animated: true)
            }
            
            print(pictures.count)
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Segue functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.view.addSubview(dimView)
        let myIndex = sender as? Int
        if segue.identifier == "ImagePreviewVC" {
            if let vc = segue.destination as? ImagePreview {
                if let index = myIndex {
                    vc.imageIndex = index
                    vc.image = pictures[index]
                }
                
            }
        }else if segue.identifier == "availableServiceHours" { //popover
            if let vc = segue.destination as? AvailableServiceHoursVC {
                vc.delegate = self
                vc.isModalInPopover = true
                //to change poped over view:
                //vc.preferredContentSize.width = self.view.frame.size.width-20
                if let controller = vc.popoverPresentationController {
                    controller.delegate = self
                    let height = (navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
                    controller.sourceRect = CGRect(x: self.view.bounds.midX, y: height,width: 0,height: 0)
                    controller.passthroughViews = nil
                    //set it to zero to remove arrow
                    controller.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 1)
                }
            }
        }else if segue.identifier == "availableServiceDays" { //popover
            if let vc = segue.destination as? AvailableServiceDaysVC {
                vc.delegate = self
                vc.isModalInPopover = true
                if let controller = vc.popoverPresentationController {
                    controller.delegate = self
                    let height = (navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
                    controller.sourceRect = CGRect(x: self.view.bounds.midX, y: height,width: 0,height: 0)
                    controller.passthroughViews = nil
                    //set it to zero or remove arrow
                    controller.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 1)
                }
            }
        }else if segue.identifier == "CategoriesVC" {
            if let vc = segue.destination as? CategoriesVC {
                vc.delegate = self
            }
        }
    }
    //MARK: Categories vc delegate functions 
    func shouldDismissCategoriesView(_ categories: [String]) {
        myCategories = categories
        //categoryButton.setTitle(myCategories[0], forState: .Normal)
        categoryLabel.text = myCategories[0]
        dimView.removeFromSuperview()
        navigationController?.popViewController(animated: true)
    }
    //MARK: BACKEND
    func offeredServiceCreation(_ category: String, title: String, description: String, price: String) {
        if let myToken = defaults.object(forKey: "userToken") as? String {
            print("token-> \"\(myToken)\"")
            let headers = [
                "Authorization": myToken
            ]
            let URL = "\(AppDelegate.URL)/offeredservice/"
            var imagesDictonaryList = [[String : AnyObject]]()
            let imagesData = imagesToBase64(pictures)
            for index in 0..<imagesData.count {
                var myDictionary = [String:AnyObject]()
                myDictionary["name"] = "\(index)" as AnyObject?
                myDictionary["image"] = imagesData[index] as AnyObject?
                imagesDictonaryList.append(myDictionary)
            }
            let service : [String: AnyObject] = [
                "title": title as AnyObject,
                "description": description as AnyObject,
                "price": price as AnyObject
            ]
            let parameters = [
                "category" : category,
                "service": service,
                "serviceimage_set": imagesDictonaryList
            ] as [String : Any]
            print("im here")
            Alamofire.request(.POST, URL, parameters: parameters as? [String : AnyObject], headers: headers, encoding: .json).responseJSON { response in
                //            print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                if let dataString = String(data: response.data!, encoding: String.Encoding.utf8) {
                    print(dataString)
                }
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                if response.response?.statusCode == 201 {
                    self.navigationController?.popViewController(animated: true)
                }else {
                    self.alertWithMessage("could not create offered service, please try again")
                }
            }
        }
    }
    func offeredServiceDetails(_ id: Int?) {
        //TODO: add loading animation only for the first time.
        let URL = "\(AppDelegate.URL)/offeredservice/"
        
        let parameter:[String:Int]
        if let myId = id {
            parameter = [
                "servicepk": myId
            ]
        }else {
            parameter = [
                "servicepk": 0
            ]
        }
        Alamofire.request(.GET, URL, parameters: parameter).responseJSON { response in
            if let myResponse = response.response {
                if myResponse.statusCode == 200 {
                    if let json = response.result.value {
                        let myJson = JSON(json)
                        /*
                         
                         let title = myOfferedServices[index]["service"]["title"].string
                         let description = myOfferedServices[index]["service"]["description"].string
                         let category = myOfferedServices[index]["category"].string
                         let price = myOfferedServices[index]["service"]["price"].float
                         let id = myOfferedServices[index]["id"].int
                         
                         */
                        if let myTitle = myJson["service"]["title"].string {
                            self.titleTextField.text = myTitle
                        }else {
                            self.titleTextField.text = "no title"
                        }
                        if let myDescription = myJson["service"]["description"].string {
                            self.descriptionTextView.text = myDescription
                        }else {
                            self.descriptionTextView.text = "no description"
                        }
                        if let myPrice = myJson["service"]["price"].float {
                            self.priceTextField.text = "\(myPrice)"
                        }else {
                            self.descriptionTextView.text = "no price"
                        }
                    }
                }else {
                    self.alertWithMessage("There was a problem getting offered services\n please try again")
                }
            }else {
                self.alertWithMessage("There was a problem getting offered services\n please try again")
            }
        }
    }
    /*
        offered service
        put method
        service pk
     */
    func updatingOfferedService(_ title: String, description: String, price: String) {
        if let myToken = defaults.object(forKey: "userToken") as? String {
            print("token-> \"\(myToken)\"")
            let headers = [
                "Authorization": myToken
            ]
            let URL = "\(AppDelegate.URL)/offeredservice/"
            let imagesDictonaryList = [[String : AnyObject]]()
            let service : [String: AnyObject] = [
                "title": title as AnyObject,
                "description": description as AnyObject,
                "price": price as AnyObject
            ]
            print("service pk is \(serviceID!)")
            let parameters = [
                "service": service,
                "servicepk":serviceID!,
                "serviceimage_set": imagesDictonaryList
            ] as [String : Any]
            print("im here")
            Alamofire.request(.PUT, URL, parameters: parameters as? [String : AnyObject], headers: headers, encoding: .json).responseJSON { response in
                //            print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                if let dataString = String(data: response.data!, encoding: String.Encoding.utf8) {
                    print(dataString)
                }
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                if response.response?.statusCode == 200 {
                    self.navigationController?.popViewController(animated: true)
                }else {
                    self.alertWithMessage("could not create offered service, please try again")
                }
            }
        }
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
}
