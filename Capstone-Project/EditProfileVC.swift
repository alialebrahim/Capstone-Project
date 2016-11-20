//
//  editProvidersProfile.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 7/8/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit
import Alamofire

protocol EditProvidersProfileDelegate {
    func shouldSaveCategories(_ categories: [String])
    func editProfileRequest(_ profileImage: UIImage?)
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
    var myCategories = [String]()
    var delegate: EditProvidersProfileDelegate?
    let defaults = UserDefaults.standard
    //MARK: ViewControllers lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //TODO: add keyboard will hide notification
        setup()
        setupNavigationBar()
        displayViewController()
        //imagePicker.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        navigationItem.title = "Edit Profile"
        
        containerViewHeightConstraint.constant = CGFloat((44*8) + 80)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.isUserInteractionEnabled = true
        adjustContentViewHeight()
        //TODO: Delete (testing only)
        //performSegueWithIdentifier("CategoriesVC", sender: nil)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    //MARK: TextView delegates functions
    //adjusting the scrollview each time the textfield changes
    func textViewDidChange(_ textView: UITextView) {
        //TODO: when textfield frame changes scroll to a specific position.
        //TODO: bug when deleting all text in a textview nothing happens
        adjustContentViewHeight()

    }
    //MARK: IBActions
    @IBAction func chanegProfileImageButtonPressed() {
        let alert = UIAlertController(title: nil, message: "Choose option", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                imagePicker.allowsEditing = false
                imagePicker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
                self.present(imagePicker, animated: true, completion: nil)
            }else {
                print("camera not available")
            }
        }
        let photoAction = UIAlertAction(title: "Choose Photo", style: .default) { (UIAlertAction) in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            self.present(imagePicker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(photoAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)

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
        profileImage.isUserInteractionEnabled = true
        profileImage.contentMode = .scaleAspectFill
        profileImage.addBorderWith(color: UIColor(hex: 0x404040), borderWidth: 2)
       containerView.backgroundColor = UIColor.clear
    }
    func setupNavigationBar() {
        navigationItem.title = "Edit Profile"
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editProvidersProfile.doneEditing))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(editProvidersProfile.cancelEditing))
        navigationItem.rightBarButtonItem = doneItem
        navigationItem.leftBarButtonItem = cancelItem
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    func getViewController() -> UIViewController? {
        let storyboard = UIStoryboard(name: "Provider", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProviderInfoTable") as! ProviderInfoTVC
        vc.delegate = self
        return vc
    }
    func displayViewController() {
        if let vc = getViewController() {
            addChildViewController(vc)
            didMove(toParentViewController: self)
            vc.view.frame = contentView.bounds
            containerView.clipsToBounds = true
            containerView.addSubview(vc.view)
        }
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
        
    }
    func selectImage() {
        let alert = UIAlertController(title: nil, message: "Choose option", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                imagePicker.allowsEditing = false
                imagePicker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
                self.present(imagePicker, animated: true, completion: nil)
            }else {
                print("camera not available")
            }
        }
        let photoAction = UIAlertAction(title: "Choose Photo", style: .default) { (UIAlertAction) in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            self.present(imagePicker, animated: true, completion: nil)
            
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(photoAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    func doneEditing() {
        print("done editing")
        //dimissing keyboard
        view.endEditing(true)
        //editProfile()
        delegate?.editProfileRequest(nil)
    }
    func cancelEditing() {
        print("cancel editing")
        navigationController?.popViewController(animated: true)
    }
    //MARK: ImagePicker Delegate functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage.contentMode = .scaleAspectFit
            profileImage.image = pickedImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func adjustContentViewHeight() {
        var contentRect = CGRect.zero
        for view in self.contentView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        contentViewHeight.constant = contentRect.size.height + 30
        
        
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    func hideKeyboardAction() {
        view.endEditing(true)
    }
    //MARK: CategoriesVC delegate function
    func shouldDismissCategoriesView(_ categories: [String]) {
        print("in edit profile vc")
        myCategories = categories
        print(myCategories)
        delegate?.shouldSaveCategories(categories)
        navigationController?.popViewController(animated: true)
        print("did pop view contoller")
    }
    //MARK: ProviderInfoTVCDelegate function
    func shouldPerformSegueToChooseCategoriesVC() {
        performSegue(withIdentifier: "categoriesVC", sender: nil)
    }
    func dismiss(){
        self.navigationController?.popViewController(animated: true)
    }
    func showAlertWithMessage(_ message: String) {
        self.alertWithMessage(message)
    }
    func shouldAnimateWithMessage(_ message: String) {
        LoadingView.addLoadingViewTo(self.view)
        navigationController?.setNavigationBarHidden(true, animated: false)
        LoadingView.startAnimatingWithMessage(message)
    }
    func shouldStopAnimating(){
        navigationController?.setNavigationBarHidden(false, animated: false)
        LoadingView.stopAnimating()
    }
    //MARK: Segue functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "categoriesVC" {
            if let vc = segue.destination as? CategoriesVC {
                vc.delegate = self
                vc.savedCategory = myCategories
                print("prepareforsegue")
            }
        }
    }
    func alertWithMessage(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
