//
//  ProfileViewControllerDelegate.swift
//  JTChat
//
//  Created by Evgeny on 21.04.2022.
//

import UIKit

protocol ProfileViewControllerDelegate: AnyObject {
    func setImage(image: UIImage?)
    func makeLabelVisible(bool: Bool)
    func changeName(with: String?)
    func getPerson() -> Person
    func updatePerson(person: Person?)
    func activityIndicatorIsAnimating(_ bool: Bool)
    func openAnimations()
    func closedAnimations()
}
