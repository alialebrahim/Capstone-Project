//
//  editProvidersProfile.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 7/8/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

protocol EditProvidersProfileDelegate {
    func shouldSaveCategories(categories: [String])
}

//TODO: add description text view placeholder
class editProvidersProfile: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate, CategoriesVCDelegate, ProviderInfoTVCDelegate {
    
    //MARK: IBOutlets
    @IBOutlet weak var profileImage: CircularImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    //MARK: Variables
    //var imagePicker = UIImagePickerController()
    var myCategories = [String]()
    var delegate: EditProvidersProfileDelegate?
    //MARK: ViewControllers lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //TODO: add keyboard will hide notification
        setup()
        setupNavigationBar()
        displayViewController()
        //imagePicker.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        navigationItem.title = "Edit Profile"
        
        containerViewHeightConstraint.constant = (44*8) + 80
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.userInteractionEnabled = true
        adjustContentViewHeight()
        //TODO: Delete (testing only)
        //performSegueWithIdentifier("CategoriesVC", sender: nil)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    //MARK: TextView delegates functions
    //adjusting the scrollview each time the textfield changes
    func textViewDidChange(textView: UITextView) {
        //TODO: when textfield frame changes scroll to a specific position.
        //TODO: bug when deleting all text in a textview nothing happens
        adjustContentViewHeight()

    }
    //MARK: IBActions
    @IBAction func chanegProfileImageButtonPressed() {
        let alert = UIAlertController(title: nil, message: "Choose option", preferredStyle: .ActionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .Default) { (UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                imagePicker.allowsEditing = false
                imagePicker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }else {
                print("camera not available")
            }
        }
        let photoAction = UIAlertAction(title: "Choose Photo", style: .Default) { (UIAlertAction) in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(photoAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)

    }
    //MARK: functions
    func setup() {
        self.automaticallyAdjustsScrollViewInsets = false
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardAction))
        view.addGestureRecognizer(hideKeyboardGesture)
        //setup tap gesture for image selection
        //imagePicker.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.userInteractionEnabled = true
        profileImage.contentMode = .ScaleAspectFill
       containerView.backgroundColor = UIColor.clearColor()
    }
    func setupNavigationBar() {
        navigationItem.title = "Edit Profile"
        let doneItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(editProvidersProfile.doneEditing))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(editProvidersProfile.cancelEditing))
        navigationItem.rightBarButtonItem = doneItem
        navigationItem.leftBarButtonItem = cancelItem
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    func getViewController() -> UIViewController? {
        let storyboard = UIStoryboard(name: "Provider", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("ProviderInfoTable") as! ProviderInfoTVC
        vc.delegate = self
        return vc
    }
    func displayViewController() {
        if let vc = getViewController() {
            addChildViewController(vc)
            didMoveToParentViewController(self)
            vc.view.frame = contentView.bounds
            containerView.clipsToBounds = true
            containerView.addSubview(vc.view)
        }
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
//        presentViewController(imagePicker, animated: true, completion: nil)
        let alert = UIAlertController(title: nil, message: "Choose option", preferredStyle: .ActionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .Default) { (UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                imagePicker.allowsEditing = false
                imagePicker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }else {
                print("camera not available")
            }
        }
        let photoAction = UIAlertAction(title: "Choose Photo", style: .Default) { (UIAlertAction) in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(photoAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
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
        contentViewHeight.constant = contentRect.size.height + 30
        
        
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    func hideKeyboardAction() {
        view.endEditing(true)
    }
    //MARK: CategoriesVC delegate function
    func shouldDismissCategoriesView(categories: [String]) {
        print("in edit profile vc")
        myCategories = categories
        print(myCategories)
        delegate?.shouldSaveCategories(categories)
        navigationController?.popViewControllerAnimated(true)
        print("did pop view contoller")
    }
    //MARK: ProviderInfoTVCDelegate function
    func shouldPerformSegueToChooseCategoriesVC() {
        performSegueWithIdentifier("categoriesVC", sender: nil)
    }
    //MARK: Segue functions
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "categoriesVC" {
            if let vc = segue.destinationViewController as? CategoriesVC {
                vc.delegate = self
                print("prepareforsegue")
            }
        }
    }
}
