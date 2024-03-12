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
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        observeData()
        setUpSearchController()
        configActivityIndecator()
        configureCollectionView()
        setConstraints()
    }
    
    private func observeData(){
//        viewModel.$dataCoctailsForSections
//            .dropFirst() //отбрасываем пустой массив
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] data in
//                guard let self else {return}
//                if viewModel.isLoaded {
//                    collectionView.reloadData()
//                }
//                print("get data \(data)")
//            }
//            .store(in: &cancellables)
        viewModel.$isLoaded
            //.dropFirst() //если уберу запрос в сеть через init ViewModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoaded in
                guard let self else {return}
                if isLoaded {
                    activityIndicator.stopAnimating()
                    collectionView.reloadData()
                } else {
                    activityIndicator.startAnimating()
                }

//                isLoaded ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
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
    
    func configureCollectionView(){
        collectionView.backgroundColor = .none
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = createLayout()
        collectionView.register(IngridientCell.self, forCellWithReuseIdentifier: IngridientCell.resuseID)
        collectionView.register(CoctailCell.self, forCellWithReuseIdentifier: CoctailCell.resuseID)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.resuseID)
    }
}
//MARK: - Configure SearchController
private extension MainViewController{
    func setUpSearchController(){
        searchController.delegate = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

//MARK: - Create CollectionViewLayput
private extension MainViewController{
    private func createLayout() -> UICollectionViewCompositionalLayout{
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self else { return nil }
            let section = viewModel.dataCoctailsForSections[sectionIndex]
            switch section{
            case .ingridients(_):
                return createIngridientsSectionLayout()
            case .coctailData(_):
                return createCoctailDataSectionLayout()
            }
        }
    }
    
    private func createIngridientsSectionLayout() -> NSCollectionLayoutSection{
        let item = CompositionLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 0)
        let group = CompositionLayout.createGroup(alignment: .horizontal, width: .estimated(110), height: .estimated(40), subitems: [item])
        let section = CompositionLayout.createSection(group: group, scrollBehavior: .continuous, groupSpacing: 10, leading: 10, trailing: 10, supplementary: [createHeader()])
        return section
    }
    
    private func createCoctailDataSectionLayout() -> NSCollectionLayoutSection{
        let item = CompositionLayout.createItem(width: .fractionalWidth(0.5), height: .fractionalHeight(1), spacing: 5)
        let group = CompositionLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalHeight(0.2), subitems: [item])
        let section = CompositionLayout.createSection(group: group, scrollBehavior: .none, groupSpacing: 0, leading: 10, trailing: 10, supplementary: [createHeader()])
        return section
    }
   
    private func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem{
        .init(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
   
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.dataCoctailsForSections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section{
        case 0: return viewModel.dataCoctailsForSections[section].countIngridient
        case 1: return viewModel.dataCoctailsForSections[section].countCoctailData
        default:
            print("Default")
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.dataCoctailsForSections[indexPath.section]{
            
        case .ingridients(let ingridients):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IngridientCell.resuseID, for: indexPath) as? IngridientCell else { return UICollectionViewCell() }
            cell.configCell(ingridientLabelText: ingridients[indexPath.row].title)
            return cell
        case .coctailData(let coctailData):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoctailCell.resuseID, for: indexPath) as? CoctailCell else { return UICollectionViewCell() }
            let data = coctailData[indexPath.row]
            cell.configCell(nameCoctail: data.name, instruction: data.instructions, ingridients: data.ingredients)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind{
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.resuseID, for: indexPath) as? HeaderView else { return UICollectionReusableView()}
            header.configureHeader(sectionTitle: viewModel.dataCoctailsForSections[indexPath.section].title)
            return header
        default:
            return UICollectionReusableView()
        }
    }
}

//MARK: - SearchController
extension MainViewController:  UISearchControllerDelegate, UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        viewModel.getCoctailData(searchWord: searchText)
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
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
