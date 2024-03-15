//
//  CoctailSearchController.swift
//  CoctailMenu
//
//  Created by Polina on 11.03.2024.
//


import UIKit

class CoctailSearchController: UISearchController {
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        setupAppearenceTextField()
        setupAppearenceSeacrhBar()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let color = #colorLiteral(red: 0.7176470588, green: 0.5176470588, blue: 0.7176470588, alpha: 1)
    
    private func setupAppearenceTextField(){
        let textField = self.searchBar.searchTextField
        textField.textColor = color
        textField.backgroundColor = .white
        textField.font = UIFont.boldSystemFont(ofSize: 16)
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = color.cgColor
        textField.layer.cornerRadius = 10.0
        textField.clipsToBounds = true
        textField.leftView?.tintColor = color
        // Change color of placeholder text
        let attributedPlaceholder = NSAttributedString(string: "Search Coctail", attributes: [NSAttributedString.Key.foregroundColor: color])
        textField.attributedPlaceholder = attributedPlaceholder
   }
    
    private func setupAppearenceSeacrhBar(){
        self.hidesNavigationBarDuringPresentation = false
        self.obscuresBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        
        let searchBar = self.searchBar
        searchBar.tintColor = color//apply for cancel button too
        searchBar.backgroundColor = .clear
        searchBar.layer.shadowColor = color.cgColor
        searchBar.layer.shadowOpacity = 1.0
        searchBar.layer.shadowRadius = 5.0
        searchBar.layer.shadowOffset = CGSize(width: 2, height: 2)
        searchBar.layer.cornerRadius = 10.0
        searchBar.clipsToBounds = true
    }
}
