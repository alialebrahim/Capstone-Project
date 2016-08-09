//
//  CustomSegmentedControl.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 6/18/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable class CustomSegmentedControl : UIControl {
    
    // MARK: Variables
    
    //UILabel array that will hold the labels that will go into the segmented control
    private var segmentedControlLabels = [UILabel]()
    //UIView that will go over the selected item (Label)
    var selectedItemView = UIView()
    //title of segmented control items.
    var segmentedControlItems = ["Info","My Services"] {
        didSet {
            setUpLabels()
        }
    }
    var selectedIndex : Int = 0 {
        didSet {
            displayNewSelectedIndex()
        }
    }
    
    //IBInspectable variables are used to control different segmented control properties in the storyboard
    @IBInspectable var selectedLabelColor: UIColor = UIColor.clearColor() {
        didSet {
            setSelectedColor()
        }
    }
    @IBInspectable var unselectedLabelColor: UIColor = UIColor.clearColor() {
        didSet {
            setSelectedColor()
        }
    }
    @IBInspectable var selectedItemViewColor: UIColor = UIColor.clearColor() {
        didSet {
            setSelectedColor()
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.clearColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    @IBInspectable var lineViewColor: UIColor = UIColor.clearColor()
    // MARK: Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //MARK: View lifecycle.
    /*
     setting up and adding different elements of segment control
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupSelectedItemView()
        
        let labelHeight = self.bounds.height
        let labelWidth = self.bounds.width / CGFloat(segmentedControlLabels.count)
        //placing segmented control labels.
        for index in 0..<segmentedControlLabels.count {
            let label = segmentedControlLabels[index]
            let xPosition = CGFloat(index) * labelWidth
            label.frame = CGRectMake(xPosition, 0, labelWidth, labelHeight)
        }
    }
    
    // MARK: Functions
    
    //this function is responsable for setting up segmented control view
    func setupView() {
        backgroundColor = UIColor.clearColor()
        setUpLabels()
        insertSubview(selectedItemView, atIndex: 0)
    }
    func setupSelectedItemView() {
        var containerViewFrame = self.bounds
        //the width of the line view depends on the total width / number of items in the controller.
        let selectedItemViewWidth = CGRectGetWidth(containerViewFrame) / CGFloat(segmentedControlItems.count)
        containerViewFrame.size.width = selectedItemViewWidth
        selectedItemView.frame = containerViewFrame
        selectedItemView.backgroundColor = selectedItemViewColor
        
        //TODO: adding line layer to the selected item view
        selectedItemView.addBottomBorderWithColor(lineViewColor, width: 2)

    }
    func setUpLabels() {
        //in case there was any label in the subview we remove it.
        for label in segmentedControlLabels {
            label.removeFromSuperview()
        }
        //we remove all elements from the array but keeping the memory allocated to improve performance.
        segmentedControlLabels.removeAll(keepCapacity: true)
        for index in 1...segmentedControlItems.count {
            //creating labels according to the number of items in segmentedControlItems.
            let label = UILabel(frame: CGRectZero)
            //setting up segmentedcontrol label
            label.text = segmentedControlItems[index-1]
            label.textAlignment = .Center
            /*
             initially, selected index will be 1. the line of code below sets the color if the selected label 
             when the segmentedcontrol first load.
             if index == 1 set label color to selectedLabelColor, otherwise set it to unselectedLabelColor
             */
            label.textColor = (index == 1 ? selectedLabelColor : unselectedLabelColor)
            self.addSubview(label)
            segmentedControlLabels.append(label)
        }
    }
    //whenever the selected index changes, this function will be called
    func displayNewSelectedIndex() {
        for label in segmentedControlLabels {
            label.textColor = unselectedLabelColor
        }
        let label = segmentedControlLabels[selectedIndex]
        label.textColor = selectedLabelColor
        selectedItemView.frame = label.frame
    }
    

    /*
        this function is reponsable for detecting touches inside this view
        if the touch occured over one of segment control elements 
        the index value of that tab will be stored.
     */
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        //returns the location of touch in the view. This location is in CGPoint.
        let location = touch.locationInView(self)
        var calculatedIndex : Int?
        
        for (index, item) in segmentedControlLabels.enumerate() {
            /*if the touch occures inside one of the labels store the label index*/
            if item.frame.contains(location) {
                calculatedIndex = index
            }

            if calculatedIndex != nil {
                selectedIndex = calculatedIndex!
                sendActionsForControlEvents(.ValueChanged)
            }
        }
        return false
    }
    func setSelectedColor() {
        for label in segmentedControlLabels {
            label.textColor = unselectedLabelColor
        }
        segmentedControlLabels[selectedIndex].textColor = selectedLabelColor
        selectedItemView.backgroundColor = selectedItemViewColor
    }

}