//
//  SyzygySearchDelegate.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/22/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#if BUILDING_FOR_UIKIT

import Foundation

open class SyzygySearchDelegate: NSObject, UISearchBarDelegate {
    
    open func configureSearchBar(_ searchBar: UISearchBar) { }
    
    open func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    open func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) { }
    
    open func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    open func searchBarTextDidEndEditing(_ searchBar: UISearchBar) { }
    
    open func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)  { }
    
    open func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    open func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { }
    
    open func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) { }
    
    open func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
    }
    
    open func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) { }
    
    open func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) { }
    
}

#endif
