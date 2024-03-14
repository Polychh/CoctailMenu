//
//  BuilderGavoritiesFlow.swift
//  CoctailMenu
//
//  Created by Polina on 14.03.2024.
//

import UIKit

protocol BuilderFavoritiesFlowProtocol{
    func buildFavoritiesVC(router: RouterFavoritiesVCProtocol) -> UIViewController
}

final class BuilderFavoritiesFlow: BuilderFavoritiesFlowProtocol {
    func buildFavoritiesVC(router: RouterFavoritiesVCProtocol) -> UIViewController {
        let store = StoreManager()
        let viewModel = FavoritiesViewModel(storeManager: store)
        let vc = FavoritiesViewController(viewModel: viewModel)
        return vc
    }
}
