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

    override func viewDidLoad() {
        super.viewDidLoad()
        observeData()
    }
    
    private func observeData(){
        viewModel.$dataCoctail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                guard let self else {return}
                print("get data \(data)")
            }
            .store(in: &cancellables)
    }
}

