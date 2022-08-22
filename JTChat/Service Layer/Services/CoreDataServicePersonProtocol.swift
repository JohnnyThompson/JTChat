//
//  CoreDataServicePersonProtocol.swift
//  JTChat
//
//  Created by Evgeny on 10.05.2022.
//

import CoreData

protocol CoreDataServicePersonProtocol {
    func getPerson() -> DBPerson?
    func modifyPerson(fullName: String, aboutMe: String, location: String, completion: @escaping () -> Void)
}
