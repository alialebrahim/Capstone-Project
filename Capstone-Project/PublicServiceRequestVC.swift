//
//  PublicServiceRequestVC.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 9/12/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

class PublicServiceRequestVC: UIViewController, UITextViewDelegate, ChooseCategoriesVCDelegate {

    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var serviceDescription: UITextView!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    var year: Int!
    var month: Int!
    var day: Int!
    var choosenCategory: String = Categories.Others.rawValue
    
    var submitRequestButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("submit", forState: .Normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blackColor().CGColor
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        automaticallyAdjustsScrollViewInsets = false
        adjustContentViewHeight()
        //scrollView.contentInset.top = 0
    }
    func setup() {
        setupNavigationBar()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        let keyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(keyboardGesture)
        serviceDescription.delegate = self
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), forControlEvents: .ValueChanged)
        
        let components = datePicker.calendar.components([.Year, .Month, .Day],
                                                        fromDate: datePicker.date)
        year = components.year
        month = components.month
        day = components.day
        
        print(year)
        print(month)
        print(day)
        
        self.view.addSubview(submitRequestButton)
        submitRequestButton.addTarget(self, action: #selector(submitButtonAction), forControlEvents: .TouchUpInside)
        submitRequestButton.topAnchor.constraintEqualToAnchor(datePicker.bottomAnchor, constant: 20).active = true
        submitRequestButton.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        
    }
    func datePickerValueChanged() {
        print("value changed")
        let components = datePicker.calendar.components([.Year, .Month, .Day],
                                                     fromDate: datePicker.date)
        year = components.year
        month = components.month
        day = components.day
        
        print(year)
        print(month)
        print(day)
    }
    func hideKeyboard() {
        print("will hide keyboard now")
        view.endEditing(true)
    }
    func setupNavigationBar() {
        navigationItem.title = "Submit a request"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log", style: .Plain, target: self, action: #selector(requestLog))
    }
    func requestLog() {
        performSegueWithIdentifier("RequestLog", sender: nil)
    }
    func validateDate() -> Bool {
        print("will validate date")
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        
        let currentYear =  components.year
        let currentMonth = components.month
        let currentDay = components.day
        print(currentYear)
        print(currentMonth)
        print(currentDay)
        
        ///////////////////////
        
        if year > currentYear {
            return true
        }else if year == currentYear && (month == currentMonth || month > currentMonth) && (day == currentDay || day > currentDay) {
            return true
        }else {
            return false
        }
        
    }
    func adjustContentViewHeight() {
        var contentRect = CGRectZero
        for view in contentView.subviews {
            contentRect = CGRectUnion(contentRect, view.frame)
        }
        contentViewHeightContraint.constant = contentRect.size.height+20
    }
    func keyboardWillShow(notification: NSNotification) {
        //TODO: content offset is not correct when emoj keyboard appear.
        var userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        var contentInset = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
        scrollView.contentInset.top = 0
        
    }
    func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsetsZero
    }
    func textViewDidChange(textView: UITextView) {
        //TODO: when textfield frame changes scroll to a specific position.
        //TODO: bug when deleting all text in a textview nothing happens
        adjustContentViewHeight()
        
    }
    
    @IBAction func categoryButtonPressed(sender: UIButton) {
        print("category button pressed")
        performSegueWithIdentifier("chooseCategory", sender: nil)
        
    }
    
    func didSelectCategory(category: String) {
        choosenCategory = category
        categoryButton.setTitle("\(choosenCategory)  >", forState: .Normal)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "chooseCategory" {
            if let vc = segue.destinationViewController as? ChooseCategoriesVC {
                vc.delegate = self
            }
        }
    }
    func submitButtonAction() {
        print("will submit a public request")
        if validateDate() {
            print("corrent")
        }else {
            print("incorrect")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}