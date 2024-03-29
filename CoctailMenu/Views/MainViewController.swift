//
//  ViewController.swift
//  CoctailMenu
//
//  Created by Polina on 11.03.2024.
//

import UIKit
import Combine
class MainViewController: UIViewController {
    
    private var viewModel: MainViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    private let searchController = CoctailSearchController(searchResultsController: nil)
    private let activityIndicator = UIActivityIndicatorView(frame: .zero)
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    
    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    init(viewModel: MainViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        observeData()
        setUpSearchController()
        configActivityIndecator()
        configureCollectionView()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.checkFavorities()
    }
    
    private func observeData(){
        viewModel.favoritiesPublisher
            .dropFirst()
            .sink { [unowned self] dict in
                let coctails = dict.filter({ $0.value == true }).map({ $0.key.name })
                print("❤️ \(coctails)")
                collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.isLoadedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoaded in
                guard let self else { return }
                actionForUI(isLoaded: isLoaded)
            }
            .store(in: &cancellables)
        
        viewModel.selectedIndexPathPublisher
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                guard let self else { return }
                guard let cell = collectionView.cellForItem(at: index) as? IngridientCell else { return }
                cell.color = #colorLiteral(red: 0.9843137255, green: 0.5333333333, blue: 0.7058823529, alpha: 1) //change collor when sellect cell
            }
            .store(in: &cancellables)
        
        viewModel.indexPathCurentPublisher // when reloadeed curent indexPath update for all cell and chek here if selectedIndexPath == curentIndexPath change color for cell
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                guard let self, viewModel.selectedIndexPath == index else { return }
                guard let cell = collectionView.cellForItem(at: index) as? IngridientCell else { return }
                if viewModel.changeColorWhenReload {
                    cell.color = #colorLiteral(red: 1, green: 0.3176470588, blue: 0.1843137255, alpha: 1)
                    viewModel.changeColorWhenReload = false
                } else {
                    cell.color = #colorLiteral(red: 0.9843137255, green: 0.5333333333, blue: 0.7058823529, alpha: 1) // for cell with stored index change color in selected color when reload collectionView
                }
            }
            .store(in: &cancellables)
        
    }
    
    private func actionForUI(isLoaded: Bool){
        if isLoaded {
            activityIndicator.stopAnimating()
            UIView.animate(withDuration: 0.25) {
                self.blurView.alpha = 0
            }
            collectionView.isUserInteractionEnabled = true
            collectionView.reloadData()
        } else {
            collectionView.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.25) {
                self.blurView.alpha = 1
            }
            activityIndicator.startAnimating()
        }
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

//MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.dataCoctailsForSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section{
        case 0: return viewModel.dataCoctailsForSections[section].countIngridient
        case 1: return viewModel.dataCoctailsForSections[section].countCoctailData
        default:
            print("Default section")
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.dataCoctailsForSections[indexPath.section]{
        case .ingridients(let ingridients):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IngridientCell.resuseID, for: indexPath) as? IngridientCell else { return UICollectionViewCell() }
            cell.configCell(ingridientLabelText: ingridients[indexPath.row].title)
            viewModel.indexPathCurent = indexPath // save current indexPath
            return cell
        case .coctailData(let coctailData):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoctailCell.resuseID, for: indexPath) as? CoctailCell else { return UICollectionViewCell() }
            let data = coctailData[indexPath.row]
            cell.configCell(nameCoctail: data.name, instruction: data.instructions, ingridients: data.ingredients, isLiked: viewModel.favorities[data] ?? false)
            cell.eventPublisher.sink { [weak self] event in
                self?.viewModel.handleCellEvent(coctail: data, event: event)
            }.store(in: &cell.cancellables)
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

//MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch viewModel.dataCoctailsForSections[indexPath.section]{
        case .ingridients(let ingridients):
            viewModel.selectedIndexPath = indexPath // // save selected IndexPath
            viewModel.getIngridientsData(ingridient: ingridients[indexPath.row].title)
        case .coctailData(_): break
        }
    }
}

//MARK: - SearchController
extension MainViewController:  UISearchControllerDelegate, UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        viewModel.changeColorWhenReload = true // flag for change cell color for default when reload collectionView
        searchController.searchBar.text = "" //clean for next search
        viewModel.selectedIndexPath = .init() // clean selectedIndexPath, when reload after getCoctailData request not change color for cell , because selectedIndexPath is no cleaned up
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
        view.addSubview(blurView)
        view.bringSubviewToFront(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
