//
//  TabBarCoctaol.swift
//  CoctailMenu
//
//  Created by Polina on 14.03.2024.
//

import UIKit

final class CoctailTabBarController: UITabBarController {
    
    let builderTabFlow: BulderTabBarProtocol
    private let color = #colorLiteral(red: 0.7176470588, green: 0.5176470588, blue: 0.7176470588, alpha: 1)
    
    init(builderTabFlow: BulderTabBarProtocol) {
        self.builderTabFlow = builderTabFlow
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarAppearence()
        generateTabBar(builderTabBarFlow: builderTabFlow)
    }
    
    private func generateTabBar(builderTabBarFlow: BulderTabBarProtocol){
        let mainTab = builderTabBarFlow.buildMainVCFlow(nav: generateVC(title: "Main", image: UIImage(systemName: "house")))
        let favTab = builderTabBarFlow.buildFavoritiesVCFlow(nav: generateVC(title: "Favorities", image: UIImage(systemName: "heart.fill")))
        self.setViewControllers([mainTab, favTab], animated: true)
    }
    
    private func generateVC( title: String, image: UIImage?) -> UINavigationController{
        let nav = UINavigationController()
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.navigationBar.titleTextAttributes =  [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor: color
        ]
        return nav
    }
    
    private func setTabBarAppearence(){
        self.tabBar.layer.borderWidth = 0.5
        self.tabBar.layer.borderColor = color.cgColor
        self.tabBar.backgroundColor = .white
        self.tabBar.tintColor = color
    }
}
