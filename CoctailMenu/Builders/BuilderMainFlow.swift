//
//  BulderMainFlow.swift
//  CoctailMenu
//
//  Created by Polina on 13.03.2024.
//

import UIKit

protocol BuilderMainFlowProtocol{
    func buildMainVC(router: RouterMainVCProtocol) -> UIViewController
}

final class BuilderMainFlow: BuilderMainFlowProtocol {
    func buildMainVC(router: RouterMainVCProtocol) -> UIViewController {
        let network = NetworkManager()
        let store = StoreManager()
        let viewModel = MainViewModel(network: network, store: store)
        let vc = MainViewController(viewModel: viewModel)
        return vc
    }
}
