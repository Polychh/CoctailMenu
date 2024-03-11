//
//  ViewController.swift
//  CoctailMenu
//
//  Created by Polina on 11.03.2024.
//

import UIKit
import Combine
class MainViewController: UIViewController {
    
    private let viewModel = MainViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let searchController = CoctailSearchController(searchResultsController: nil)
    private let activityIndicator = UIActivityIndicatorView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        observeData()
        setUpSearchController()
        configActivityIndecator()
        setConstraints()
    }
    
    private func observeData(){
        viewModel.$dataCoctail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                guard let self else {return}
                print("get data \(data)")
            }
            .store(in: &cancellables)
        viewModel.$isLoaded
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoaded in
                guard let self else {return}
                isLoaded ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
            }
            .store(in: &cancellables)
    }
}

//MARK: - SetUp UI
private extension MainViewController {
    func configActivityIndecator(){
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .large
        activityIndicator.color = .systemPink
    }
}
//MARK: - Configure SearchController
private extension MainViewController{
    func setUpSearchController(){
        //searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

//MARK: - SearchController UISearchResultsUpdating,
extension MainViewController:  UISearchControllerDelegate, UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        viewModel.getIngridientsData(searchWord: searchText)
        searchBar.resignFirstResponder()
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.setValue("Cancel", forKey: "cancelButtonText")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // dismiss keyBoard
    }
}

//MARK: - SetUp Constrains
private extension MainViewController {
    func setConstraints() {
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
