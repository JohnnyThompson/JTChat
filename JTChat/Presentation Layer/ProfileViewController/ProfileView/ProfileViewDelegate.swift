//
//  ProfileViewDelegate.swift
//  JTChat
//
//  Created by Evgeny on 18.04.2022.
//

protocol ProfileViewDelegate: AnyObject {
    func closeButtonTapped()
    func editImageButtonTapped()
    func saveChangesButtonTapped()
    func editProfileButtonTapped()
    func cancelChangesButtonTapped()
}
