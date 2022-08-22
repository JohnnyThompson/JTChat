//
//  FetchedResultControllerDelegate.swift
//  JTChat
//
//  Created by Evgeny on 14.04.2022.
//

import UIKit
import CoreData

protocol ConversationVCDelegate: AnyObject {
    var tableView: UITableView { get }
}

final class FetchedResultControllerDelegate: NSObject, NSFetchedResultsControllerDelegate {
    weak var delegate: ConversationVCDelegate?
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.tableView.endUpdates()
    }

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else {
                return
            }

            delegate?.tableView.insertRows(at: [newIndexPath], with: .none)

        case .delete:
            guard let indexPath = indexPath else {
                return
            }

            delegate?.tableView.deleteRows(at: [indexPath], with: .automatic)

        case .move:
            guard
                let indexPath = indexPath,
                let newIndexPath = newIndexPath
            else {
                return
            }

            delegate?.tableView.deleteRows(at: [indexPath], with: .automatic)
            delegate?.tableView.insertRows(at: [newIndexPath], with: .automatic)

        case .update:
            guard let indexPath = indexPath else {
                return
            }

            delegate?.tableView.reloadRows(at: [indexPath], with: .automatic)

        @unknown default:
            return
        }
    }
}
