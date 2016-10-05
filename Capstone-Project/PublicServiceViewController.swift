//
//  PublicServiceViewController.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 9/20/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

class PublicServiceViewController: UIViewController {
    
    var userType = "provider"
    var providerBid: Int?
    var myTextField: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dueLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        adjustContentViewHeight()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        automaticallyAdjustsScrollViewInsets = false
        descriptionTextView.text = "sdljbsljdbfljbsdjfdfj lsdjfblwjbeflwbef weljf wlje flwje flwe flwh elfhw elf wleh lwh elhw lfe wlfe lwhe sdljbsljdbfljbsdjfdfj lsdjfblwjbeflwbef weljf wlje flwje flwe flwh elfhw elf wleh lwh elhw lfe wlfe lwhe sdljbsljdbfljbsdjfdfj lsdjfblwjbeflwbef weljf wlje flwje flwe flwh elfhw elf wleh lwh elhw lfe wlfe lwhe sdljbsljdbfljbsdjfdfj lsdjfblwjbeflwbef weljf wlje flwje flwe flwh elfhw elf wleh lwh elhw lfe wlfe lwhe sdljbsljdbfljbsdjfdfj lsdjfblwjbeflwbef weljf wlje flwje flwe flwh elfhw elf wleh lwh elhw lfe wlfe lwhe sdljbsljdbfljbsdjfdfj lsdjfblwjbeflwbef weljf wlje flwje flwe flwh elfhw elf wleh lwh elhw lfe wlfe lwhe sdljbsljdbfljbsdjfdfj lsdjfblwjbeflwbef weljf wlje flwje flwe flwh elfhw elf wleh lwh elhw lfe wlfe lwhe sdljbsljdbfljbsdjfdfj lsdjfblwjbeflwbef weljf wlje flwje flwe flwh elfhw elf wleh lwh elhw lfe wlfe lwhe sdljbsljdbfljbsdjfdfj lsdjfblwjbeflwbef weljf wlje flwje flwe flwh elfhw elf wleh lwh elhw lfe wlfe lwhe sdljbsljdbfljbsdjfdfj lsdjfblwjbeflwbef weljf wlje flwje flwe flwh elfhw elf wleh lwh elhw lfe wlfe lwhe sdljbsljdbfljbsdjfdfj lsdjfblwjbeflwbef weljf wlje flwje flwe flwh elfhw elf wleh lwh elhw lfe wlfe lwhe sdljbsljdbfljbsdjfdfj lsdjfblwjbeflwbef weljf wlje flwje flwe flwh elfhw elf wleh lwh elhw lfe wlfe lwhe sdljbsljdbfljbsdjfdfj lsdjfblwjbeflwbef weljf wlje flwje flwe flwh elfhw elf wleh lwh elhw lfe wlfe lwhe sdljbsljdbfljbsdjfdfj lsdjfblwjbeflwbef weljf wlje flwje flwe flwh elfhw elf wleh lwh elhw lfe wlfe lwhe sdljbsljdbfljbsdjfdfj lsdjfblwjbeflwbef weljf wlje flwje flwe flwh elfhw elf wleh lwh elhw lfe wlfe lwhe sdljbsljdbfljbsdjfdfj lsdjfblwjbeflwbef weljf wlje flwje flwe flwh elfhw elf wleh lwh elhw lfe wlfe lwhe sdljbsljdbfljbsdjfdfj lsdjfblwjbeflwbef weljf wlje flwje flwe flwh elfhw elf wleh lwh elhw lfe wlfe lwhe sdljbsljdbfljbsdjfdfj lsdjfblwjbeflwbef weljf wlje flwje flwe flwh elfhw elf wleh lwh elhw lfe wlfe lwhe sdljbsljdbfljbsdjfdfj lsdjfblwjbeflwbef weljf wlje flwje flwe flwh elfhw elf wleh lwh elhw lfe wlfe lwhe "
        setupNavigationBar()
        if userType == "provider" {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(bidOnService), forControlEvents: .TouchUpInside)
            button.setTitle("bid on this service", forState: .Normal)
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.layer.borderColor = UIColor.blackColor().CGColor
            button.layer.borderWidth = 1
            containerView.addSubview(button)
            button.topAnchor.constraintEqualToAnchor(priceLabel.bottomAnchor, constant: 8).active = true
            button.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
            button.widthAnchor.constraintEqualToConstant(view.frame.size.width/2).active = true
        }else if userType == "seeker" {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(showBids), forControlEvents: .TouchUpInside)
            button.setTitle("Show bids", forState: .Normal)
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.layer.borderColor = UIColor.blackColor().CGColor
            button.layer.borderWidth = 1
            containerView.addSubview(button)
            button.topAnchor.constraintEqualToAnchor(priceLabel.bottomAnchor, constant: 8).active = true
            button.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
            button.widthAnchor.constraintEqualToConstant(view.frame.size.width/2).active = true
        }
    }
    func showBids(){
        print("showing bids")
    }
    func bidOnService() {
        
        let alertController = UIAlertController(title: "Bid", message: "You are bidding on - Service title", preferredStyle: .Alert)
        let bidAction = UIAlertAction(title: "Bid", style: .Destructive) { (UIAlertAction) in
            print("bidding on service")
            print(self.myTextField.text)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(bidAction)
        alertController.addAction(cancelAction)
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "You bid"
            textField.keyboardType = .NumbersAndPunctuation
            self.myTextField = textField
        }
        presentViewController(alertController, animated: true, completion: nil)
    }
    func setupNavigationBar() {
        navigationItem.title = "Service title"
    }
    func adjustContentViewHeight() {
        var contentRect = CGRectZero
        for view in containerView.subviews {
            contentRect = CGRectUnion(contentRect, view.frame)
        }
        containerViewHeightConstraint.constant = contentRect.size.height+20
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
