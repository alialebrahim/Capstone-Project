//
//  editProvidersProfile.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 7/8/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

//TODO: add description text view placeholder
class editProvidersProfile: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate, CategoriesVCDelegate {
    
    //MARK: IBOutlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var workingFieldsTextField: UITextField!
    @IBOutlet weak var descriptionTextView: customTextView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    //MARK: Variables
    var imagePicker = UIImagePickerController()
    var categories = [String]()
    
    //MARK: ViewControllers lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //TODO: add keyboard will hide notification
        setup()
        setupNavigationBar()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        navigationItem.title = "Edit Profile"
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.userInteractionEnabled = true
        adjustContentViewHeight()
        
        //TODO: Delete (testing only)
        performSegueWithIdentifier("CategoriesVC", sender: nil)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        descriptionTextView.addBottomBorderWith(Color: UIColor.grayColor(), width: 1)
    }
    //MARK: TextView delegates functions
    //adjusting the scrollview each time the textfield changes
    func textViewDidChange(textView: UITextView) {
        //TODO: when textfield frame changes scroll to a specific position.
        //TODO: bug when deleting all text in a textview nothing happens
        adjustContentViewHeight()

    }
    //MARK: functions
    func setup() {
        self.automaticallyAdjustsScrollViewInsets = false
        
        //setup tap gesture for image selection
        imagePicker.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editProvidersProfile.selectImage))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.userInteractionEnabled = true
        profileImage.contentMode = .ScaleAspectFill
       
        //setup outlets
        emailTextField.keyboardType = .EmailAddress
        
        mobileNumberTextField.keyboardType = .PhonePad
        
        descriptionTextView.delegate = self
        descriptionTextView.text = "A well-organized paragraph supports or develops a single controlling idea, which is expressed in a sentence called the topic sentence. A topic sentence has several important functions: it substantiates or supports an essay’s thesis statement; it unifies the content of a paragraph and directs the order of the sentences; and it advises the reader of the subject to be discussed and how the paragraph will discuss it. Readers generally look to the first few sentences in a paragraph to determine the subject and perspective of the paragraph. That’s why it’s often best to put the topic sentence at the very beginning of the paragraph. In some cases, however, it’s more effective to place another sentence before the topic sentence—for example, a sentence linking the current paragraph to the previous one, or one providing background information.A well-organized paragraph supports or develops a single controlling idea, which is expressed in a sentence called the topic sentence. A topic sentence has several important functions: it substantiates or supports an essay’s thesis statement; it unifies the content of a paragraph and directs the order of the sentences; and it advises the reader of the subject to be discussed and how the paragraph will discuss it. Readers generally look to the first few sentences in a paragraph to determine the subject and perspective of the paragraph. That’s why it’s often best to put the topic sentence at the very beginning of the paragraph. In some cases, however, it’s more effective to place another sentence before the topic sentence—for example, a sentence linking the current paragraph to the previous one, or one providing background information."
    }
    func setupNavigationBar() {
        navigationItem.title = "Edit Profile"
        let doneItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(editProvidersProfile.doneEditing))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(editProvidersProfile.cancelEditing))
        navigationItem.rightBarButtonItem = doneItem
        navigationItem.leftBarButtonItem = cancelItem
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
        
    }
    func selectImage() {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    func doneEditing() {
        print("done editing")
        //dimissing keyboard
        view.endEditing(true)
        //update the changes in the server
        self.navigationController?.popViewControllerAnimated(true)
    }
    func cancelEditing() {
        print("cancel editing")
        navigationController?.popViewControllerAnimated(true)
    }
    //MARK: ImagePicker Delegate functions
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage.contentMode = .ScaleAspectFit
            profileImage.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func adjustContentViewHeight() {
        var contentRect = CGRectZero
        for view in self.contentView.subviews {
            contentRect = CGRectUnion(contentRect, view.frame)
        }
        
        contentViewHeight.constant = contentRect.size.height + 20
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    //MARK: CategoriesVC delegate function
    func shouldDismissCategoriesView(categories: [String]) {
        print(categories)
        presentedViewController?.dismissViewControllerAnimated(true, completion: { 
            print("dismissed")
        })
    }
    //MARK: Segue functions
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CategoriesVC" {
            if let vc = segue.destinationViewController as? CategoriesVC {
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
        }
    }
}
