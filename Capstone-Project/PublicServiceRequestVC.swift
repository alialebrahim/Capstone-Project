//
//  PublicServiceRequestVC.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 9/12/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit
import Alamofire
import DateTimePicker

class PublicServiceRequestVC: UIViewController, UITextViewDelegate, ChooseCategoriesVCDelegate {

    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var serviceDescription: UITextView!
    @IBOutlet weak var dueTo: UIButton!
    var isSpecial: Bool?
    var year: Int!
    var month: Int!
    var day: Int!
    var pk: Int!
    var dueString: String?
    var choosenCategory: String = Categories.Others.rawValue
    let defaults = UserDefaults.standard
//    var submitRequestButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("submit", for: UIControlState())
//        button.layer.borderWidth = 1
//        button.layer.borderColor = UIColor.black.cgColor
//        button.setTitleColor(UIColor.black, for: UIControlState())
//        return button
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("YAY!! im here")
        print(isSpecial)
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
        
        
        //textview placeholder setup
        serviceDescription.delegate = self
        serviceDescription.text = "Description"
        serviceDescription.textColor = UIColor(hex: 0xC7C7CD)
        serviceDescription.selectedTextRange = serviceDescription.textRange(from: serviceDescription.beginningOfDocument, to: serviceDescription.beginningOfDocument)
        //////////////////////////////
        //setup buttons
        dueTo.backgroundColor = UIColor(hex: 0x404040)
        dueTo.setTitleColor(UIColor.white, for: .normal)
        dueTo.layer.cornerRadius = 10
        categoryButton.backgroundColor = UIColor(hex: 0x404040)
        categoryButton.setTitleColor(UIColor.white, for: .normal)
        categoryButton.layer.cornerRadius = 10
        submitButton.backgroundColor = UIColor(hex: 0xa85783)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.layer.cornerRadius = 10
        //setup fields
        titleTextField.addBottomBorderWithColor(UIColor(hex: 0xa85783), width: 1)
        priceTextField.addBottomBorderWithColor(UIColor(hex: 0xa85783), width: 1)
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
    @IBAction func dueToAction(_ sender: Any) {
        
        self.view.endEditing(true)
        let picker = DateTimePicker.show()
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        
        picker.completionHandler = { date in
            let calendar = Calendar.current
            let components = (calendar as NSCalendar).components([.day , .month , .year], from: date)
            
            self.year =  components.year
            self.month = components.month
            self.day = components.day
            self.dueTo.setTitle("Due to: \(self.year!)/\(self.month!)/\(self.day!)", for: .normal)
            self.dueString = "\(self.year!)/\(self.month!)/\(self.day!)"
            print(self.dueString!)
            print(self.year)
            print(self.month)
            print(self.day)
        }
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
    func alertWithMessage(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    @IBAction func submitButtonPressed(_ sender: Any) {
        if dueString == nil {
            alertWithMessage("Please choose a due date")
        }else {
                //TODO: validate
            print("will submit a public request")
            if let _ = isSpecial {
                specialServiceRequest(titleTextField.text!, description: serviceDescription.text!, price: Float(priceTextField.text!)!)
            }else {
                validateDate()
                if /*validateDate()*/ true {
                    print("corrent")
                    publicServiceCreation(choosenCategory, title: titleTextField.text!, description: serviceDescription.text!)
                }else {
                    print("incorrect")
                }
            }
        }
        
        

    }
    func submitButtonAction() {
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
    func specialServiceRequest(_ title: String, description: String, price: Float) {
        
        if let myToken = defaults.object(forKey: "userToken") as? String{
            print(myToken)
            let headers = [
                "Authorization": myToken
            ]
            let URL = "\(AppDelegate.URL)/publicservice/"
            
            let service : [String: AnyObject] = [
                "title" : title as AnyObject,
                "description" : description as AnyObject,
                "price": price as AnyObject,
                "providerpk": pk! as AnyObject,
                "is_special": true as AnyObject,
                "due_date": dueString as AnyObject
            ]
            
            let parameters = [
                "service": service
                ] as [String : Any]
            Alamofire.request(URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { (response) in
                print(response.request!)  // original URL request
                print(response.response!) // URL response
                print(response.data!)     // server data
                print(response.result)   // result of response serialization
                if let mydata = String(data: response.data!, encoding: String.Encoding.utf8) {
                    print(mydata)
                }
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                if response.response?.statusCode == 201 {
                    let alertController = UIAlertController(title: "Thank You", message: "Thank you for submiting this service", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }else {
                    print("could not create public service")
                    let alertController = UIAlertController(title: "Error", message: "Could not complete your request\nPlease try again later", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
    }
    func publicServiceCreation(_ category: String, title: String, description: String) {
        
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
                "due_date": dueString as AnyObject
            ]
            
            let parameters = [
                "category": category,
                "service": service
            ] as [String : Any]
            Alamofire.request(URL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { (response) in
                print(response.request!)  // original URL request
                print(response.response!) // URL response
                print(response.data!)     // server data
                print(response.result)   // result of response serialization
                if let mydata = String(data: response.data!, encoding: String.Encoding.utf8) {
                    print(mydata)
                }
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                if response.response?.statusCode == 201 {
                    // TODO: go to the detailed page of the offered service.
                    let alertController = UIAlertController(title: "Thank You", message: "Thank you for submiting this service", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }else {
                    print("could not create public service")
                    let alertController = UIAlertController(title: "Error", message: "Could not complete your request\nPlease try again later", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }

            })
            
        }
    }


}
