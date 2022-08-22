//
//  ProfileButton.swift
//  JTChat
//
//  Created by Евгений Карпов on 19.03.2022.
//

import UIKit

final public class ProfileButton: UIButton {
    convenience init(title: String) {
        self.init(frame: .zero)
        self.backgroundColor = .buttonBackground()
        self.layer.cornerRadius = 7
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .helvetica19Medium
        self.titleLabel?.textAlignment = .right
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.setTitleColor(.mainText(), for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
