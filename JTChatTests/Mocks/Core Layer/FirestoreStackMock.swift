//
//  FirestoreStackMock.swift
//  JTChatTests
//
//  Created by Evgeny on 18.05.2022.
//

@testable import JTChat
import FirebaseFirestore

class FirestoreStackMock: FirestoreStackProtocol {
    var invokedDataBaseGetter = false
    var invokedDataBaseGetterCount = 0
    var stubbedDataBase: Firestore!

    var dataBase: Firestore {
        invokedDataBaseGetter = true
        invokedDataBaseGetterCount += 1
        return stubbedDataBase
    }

    var invokedAddSnapshotListener = false
    var invokedAddSnapshotListenerCount = 0
    var invokedAddSnapshotListenerParameters: (type: CollectionReferenceType, channelId: String?)?
    var invokedAddSnapshotListenerParametersList = [(type: CollectionReferenceType, channelId: String?)]()
    var stubbedAddSnapshotListenerDocumentChangeResult: (DocumentChange, Void)?

    func addSnapshotListener(type: CollectionReferenceType, channelId: String?, documentChange: @escaping (DocumentChange) -> Void) {
        invokedAddSnapshotListener = true
        invokedAddSnapshotListenerCount += 1
        invokedAddSnapshotListenerParameters = (type, channelId)
        invokedAddSnapshotListenerParametersList.append((type, channelId))
        if let result = stubbedAddSnapshotListenerDocumentChangeResult {
            documentChange(result.0)
        }
    }

    var invokedChange = false
    var invokedChangeCount = 0
    // swiftlint:disable large_tuple
    var invokedChangeParameters: (
        type: CollectionReferenceType,
        action: FirestoreAction,
        dict: [String: Any]?,
        channelId: String?,
        identifier: String?
    )?
    // swiftlint:enable large_tuple
    var invokedChangeParametersList = [(
        type: CollectionReferenceType, action: FirestoreAction, dict: [String: Any]?, channelId: String?, identifier: String?)]()

    func change(type: CollectionReferenceType, action: FirestoreAction, dict: [String: Any]?, channelId: String?, identifier: String?) {
        invokedChange = true
        invokedChangeCount += 1
        invokedChangeParameters = (type, action, dict, channelId, identifier)
        invokedChangeParametersList.append((type, action, dict, channelId, identifier))
    }
}
