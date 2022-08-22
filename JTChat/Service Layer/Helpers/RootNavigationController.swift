//
//  RootNavigationController.swift
//  JTChat
//
//  Created by Евгений Карпов on 15.03.2022.
//

import UIKit

final class RootNavigationController: UINavigationController {
    
    // MARK: - Public properties
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        ThemesPicker.currentTheme.preferredStatusBarStyle
    }

    // MARK: - Public methods
    
    func setupNavigationController() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.mainText()]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.mainText()]
        navBarAppearance.backgroundColor = .mainBackground
        self.navigationBar.standardAppearance = navBarAppearance
        self.navigationBar.scrollEdgeAppearance = navBarAppearance
        self.navigationBar.tintColor = .mainText()
        self.toolbar.tintColor = .mainText()
    }
}
