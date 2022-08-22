//
//  UIFont + Extension.swift
//  JTChat
//
//  Created by Евгений Карпов on 01.03.2022.
//

import UIKit

extension UIFont {
    
    // MARK: - Helvetica
    
    static var helvetica16: UIFont {
        return UIFont(name: "Helvetica Neue Light", size: 16) ?? .systemFont(ofSize: 16)
    }
    
    // MARK: - Helvetica Medium
    
    static var helvetica19Medium: UIFont {
        return UIFont(name: "Helvetica Neue Medium", size: 19) ?? .systemFont(ofSize: 19)
    }
    
    static var helvetica120Medium: UIFont {
        return UIFont(name: "Helvetica Neue Medium", size: 120) ?? .systemFont(ofSize: 120)
    }
    
    // MARK: - Helvetica Bold
    
    static var helvetica24Bold: UIFont {
        return UIFont(name: "Helvetica Neue Bold", size: 24) ?? .systemFont(ofSize: 24)
    }
    
    static var helvetica26Bold: UIFont {
        return UIFont(name: "Helvetica Neue Bold", size: 26) ?? .systemFont(ofSize: 26)
    }
}
