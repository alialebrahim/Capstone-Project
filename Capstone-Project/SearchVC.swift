//
//  SearchVC.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 8/15/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchVC: UIViewController, ChooseCategoriesVCDelegate, ChooseRatingVCDelegate {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var chooseRatingButton: UIButton!
    @IBOutlet weak var chooseCategoryButton: UIButton!
    var myCategory = ""
    @IBAction func chooseCategoryButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "ChooseCategoriesVC", sender: nil)
    }
    
    @IBAction func chooseRatingButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "ChooseRatingVC", sender: nil)
    }
    
    @IBAction func searchButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "ShowProviders", sender: nil)
    }
    
//    //Variables
//    let containerView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = UIColor(hex: 0xa85783)
//        view.layer.borderWidth = 1
//        view.layer.borderColor = UIColor(hex: 0x404040).CGColor
//        view.layer.cornerRadius = 20
//        return view
//    }()
//    let catergoryLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "Choose Category:"
//        label.textAlignment = .Center
//        label.textColor = UIColor.whiteColor()
//        return label
//    }()
//    let chooseCategoryButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("Choose Category    >", forState: .Normal)
//        button.showsTouchWhenHighlighted = true
//        button.setTitleColor(UIColor(hex:0x404040), forState: .Normal)
//        button.layer.cornerRadius = button.frame.height/2
//        button.backgroundColor = UIColor.whiteColor()
//        return button
//    }()
//    let chooseRatingLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "Choose Rating:"
//        label.textAlignment = .Center
//        label.textColor = UIColor.whiteColor()
//        return label
//    }()
//    let chooseRatingButton: UIButton = {
//       let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("Choose rating  >", forState: .Normal)
//        button.showsTouchWhenHighlighted = true
//        button.setTitleColor(UIColor(hex:0x404040), forState: .Normal)
//        button.layer.cornerRadius = button.frame.height/2
//        button.backgroundColor = UIColor.whiteColor()
//        return button
//    }()
//    let searchButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("Search", forState: .Normal)
//        //button.showsTouchWhenHighlighted = true
//        button.backgroundColor = UIColor(hex: 0xa85783)
//        button.setTitleColor(UIColor(hex:0x404040), forState: .Highlighted)
//        return button
//    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationBar()
    }
    //MARK: Functions
    func setup(){
        containerView.layer.cornerRadius = 20
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(hex: 0x404040).cgColor
        searchButton.layer.cornerRadius = 20
        searchButton.layer.borderWidth = 1
        searchButton.layer.borderColor = UIColor(hex: 0x404040).cgColor
    }
    func setupNavigationBar() {
        navigationItem.title = "Search"
    }
//    func setupContainerView() {
//        view.addSubview(containerView)
//        let topConstant = (navigationController?.navigationBar.frame.height)! + 100
//
//        containerView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: topConstant).active = true
//        
//        containerView.heightAnchor.constraintEqualToConstant(view.frame.height/3).active = true
//        containerView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
//        
//        containerView.widthAnchor.constraintEqualToConstant(view.frame.width - view.frame.width/4).active = true
//    }
//    func setupCategoryLabel() {
//        containerView.addSubview(catergoryLabel)
//        catergoryLabel.topAnchor.constraintEqualToAnchor(containerView.topAnchor, constant: 20).active = true
//        catergoryLabel.leadingAnchor.constraintEqualToAnchor(containerView.leadingAnchor, constant: 8).active = true
//        catergoryLabel.heightAnchor.constraintEqualToConstant(20)
//        catergoryLabel.trailingAnchor.constraintEqualToAnchor(containerView.trailingAnchor, constant: -8).active = true
//    }
//    func setupCategoryButton() {
//        chooseCategoryButton.addTarget(self, action: #selector(chooseCategoryButtonPressed), forControlEvents: .TouchUpInside)
//        containerView.addSubview(chooseCategoryButton)
//        chooseCategoryButton.topAnchor.constraintEqualToAnchor(catergoryLabel.topAnchor, constant: 50).active = true
//        chooseCategoryButton.leadingAnchor.constraintEqualToAnchor(containerView.leadingAnchor, constant: 8).active = true
//        chooseCategoryButton.trailingAnchor.constraintEqualToAnchor(containerView.trailingAnchor, constant: -8).active = true
//    }
//    func setupChooseRatingLabel() {
//        containerView.addSubview(chooseRatingLabel)
//        chooseRatingLabel.topAnchor.constraintEqualToAnchor(chooseCategoryButton.topAnchor, constant: 50).active = true
//        chooseRatingLabel.leadingAnchor.constraintEqualToAnchor(containerView.leadingAnchor, constant: 8).active = true
//        chooseRatingLabel.trailingAnchor.constraintEqualToAnchor(containerView.trailingAnchor, constant: -8).active = true
//    }
//    func setupeRatingButton(){
//        chooseRatingButton.addTarget(self, action: #selector(setupChooseRatingButtonPressed), forControlEvents: .TouchUpInside)
//        containerView.addSubview(chooseRatingButton)
//        chooseRatingButton.topAnchor.constraintEqualToAnchor(chooseRatingLabel.topAnchor, constant: 50).active = true
//        chooseRatingButton.leadingAnchor.constraintEqualToAnchor(containerView.leadingAnchor, constant: 8).active = true
//        chooseRatingButton.trailingAnchor.constraintEqualToAnchor(containerView.trailingAnchor, constant: -8).active = true
//        
//    }
//    func setupSearchButton() {
//        searchButton.addTarget(self, action: #selector(searchButtonPressed), forControlEvents: .TouchUpInside)
//        view.addSubview(searchButton)
//        searchButton.topAnchor.constraintEqualToAnchor(self.view.bottomAnchor, constant: -50).active = true
//        searchButton.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
//        searchButton.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
//    }
//    func chooseCategoryButtonPressed() {
//        performSegueWithIdentifier("ChooseCategoriesVC", sender: nil)
//    }
//    func setupChooseRatingButtonPressed() {
//        performSegueWithIdentifier("ChooseRatingVC", sender: nil)
//    }
//    func searchButtonPressed() {
//        performSegueWithIdentifier("ShowProviders", sender: nil)
//    }
    //MARK: ChooseCategoriesDelegate function
    func didSelectCategory(_ category: String) {
        myCategory = category
        chooseCategoryButton.setTitle("\(category)  >", for: UIControlState())
    }
    
    //MARK: ChooseRatingDelegate function
    func didSelectRating(_ rating: Int) {
        chooseRatingButton.setTitle("\(rating) & Up  >", for: UIControlState())
    }
    //MARK: Segue functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChooseCategoriesVC" {
            if let vc = segue.destination as? ChooseCategoriesVC {
                vc.delegate = self
            }
        }else if segue.identifier == "ChooseRatingVC" {
            if let vc = segue.destination as? ChooseRatingVC {
                vc.delegate = self
            }
        }else if segue.identifier == "ShowProviders" {
            if let vc = segue.destination as? ProvidersSearchVC {
                vc.category = myCategory
            }
        }
    }
}
