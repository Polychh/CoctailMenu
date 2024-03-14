//
//  BuilderTabBarCoctail.swift
//  CoctailMenu
//
//  Created by Polina on 14.03.2024.
//

import UIKit
protocol BulderTabBarProtocol{
    func buildMainVCFlow(nav: UINavigationController) -> UINavigationController
    func buildFavoritiesVCFlow(nav: UINavigationController) -> UINavigationController
}

final class BuilderTabBarCoctail: BulderTabBarProtocol{
    func buildFavoritiesVCFlow(nav: UINavigationController) -> UINavigationController {
        let builder = BuilderFavoritiesFlow()
        let router = RouterFavoritiesVC(navigationController: nav, builder: builder)
        router.favoritiesViewController()
        return router.navigationController
    }
    
    func buildMainVCFlow(nav: UINavigationController) -> UINavigationController {
        let builder = BuilderMainFlow()
        let router = RouterMainVC(navigationController: nav, builder: builder)
        router.mainViewController()
        return router.navigationController
    }
}
