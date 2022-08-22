//
//  ThemesPicker.swift
//  JTChat
//
//  Created by Евгений Карпов on 13.03.2022.
//

import UIKit

final class ThemesPicker: ThemesPickerDelegate {
    
    // MARK: - Public properties
    
    static var currentTheme: ThemesColorProtocol = DefaultTheme()
    
    // MARK: - Public methods
    
    func updateTheme() {
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
    }
}
