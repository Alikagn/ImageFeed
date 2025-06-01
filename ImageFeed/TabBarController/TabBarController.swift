//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Dmitry Batorevich on 31.05.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "tab_profile_active"), selectedImage: nil)
        
        self.viewControllers = [imagesListViewController, profileViewController]
        
        setupTabBar()
    }

    private func setupTabBar() {
        tabBar.barTintColor = .ypBlack
        tabBar.isTranslucent = false
        tabBar.tintColor = .ypWhite
        tabBar.unselectedItemTintColor = .ypGray
        view.backgroundColor = .ypBlack
    }
}
