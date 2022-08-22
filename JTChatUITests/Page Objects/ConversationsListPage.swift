//
//  ConversationsListPage.swift
//  JTChatUITests
//
//  Created by Evgeny on 18.05.2022.
//

import XCTest

struct ConversationsListPage {
    let application = XCUIApplication()
    
    var profileButton: XCUIElement {
        application.descendantElement(matching: .button, identifier: "ProfileButton")
    }
}

extension ConversationsListPage {
    func openProfilePage() -> ProfilePage {
        profileButton.tap()
        return ProfilePage()
    }
}
