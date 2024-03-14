//
//  RouterMainVC.swift
//  CoctailMenu
//
//  Created by Polina on 14.03.2024.
//

import UIKit

protocol RouterProtocolMain{
    var navigationController: UINavigationController { get }
}

protocol RouterMainVCProtocol: RouterProtocolMain{
    var builder: BuilderMainFlow { get }
    func mainViewController()
}

final class RouterMainVC: RouterMainVCProtocol{
    var navigationController: UINavigationController
    
    var builder: BuilderMainFlow
    init(navigationController: UINavigationController, builder: BuilderMainFlow) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    func mainViewController() {
        let mainVC = builder.buildMainVC(router: self)
        navigationController.viewControllers = [mainVC]
    }
}
