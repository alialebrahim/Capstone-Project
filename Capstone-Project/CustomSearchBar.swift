//
//  CustomSearchBar.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 7/23/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar {
    
    //MARK: Variables
    var prefferedTextColor: UIColor!
    
    //MARK: Inits
    init(frame: CGRect, textColor: UIColor) {
        super.init(frame: frame)
        self.frame = frame
        prefferedTextColor = textColor
        configureSearchBar()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: Functions
    override func draw(_ rect: CGRect) {
        configureSearchTextField()
        super.draw(rect)
    }
    func configureSearchBar() {
        searchBarStyle = .prominent
        isTranslucent = false //For both searchbar and search field to be opaque
        addBottomBorderWithColor(prefferedTextColor, width: 1.5)
    }
    func configureSearchTextField() {
        if let index = indexOfTextFieldInSubViews() {
            let searchField = subviews[0].subviews[index] as! UITextField
            searchField.frame = CGRect(x: 5.0, y: 5.0, width: frame.size.width - 10.0, height: frame.size.height - 10)
            searchField.textColor = prefferedTextColor
            searchField.backgroundColor = barTintColor
        }
    }
    /*
        search bar does not only contains a textfield
        it may contain multiple views.
        for that reason this function is responsible to get 
        the textfield index from the queue of subviews in the search bar
     */
    func indexOfTextFieldInSubViews() -> Int! {
        var index: Int!
        let searchBarView = subviews[0]
        for i in 0 ..< searchBarView.subviews.count {
            if searchBarView.subviews[i].isKind(of: UITextField.self) {
                index = i
                break
            }
        }
        return index
    }
}
