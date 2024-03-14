//
//  FavoritiesViewController.swift
//  CoctailMenu
//
//  Created by Polina on 14.03.2024.
//


import UIKit
import Combine

class FavoritiesViewController: UIViewController {
    private let viewModel: FavoritiesViewModelProtocol
    
    private let tableView = UITableView()
    private let deleteButton = UIButton()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: FavoritiesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observe()
        setUPButtons()
        configureTableView()
        setConstrains()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getSaveCoctails()
    }
    
    private func observe(){
        viewModel.favoritiestPublisher
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

//MARK: - Configure UIElements
private extension FavoritiesViewController{
     func configureTableView() {
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.resuseID)
    }
    func setUPButtons(){
        configButton(button: deleteButton, title: "DELETE")
        deleteButton.addTarget(nil, action: #selector(deleteTapped), for: .touchUpInside)
    }
    
    @objc func deleteTapped(){
        viewModel.deleteAllFavs()
    }
    
    func configButton(button: UIButton, title: String){
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.7176470588, green: 0.5176470588, blue: 0.7176470588, alpha: 1)
    }

}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension FavoritiesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Favorities view count \(viewModel.favorities.count)")
        return viewModel.favorities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.resuseID, for: indexPath) as? FavoriteCell else {return UITableViewCell()}
        let data = viewModel.favorities[indexPath.row]
        cell.selectionStyle = .none
        cell.configCell(coctailName: data.nameCoctail ?? "", ingridients: data.ingridients ?? "", instruction: data.instruction ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
          let data = viewModel.favorities[indexPath.row]
          viewModel.deleteOneItem(nameCoctail: data.nameCoctail ?? "")
          tableView.deleteRows(at: [indexPath], with: .automatic)
      }
    }
}

//MARK: - Set Constrains
private extension FavoritiesViewController{
    func setConstrains(){
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            tableView.bottomAnchor.constraint(equalTo: deleteButton.topAnchor,constant: -16),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 100),
            deleteButton.heightAnchor.constraint(equalToConstant: 30),
            
        ])
    }
}

