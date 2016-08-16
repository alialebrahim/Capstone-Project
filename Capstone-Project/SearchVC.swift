//
//  SearchVC.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 8/15/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, ChooseCategoriesVCDelegate, ChooseRatingVCDelegate {
    
    //Variables
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGrayColor()
        return view
    }()
    let catergoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Choose Category:"
        label.backgroundColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.textColor = UIColor.blackColor()
        return label
    }()
    let chooseCategoryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Choose Category    >", forState: .Normal)
        button.showsTouchWhenHighlighted = true
        return button
    }()
    let chooseRatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Choose Rating:"
        label.backgroundColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.textColor = UIColor.blackColor()
        return label
    }()
    let chooseRatingButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Choose rating  >", forState: .Normal)
        button.showsTouchWhenHighlighted = true
        return button
    }()
    let searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Search", forState: .Normal)
        //button.showsTouchWhenHighlighted = true
        button.setTitleColor(UIColor.redColor(), forState: .Highlighted)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationBar()
    }
    //MARK: Functions
    func setup(){
        setupContainerView()
        setupCategoryLabel()
        setupCategoryButton()
        setupChooseRatingLabel()
        setupeRatingButton()
        setupSearchButton()
    }
    func setupNavigationBar() {
        navigationItem.title = "Search"
    }
    func setupContainerView() {
        view.addSubview(containerView)
        let topConstant = (navigationController?.navigationBar.frame.height)! + 50

        containerView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: topConstant).active = true
        
        containerView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -topConstant).active = true
        
        containerView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        
        containerView.widthAnchor.constraintEqualToConstant(view.frame.width - view.frame.width/4).active = true
    }
    func setupCategoryLabel() {
        containerView.addSubview(catergoryLabel)
        catergoryLabel.topAnchor.constraintEqualToAnchor(containerView.topAnchor, constant: 20).active = true
        catergoryLabel.leadingAnchor.constraintEqualToAnchor(containerView.leadingAnchor, constant: 8).active = true
        catergoryLabel.heightAnchor.constraintEqualToConstant(20)
        catergoryLabel.trailingAnchor.constraintEqualToAnchor(containerView.trailingAnchor, constant: -8).active = true
    }
    func setupCategoryButton() {
        chooseCategoryButton.addTarget(self, action: #selector(chooseCategoryButtonPressed), forControlEvents: .TouchUpInside)
        containerView.addSubview(chooseCategoryButton)
        chooseCategoryButton.topAnchor.constraintEqualToAnchor(catergoryLabel.topAnchor, constant: 50).active = true
        chooseCategoryButton.leadingAnchor.constraintEqualToAnchor(containerView.leadingAnchor, constant: 8).active = true
        chooseCategoryButton.trailingAnchor.constraintEqualToAnchor(containerView.trailingAnchor, constant: -8).active = true
    }
    func setupChooseRatingLabel() {
        containerView.addSubview(chooseRatingLabel)
        chooseRatingLabel.topAnchor.constraintEqualToAnchor(chooseCategoryButton.topAnchor, constant: 50).active = true
        chooseRatingLabel.leadingAnchor.constraintEqualToAnchor(containerView.leadingAnchor, constant: 8).active = true
        chooseRatingLabel.trailingAnchor.constraintEqualToAnchor(containerView.trailingAnchor, constant: -8).active = true
    }
    func setupeRatingButton(){
        chooseRatingButton.addTarget(self, action: #selector(setupChooseRatingButtonPressed), forControlEvents: .TouchUpInside)
        containerView.addSubview(chooseRatingButton)
        chooseRatingButton.topAnchor.constraintEqualToAnchor(chooseRatingLabel.topAnchor, constant: 50).active = true
        chooseRatingButton.leadingAnchor.constraintEqualToAnchor(containerView.leadingAnchor, constant: 8).active = true
        chooseRatingButton.trailingAnchor.constraintEqualToAnchor(containerView.trailingAnchor, constant: -8).active = true
        
    }
    func setupSearchButton() {
        searchButton.addTarget(self, action: #selector(searchButtonPressed), forControlEvents: .TouchUpInside)
        containerView.addSubview(searchButton)
        searchButton.leadingAnchor.constraintEqualToAnchor(containerView.leadingAnchor, constant: 8).active = true
        searchButton.trailingAnchor.constraintEqualToAnchor(containerView.trailingAnchor, constant: -8).active = true
        searchButton.bottomAnchor.constraintEqualToAnchor(containerView.bottomAnchor, constant: -20).active = true
    }
    func chooseCategoryButtonPressed() {
        performSegueWithIdentifier("ChooseCategoriesVC", sender: nil)
    }
    func setupChooseRatingButtonPressed() {
        performSegueWithIdentifier("ChooseRatingVC", sender: nil)
    }
    func searchButtonPressed() {
        performSegueWithIdentifier("ShowProviders", sender: nil)
    }
    //MARK: ChooseCategoriesDelegate function
    func didSelectCategory(category: String) {
        chooseCategoryButton.setTitle("\(category)  >", forState: .Normal)
    }
    
    //MARK: ChooseRatingDelegate function
    func didSelectRating(rating: Int) {
        chooseRatingButton.setTitle("\(rating) & Up  >", forState: .Normal)
    }
    //MARK: Segue functions
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ChooseCategoriesVC" {
            if let vc = segue.destinationViewController as? ChooseCategoriesVC {
                vc.delegate = self
            }
        }else if segue.identifier == "ChooseRatingVC" {
            if let vc = segue.destinationViewController as? ChooseRatingVC {
                vc.delegate = self
            }
        }
    }
    
}
