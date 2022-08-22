//
//  ProfilePage.swift
//  JTChatUITests
//
//  Created by Evgeny on 18.05.2022.
//

import XCTest

struct ProfilePage {
    let application = XCUIApplication()
    
    var profileView: XCUIElement {
        application.descendantElement(matching: .other, identifier: "profileView")
    }
    
    var headerLabel: XCUIElement {
        application.descendantElement(matching: .any, identifier: "headerLabel")
    }
    
    var cancelButton: XCUIElement {
        application.descendantElement(matching: .button, identifier: "cancelButton")
    }
    
    var photoImage: XCUIElement {
        application.descendantElement(matching: .image, identifier: "photoImage")
    }
    
    var editButton: XCUIElement {
        application.descendantElement(matching: .button, identifier: "editButton")
    }
    
    var fullNameTextField: XCUIElement {
        application.descendantElement(matching: .textField, identifier: "fullNameTextField")
    }
    
    var aboutMeTextField: XCUIElement {
        application.descendantElement(matching: .textField, identifier: "aboutMeTextField")
    }
    
    var locationTextField: XCUIElement {
        application.descendantElement(matching: .textField, identifier: "locationTextField")
    }
    
    var saveChangesButton: XCUIElement {
        application.descendantElement(matching: .button, identifier: "saveChangesButton")
    }
    
    var editProfileButton: XCUIElement {
        application.descendantElement(matching: .button, identifier: "editProfileButton")
    }
    
    var cancelChangesButton: XCUIElement {
        application.descendantElement(matching: .button, identifier: "cancelChangesButton")
    }
}
