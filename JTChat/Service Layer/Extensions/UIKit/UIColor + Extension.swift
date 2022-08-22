//
//  UIColor + Extension.swift
//  JTChat
//
//  Created by Евгений Карпов on 01.03.2022.
//

import UIKit

extension UIColor {
    
    // MARK: - Themes color
    
    static var mainBackground: UIColor {
        ThemesPicker.currentTheme.mainBackground
    }
    
    static func navigationBackground() -> UIColor {
        ThemesPicker.currentTheme.navigationBackground
    }
    
    static func onlineCell() -> UIColor {
        ThemesPicker.currentTheme.onlineCell
    }
    
    static func offlineCell() -> UIColor {
        ThemesPicker.currentTheme.offlineCell
    }
    
    static func incomingCell() -> UIColor {
        ThemesPicker.currentTheme.incomingCell
    }
    
    static func outgoingCell() -> UIColor {
        ThemesPicker.currentTheme.outgoingCell
    }
    
    static func mainText() -> UIColor {
        ThemesPicker.currentTheme.mainText
    }
    
    static func attributeText() -> UIColor {
        ThemesPicker.currentTheme.attributeText
    }
    
    static func buttonBackground() -> UIColor {
        ThemesPicker.currentTheme.buttonBackground
    }
    
    static func profileImageBackground() -> UIColor {
        ThemesPicker.currentTheme.profileImageBackground
    }
}
