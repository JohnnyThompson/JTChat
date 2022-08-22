//
//  CoreDataService.swift
//  JTChat
//
//  Created by Evgeny on 19.04.2022.
//

import CoreData

final class CoreDataService {
    
    // MARK: - Public properties
    
    var viewContext: NSManagedObjectContext {
        coreDataStack.viewContext
    }
    
    // MARK: - Private properties

    private let coreDataStack: CoreDataStackProtocol = CoreDataProvider.shared.coreDataStack
    
    private var logIsEnable: Bool = false
    
    private lazy var sortedChannelsFetchRequest: NSFetchRequest<DBChannel> = {
        let fetchRequest = DBChannel.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(DBChannel.lastActivity), ascending: false)
        ]
    
        return fetchRequest
    }()
    
    // MARK: - Initialization
    
    init(logIsEnable: Bool = false) {
        self.logIsEnable = logIsEnable
    }
    
    // MARK: - Private Methods
    
    private func printMessage(_ message: String) {
        if logIsEnable {
            print(message)
        }
    }
    
    private func find(
        message: Message,
        in channel: DBChannel,
        and context: NSManagedObjectContext
    ) throws -> DBMessage? {
        guard
            let channelID = channel.identifier,
            let identifier = message.identifier
        else {
            return nil
        }
    
        let fetchRequest = DBMessage.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "channelID = %@", channelID)
        fetchRequest.predicate = NSPredicate(format: "identifier = %@", identifier)
        let messages = try context.fetch(fetchRequest)
        
        return messages.first
    }
}

// MARK: - CoreDataServiceChannelsProtocol

extension CoreDataService: CoreDataServiceChannelsProtocol {
    func addChannel(channel: Channel) {
        coreDataStack.performTaskOnMainQueueContextAndSave { [weak self] context in
            guard let self = self else {
                return
            }
            
            do {
                let fetchRequest = self.sortedChannelsFetchRequest
                fetchRequest.predicate = NSPredicate(format: "identifier = %@", channel.identifier)
                let channels = try context.fetch(fetchRequest)
                if channels.isEmpty {
                    _ = DBChannel(channel: channel, context: context)
                    self.printMessage("CoreData: Channel successfully added. id: \(channel.identifier)")
                    return
                }
                self.printMessage("CoreData: Channel already added on channel! id: \(channel.identifier)")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteChannel(channel: Channel) {
        coreDataStack.performTaskOnMainQueueContextAndSave { [weak self] context in
            guard let self = self else {
                return
            }
            
            do {
                let fetchRequest = self.sortedChannelsFetchRequest
                fetchRequest.predicate = NSPredicate(format: "identifier = %@", channel.identifier)
                let channels = try context.fetch(fetchRequest)
                
                guard let dbChannel = channels.first else {
                    return
                }
                
                context.delete(dbChannel)
                
                self.printMessage("CoreData: Channel successfully deleted. id: \(channel.identifier)")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func modifyChannel(channel: Channel) {
        coreDataStack.performTaskOnMainQueueContextAndSave { [weak self] context in
            do {
                guard let fetchRequest = self?.sortedChannelsFetchRequest else {
                    return
                }
                
                fetchRequest.predicate = NSPredicate(format: "identifier = %@", channel.identifier)
                let channels = try context.fetch(fetchRequest)
                
                guard let dbChannel = channels.first else {
                    return
                }
                
                dbChannel.name = channel.name
                dbChannel.lastMessage = channel.lastMessage
                dbChannel.lastActivity = channel.lastActivity
                
                self?.printMessage("CoreData: Channel successfully modified. id: \(channel.identifier)")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
// MARK: - CoreDataServiceMessagesProtocol

extension CoreDataService: CoreDataServiceMessagesProtocol {
    func addMessage(message: Message, to channel: DBChannel) {
        coreDataStack.performTaskOnMainQueueContextAndSave { [weak self] context in
            do {
                guard
                    let self = self,
                    let identifier = channel.identifier
                else {
                    return
                }
                
                let fetchRequest = DBChannel.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "identifier = %@", identifier)
                let channels = try context.fetch(fetchRequest)
                
                guard let dbChannel = channels.first else {
                    return
                }
                
                let dbMessage = DBMessage(message: message, context: context)
                var addNeeded = true
                dbChannel.messages?.forEach { item in
                    guard
                        let dbItem = item as? DBMessage,
                        dbItem.identifier == dbMessage.identifier
                    else {
                        self.printMessage("CoreData: Message adding failed. id: \(message.identifier ?? "")")
                        return
                    }
                    
                    addNeeded = false
                    
                    self.printMessage("CoreData: Message already added on channel! id: \(message.identifier ?? "")")
                }
                if addNeeded {
                    dbMessage.channelID = dbChannel.identifier
                    dbChannel.addToMessages(dbMessage)
                    
                    self.printMessage("CoreData: Message successfully added. id: \(message.identifier ?? "")")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteMessage(message: Message, on channel: DBChannel) {
        coreDataStack.performTaskOnMainQueueContextAndSave { [weak self] context in
            guard
                let dbMessage = try? self?.find(message: message, in: channel, and: context)
            else {
                self?.printMessage("CoreData: Message deleting failed. id: \(message.identifier ?? "")")
                return
            }
            
            context.delete(dbMessage)
            self?.printMessage("CoreData: Message successfully deleted. id: \(message.identifier ?? "")")
        }
    }
    
    func modifyMessage(message: Message, on channel: DBChannel) {
        coreDataStack.performTaskOnMainQueueContextAndSave { [weak self] context in
            guard
                let dbMessage = try? self?.find(message: message, in: channel, and: context)
            else {
                self?.printMessage("CoreData: Message modifying failed. id: \(message.identifier ?? "")")
                return
            }
            
            dbMessage.content = message.content
            dbMessage.created = message.created
            dbMessage.senderName = message.senderName
            dbMessage.senderId = message.senderId
            
            self?.printMessage("CoreData: Message successfully modified. id: \(message.identifier ?? "")")
        }
    }
}
// MARK: - CoreDataServicePersonProtocol

extension CoreDataService: CoreDataServicePersonProtocol {
    func getPerson() -> DBPerson? {
        var result: DBPerson?
        coreDataStack.performTaskOnMainQueueContextAndSave { [weak self] context in
            let fetchRequest = DBPerson.fetchRequest()
            
            do {
                let persons = try context.fetch(fetchRequest)
                result = persons.first
                self?.printMessage("CoreData: Person successfully fetched")
            } catch {
                self?.printMessage("CoreData: Person fetchRequest failed")
            }
        }
        
        return result
    }
    
    func modifyPerson(fullName: String, aboutMe: String, location: String, completion: @escaping () -> Void) {
        coreDataStack.performTaskOnMainQueueContextAndSave { [weak self] context in
            let fetchRequest = DBPerson.fetchRequest()
            
            do {
                let persons = try context.fetch(fetchRequest)
                
                guard let person = persons.first else {
                    _ = DBPerson(fullName: fullName, aboutMe: aboutMe, location: location, context: context)
                    self?.printMessage("CoreData: Person successfully created")
                    completion()
                    return
                }
                
                person.fullName = fullName
                person.aboutMe = aboutMe
                person.location = location
                
                self?.printMessage("CoreData: Person successfully modified")
            } catch {
                self?.printMessage("CoreData: Person fetchRequest failed")
            }
            
            completion()
        }
    }
}
