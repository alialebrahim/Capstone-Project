//
//  addPredefinedService.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 7/8/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit
//TODO: dynamic content size
//TODO: delegate to remove picture
class addPredefinedService: UIViewController, UITextViewDelegate, iCarouselDelegate, iCarouselDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate, AvailableServiceHoursDelegate, AvailableServiceDaysDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var daysTakenTextField: UITextField!
    @IBOutlet weak var hoursTakenTextField: UITextField!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var picturesLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var availableServiceDaysButton: UIButton!
    @IBOutlet weak var availableServiceHoursButton: UIButton!
    @IBOutlet weak var picturesView: iCarousel!
    @IBOutlet weak var arowImage: UIImageView! //TODO: change spelling
    @IBOutlet weak var rightArowImage: UIImageView! //TODO: change spelling
    
    
    
    //MARK: Variables
    var currency: String?
    var availableServiceHours = [(String, String)]()
    var availableServiceDays = [Int]()
    var border: UIView!
    var pictures = [UIImage]()
    let imagePicker = UIImagePickerController()
    var buttonName = "Add"
    var serviceID = -1
    
    //MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
            1-this is done in the storyboard and it is needed!:
                descriptionTextView.scrollEnabled = false
            2-arow images are both hidden from the storyboard.
         */
        setup()
        configureNavigationBar()
        
        if serviceID != -1 {
            fillingTheInfo()
        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        addLine(UIColor(hex: 0xC7C7CD), width: 1)
        titleTextField.addBottomBorderWithColor(UIColor(hex: 0xC7C7CD), width: 1)
        priceTextField.addBottomBorderWithColor(UIColor(hex: 0xC7C7CD), width: 1)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //rotate left arrow picture
        arowImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        
        adjustContentViewHeight()
    }
    
    //MARK: IBActions
    @IBAction func addPicturePressed() {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    @IBAction func availableServiceDaysButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("availableServiceDays", sender: self)
    }
    
    @IBAction func availableServiceHoursButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("availableServiceHours", sender: self)
    }
    
    //MARK: available service hours delegate function
    func shouldDismissHoursView(times: [(from: NSDate, to: NSDate)]) {
        if !times.isEmpty {
            var from: String
            var to: String
            let formatTime = NSDateFormatter()
            
            formatTime.timeStyle = .ShortStyle
            
            //Converting Hours to 24:00 form
            formatTime.dateFormat = "HH:mm"
            
            availableServiceHoursButton.setTitle("Available Service Times", forState: .Normal)
            for time in times {
                from = formatTime.stringFromDate(time.from)
                to = formatTime.stringFromDate(time.to)
                availableServiceHours.append((from, to))
            }
            print(availableServiceHours)
            
        }else {
            availableServiceHoursButton.setTitle("+Available Service Times", forState: .Normal)
        }
        presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: available service days delegate function
    func shouldDismissDaysView(days: [Int]) {
        if !days.isEmpty {
            availableServiceDays = days
            print(availableServiceDays)
            availableServiceDaysButton.setTitle("Available Service Days", forState: .Normal)
        }else {
            availableServiceDaysButton.setTitle("+Available Service Days", forState: .Normal)
        }
        presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: iCarousel Delegate Function (for services images)
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return pictures.count
    }
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        let tempView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        tempView.contentMode = .ScaleAspectFill
        tempView.clipsToBounds = true
        tempView.image = pictures[index]
        return tempView
    }
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.Spacing {
            return value*1.1
        }
        return value
    }
    func carousel(carousel: iCarousel, didSelectItemAtIndex index: Int) {
        performSegueWithIdentifier("ImagePreviewVC", sender: index)
    }
    
    //MARK: Functions
    func setup() {

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(addPredefinedService.keyboardWillShow(_:)), name: UIKeyboardDidChangeFrameNotification, object: nil)
        
        automaticallyAdjustsScrollViewInsets = false
        
        imagePicker.delegate = self
        
        picturesView.delegate = self
        picturesView.dataSource = self
        picturesView.type = .Linear
        picturesView .reloadData()
        picturesView.clipsToBounds = true
        
        descriptionTextView.delegate = self
        
        currency = "KWD"
        if let myCurrency = currency {
            priceTextField.placeholder = "Price in \(myCurrency)"
        }
        priceTextField.keyboardType = .NumberPad
        
        //textview placeholder setup
        descriptionTextView.text = "Description"
        if serviceID == -1 {
            descriptionTextView.textColor = UIColor(hex: 0xC7C7CD)
        }
        descriptionTextView.selectedTextRange = descriptionTextView.textRangeFromPosition(descriptionTextView.beginningOfDocument, toPosition: descriptionTextView.beginningOfDocument)
        
        //setup textfields and textview textColor
        titleTextField.textColor = UIColor.darkTextColor()
        
        daysTakenTextField.placeholder = "0"
        daysTakenTextField.keyboardType = .NumberPad
        
        hoursTakenTextField.placeholder = "0"
        hoursTakenTextField.keyboardType = .NumberPad
    }
    func configureNavigationBar() {
        let addBarButtonItem = UIBarButtonItem(title: buttonName, style: .Plain , target: self, action: #selector(addPredefinedService.addService))
        navigationItem.rightBarButtonItem = addBarButtonItem
        navigationItem.title = "Add Service"
    }
    func addService() {
        //update the changes to the server
        self.navigationController?.popViewControllerAnimated(true)
    }
    func adjustContentViewHeight() {
        var contentRect = CGRectZero
        for view in contentView.subviews {
            contentRect = CGRectUnion(contentRect, view.frame)
        }
        contentViewHeight.constant = contentRect.size.height+20
    }
    func fillingTheInfo () {
        titleTextField.text = "title of service"
        descriptionTextView.text = "text view description bla bla bla text view description bla bla bla text view description bla bla bla text view description bla bla bla text view description bla bla bla."
        priceTextField.text = "55"
    }
    func addLine(color: UIColor, width: CGFloat) {
        if border != nil {
            border.removeFromSuperview()
            border = nil
        }
        
        border = UIView()
        border.frame = CGRectMake(descriptionTextView.frame.origin.x, descriptionTextView.frame.origin.y+descriptionTextView.frame.height-width, descriptionTextView.frame.width, width)
        border.backgroundColor = color
        descriptionTextView.superview!.insertSubview(border, aboveSubview: descriptionTextView)
        descriptionTextView.layoutIfNeeded()
    }
    func keyboardWillShow(notification: NSNotification) {
        var userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        var contentInset = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
        scrollView.contentInset.top = 0
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    //TextView delegate functions
    /*
        textview delegate functions are used to implement textview placehold
     */
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:NSString = textView.text
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor(hex: 0xC7C7CD)
            
            textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if textView.textColor == UIColor(hex: 0xC7C7CD) && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
        return true
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        
        if self.view.window != nil {
            if textView.textColor == UIColor(hex: 0xC7C7CD) {
                textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            }
        }
    }
    func textViewDidChange(textView: UITextView) {
        adjustContentViewHeight()
    }
    
    //MARK: ImagePicker delegates
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pictures.append(pickedImage)
            picturesView.reloadData()
            if picturesView.numberOfVisibleItems < pictures.count {
                arowImage.hidden = false
                rightArowImage.hidden = false
            }else {
                arowImage.hidden = true
                rightArowImage.hidden = true
            }
            
            //TODO: remove if statement
            if pictures.count == 2 {
                picturesView.scrollToItemAtIndex(0, animated: true)
            }else {
                picturesView.scrollToItemAtIndex(pictures.count-2, animated: true)
            }
            
            print(pictures.count)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Segue functions
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let myIndex = sender as? Int
        if segue.identifier == "ImagePreviewVC" {
            if let vc = segue.destinationViewController as? ImagePreview {
                if let index = myIndex {
                    vc.imageIndex = index
                    vc.image = pictures[index]
                }
                
            }
        }else if segue.identifier == "availableServiceHours" { //popover
            if let vc = segue.destinationViewController as? AvailableServiceHoursVC {
                vc.delegate = self
                vc.modalInPopover = true
                //to change poped over view:
                //vc.preferredContentSize.width = self.view.frame.size.width-20
                if let controller = vc.popoverPresentationController {
                    controller.delegate = self
                    let height = (navigationController?.navigationBar.frame.height)! + UIApplication.sharedApplication().statusBarFrame.height
                    controller.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), height,0,0)
                    controller.passthroughViews = nil
                    //set it to zero to remove arrow
                    controller.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 1)
                }
            }
        }else if segue.identifier == "availableServiceDays" { //popover
            if let vc = segue.destinationViewController as? AvailableServiceDaysVC {
                vc.delegate = self
                vc.modalInPopover = true
                if let controller = vc.popoverPresentationController {
                    controller.delegate = self
                    let height = (navigationController?.navigationBar.frame.height)! + UIApplication.sharedApplication().statusBarFrame.height
                    controller.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), height,0,0)
                    controller.passthroughViews = nil
                    //set it to zero or remove arrow
                    controller.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 1)
                }
            }
        }
    }
}
