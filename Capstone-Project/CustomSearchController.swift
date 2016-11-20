//
//  CustomSearchController.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 7/23/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

/*
    this delegate is used for the class that will contain the search controller.
    using a delegate is required because this custom class will implement UISearchBarDelegate.
 */
protocol CustomSearchControllerDelegate: class {
    func didStartSearching()
    func didTapOnSearchButton()
    func didTapOnCancelButton()
    func didChangeSearchText(_ searchText: String)
}
/*each search controller should contains a search bar*/
class CustomSearchController: UISearchController, UISearchBarDelegate {
    
    //MARK: Variables
    var customSearchBar: CustomSearchBar!
    weak var customDelegate: CustomSearchControllerDelegate!
    
    //MARK: Inits
    
    /*
        Custom init explination
            searchBarResultsController: The view controller that displays the search results
            searchBarFrame: the frame of the custom search bar
            searchBarTextColor: the color of the custom search bar text
            searchBarTintColor: tint color of the custom search bar
     */
    init(searchResultsController: UIViewController!,searchBarFrame:CGRect, searchBarTextColor: UIColor, searchBarTintColor: UIColor) {
        super.init(searchResultsController: searchResultsController)
        configureCustomSearchBar(searchBarFrame, textColor: searchBarTextColor, backgroundColor: searchBarTintColor)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    //MARK: Functions
    func configureCustomSearchBar(_ frame: CGRect, textColor: UIColor, backgroundColor: UIColor) {
        //creating custom search bar and configurating it.
        customSearchBar = CustomSearchBar(frame: frame, textColor: textColor)
        customSearchBar.barTintColor = backgroundColor
        customSearchBar.tintColor = textColor
        customSearchBar.showsBookmarkButton = false
        customSearchBar.delegate = self
    }
    //MARK: UISearchBarDelegate functions
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        customDelegate.didStartSearching()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        customSearchBar.resignFirstResponder()
        customDelegate.didTapOnCancelButton()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        customDelegate.didChangeSearchText(searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        customSearchBar.resignFirstResponder()
        customDelegate.didTapOnSearchButton()
    }
}


