//
//  PublicServiceRequestVC.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 9/12/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit
import Alamofire

class PublicServiceRequestVC: UIViewController, UITextViewDelegate, ChooseCategoriesVCDelegate {

    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var serviceDescription: UITextView!
    var year: Int!
    var month: Int!
    var day: Int!
    var choosenCategory: String = Categories.Others.rawValue
    let defaults = UserDefaults.standard
    var submitRequestButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("submit", for: UIControlState())
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitleColor(UIColor.black, for: UIControlState())
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serviceDescription.delegate = self
        setup()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        automaticallyAdjustsScrollViewInsets = false
        adjustContentViewHeight()
        //scrollView.contentInset.top = 0
    }
    func setup() {
        setupNavigationBar()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let keyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(keyboardGesture)
        
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        let components = datePicker.calendar.dateComponents([.year, .month, .day],
                                                        from: datePicker.date)
        year = components.year
        month = components.month
        day = components.day
        
        print(year)
        print(month)
        print(day)
        
        self.view.addSubview(submitRequestButton)
        submitRequestButton.addTarget(self, action: #selector(submitButtonAction), for: .touchUpInside)
        submitRequestButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20).isActive = true
        submitRequestButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        //textview placeholder setup
        serviceDescription.delegate = self
        serviceDescription.text = "Description"
        serviceDescription.textColor = UIColor(hex: 0xC7C7CD)
        serviceDescription.selectedTextRange = serviceDescription.textRange(from: serviceDescription.beginningOfDocument, to: serviceDescription.beginningOfDocument)
        //////////////////////////////
    }
    func datePickerValueChanged() {
        print("value changed")
        let components = datePicker.calendar.dateComponents([.year, .month, .day],
                                                     from: datePicker.date)
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log", style: .plain, target: self, action: #selector(requestLog))
    }
    func requestLog() {
        performSegue(withIdentifier: "RequestLog", sender: nil)
    }
    func validateDate() -> Bool {
        print("will validate date")
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day , .month , .year], from: date)
        
        let currentYear =  components.year
        let currentMonth = components.month
        let currentDay = components.day
        print(currentYear)
        print(currentMonth)
        print(currentDay)
        
        ///////////////////////
        
        if year > currentYear! {
            return true
        }else if year == currentYear! && (month == currentMonth! || month > currentMonth!) && (day == currentDay! || day > currentDay!) {
            return true
        }else {
            return false
        }
        
    }
    func adjustContentViewHeight() {
        var contentRect = CGRect.zero
        for view in contentView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        contentViewHeightContraint.constant = contentRect.size.height+20
    }
    func keyboardWillShow(_ notification: Notification) {
        //TODO: content offset is not correct when emoj keyboard appear.
        var userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        var contentInset = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
        scrollView.contentInset.top = 0
        
    }
    func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
    }
    func textViewDidChange(_ textView: UITextView) {
        //TODO: when textfield frame changes scroll to a specific position.
        //TODO: bug when deleting all text in a textview nothing happens
        adjustContentViewHeight()
        
    }
    
    @IBAction func categoryButtonPressed(_ sender: UIButton) {
        print("category button pressed")
        performSegue(withIdentifier: "chooseCategory", sender: nil)
        
    }
    
    func didSelectCategory(_ category: String) {
        choosenCategory = category
        categoryButton.setTitle("\(choosenCategory)  >", for: UIControlState())
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseCategory" {
            if let vc = segue.destination as? ChooseCategoriesVC {
                vc.delegate = self
            }
        }
    }
    func submitButtonAction() {
        print("will submit a public request")
        if validateDate() {
            print("corrent")
            publicServiceCreation(choosenCategory, title: titleTextField.text!, description: serviceDescription.text!)
        }else {
            print("incorrect")
        }
    }
    //TextView delegate functions
    /*
     textview delegate functions are used to implement textview placehold
     */
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("im here for textview")
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: BACKEND
    func publicServiceCreation(_ category: String, title: String, description: String) {
        /*
         
         “category”: string (defaulted to “other”)
         “service”: {
         “title” : string
         “description” : big string
         “price” : float
         “status” : string (defaulted to “pending”)
         “due_date” : models.DateTimeField(null=True, blank=True)
         “created” : automatically set to the current server time
         “is_special” : boolean (defaulted to “false)
         }
         
         */
        
        if let myToken = defaults.object(forKey: "userToken") as? String{
            print(myToken)
            let headers = [
                "Authorization": myToken
            ]
            let URL = "\(AppDelegate.URL)/publicservice/"
            
            let category = category
            let service : [String: AnyObject] = [
                "title" : title as AnyObject,
                "description" : description as AnyObject,
                "is_special" : false as AnyObject
            ]
            
            let parameters = [
                "category": category,
                "service": service
            ] as [String : Any]
            
            Alamofire.request(.POST, URL, parameters: parameters as? [String : AnyObject], headers: headers, encoding: .json).responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                if let mydata = String(data: response.data!, encoding: String.Encoding.utf8) {
                    print(mydata)
                }
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                if response.response?.statusCode == 201 {
                    // TODO: go to the detailed page of the offered service.
                }else {
                    print("could not create public service")
                }
            }
            
        }
    }


}
