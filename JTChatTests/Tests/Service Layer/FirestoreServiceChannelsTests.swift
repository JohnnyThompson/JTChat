//
//  FirestoreServiceChannelsTests.swift
//  JTChatTests
//
//  Created by Evgeny on 18.05.2022.
//

import XCTest
@testable import JTChat

class FirestoreServiceChannelsTests: XCTestCase {
    
    let firestoreStack = FirestoreStackMock()
    let channelName = "Foo"
    
    var sut: FirestoreServiceChannelsProtocol!
    var channel: Channel!
    
    override func setUp() {
        super.setUp()
        sut = build()
        channel = Channel(channelName: channelName)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testFirestoreServiceAddingSnapshotListener() {
        sut.addChannelsSnapshotListener { _ in
            return
        } modified: { _ in
            return
        } deleted: { _ in
            return
        }
        
        XCTAssertTrue(firestoreStack.invokedAddSnapshotListener)
        XCTAssertEqual(firestoreStack.invokedAddSnapshotListenerParameters?.type, .channels)
    }
    
    func testFirestoreServiceAddingChannel() {
        sut.addChanel(channel: channel)
        
        XCTAssertTrue(firestoreStack.invokedChange)
        XCTAssertEqual(firestoreStack.invokedChangeParameters?.type, .channels)
        XCTAssertEqual(firestoreStack.invokedChangeParameters?.action, .add)
        XCTAssertEqual((firestoreStack.invokedChangeParameters?.dict?["name"] as? String) ?? "", channelName)
    }
    
    private func build() -> FirestoreService {
        let firestoreService = FirestoreService()
        firestoreService.firestoreStack = firestoreStack
        return firestoreService
    }
}
