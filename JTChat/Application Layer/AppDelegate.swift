//
//  AppDelegate.swift
//  JTChat
//
//  Created by Евгений Карпов on 18.02.2022.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties
    
    var window: UIWindow?
    
    // MARK: - Functions
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let rootVC = ConversationListViewController()
        let navigationController = RootNavigationController(rootViewController: rootVC)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        if let themeTag = UserDefaults.standard.value(forKey: "CurrentTheme") as? Int {
            var currentTheme: ThemesColorProtocol
            
            switch themeTag {
            case 2:
                currentTheme = ClassicTheme()
            case 3:
                currentTheme = DayTheme()
            case 4:
                currentTheme = NightTheme()
            default:
                currentTheme = DefaultTheme()
            }
            
            ThemesPicker.currentTheme = currentTheme
        }
        
        return true
    }
}
