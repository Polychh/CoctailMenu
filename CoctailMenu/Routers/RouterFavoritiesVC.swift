//
//  RouterFavoritiesVC.swift
//  CoctailMenu
//
//  Created by Polina on 14.03.2024.
//

import UIKit

protocol RouterFavoritiesVCProtocol: RouterProtocolMain{
    var builder: BuilderFavoritiesFlow { get }
    func favoritiesViewController()
}

final class RouterFavoritiesVC: RouterFavoritiesVCProtocol{
    var navigationController: UINavigationController
    
    var builder: BuilderFavoritiesFlow
    init(navigationController: UINavigationController, builder: BuilderFavoritiesFlow) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    func favoritiesViewController() {
        let favoritiesVC = builder.buildFavoritiesVC(router: self)
        navigationController.viewControllers = [favoritiesVC]
    }
}
