//
//  InitialsImageViewProtocol.swift
//  JTChat
//
//  Created by Evgeny on 10.05.2022.
//

import UIKit

protocol InitialsImageViewProtocol: UIImageView {
    func changeName(with fullName: String?)
    func makeLabelVisible(_ isVisible: Bool)
}
