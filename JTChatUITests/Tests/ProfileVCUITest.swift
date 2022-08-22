//
//  ProfileVCUITest.swift
//  JTChatUITests
//
//  Created by Evgeny on 18.05.2022.
//

import XCTest

class ProfileVCUITests: XCTestCase {
    
    func testProfileViewElementsExist() {
        let app = XCUIApplication()
        app.launch()
        
        let conversationListPage = ConversationsListPage()
        
        let profileButton = conversationListPage.profileButton
        XCTAssert(profileButton.exists)
        
        let profilePage = conversationListPage.openProfilePage()
        
        profilePageViewsExists(profilePage)
        profilePageButtonsExists(profilePage)
        profilePageTextFieldsExists(profilePage)
    }
    
    private func profilePageViewsExists(_ profilePage: ProfilePage) {
        let profileViewExists = profilePage.profileView.exists
        XCTAssertTrue(profileViewExists)
        let headerLabelExists = profilePage.headerLabel.exists
        XCTAssertTrue(headerLabelExists)
        let photoImageExists = profilePage.photoImage.exists
        XCTAssertTrue(photoImageExists)
    }
    
    private func profilePageButtonsExists(_ profilePage: ProfilePage) {
        let cancelButtonExists = profilePage.cancelButton.exists
        XCTAssertTrue(cancelButtonExists)
        let editButtonExists = profilePage.editButton.exists
        XCTAssertTrue(editButtonExists)
        let editProfileButtonExists = profilePage.editProfileButton.exists
        XCTAssertTrue(editProfileButtonExists)
    }
    
    private func profilePageTextFieldsExists(_ profilePage: ProfilePage) {
        let fullNameTextFieldExists = profilePage.fullNameTextField.exists
        XCTAssertTrue(fullNameTextFieldExists)
        let aboutMeTextFieldExists = profilePage.aboutMeTextField.exists
        XCTAssertTrue(aboutMeTextFieldExists)
        let locationTextFieldExists = profilePage.locationTextField.exists
        XCTAssertTrue(locationTextFieldExists)
    }
}
