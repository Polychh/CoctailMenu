//
//  BulderMainFlow.swift
//  CoctailMenu
//
//  Created by Polina on 13.03.2024.
//

import UIKit

protocol BuilderMainFlowProtocol{
    func buildMainVC() -> UIViewController
}

final class BuilderMainFlow: BuilderMainFlowProtocol {
    func buildMainVC() -> UIViewController {
        let network = NetworkManager()
        let viewModel = MainViewModel(network: network)
        let vc = MainViewController(viewModel: viewModel)
        return vc
    }
}
