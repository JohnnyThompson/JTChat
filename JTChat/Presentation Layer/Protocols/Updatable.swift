//
//  Updatable.swift
//  JTChat
//
//  Created by Evgeny on 28.04.2022.
//

import UIKit

protocol Updatable: UIViewController {
    func updateAndSave(with stringURL: String)
}
