//
//  ProfileTextField.swift
//  JTChat
//
//  Created by Evgeny on 28.03.2022.
//

import UIKit

final class ProfileTextField: UITextField {
    convenience init(placeholder: String, font: UIFont = .helvetica16) {
        self.init(frame: .zero)
        self.isEnabled = false
        var attribute = [NSAttributedString.Key: AnyObject]()
        attribute[.foregroundColor] = UIColor.mainText()
        let attributedString = NSAttributedString(string: placeholder, attributes: attribute)
        self.attributedPlaceholder = attributedString
        self.font = font
        self.textAlignment = .center
        self.textColor = .mainText()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
