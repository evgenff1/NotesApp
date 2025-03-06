//
//  NotesViewController+NSFetchedResultsControllerDelegate.swift
//  NotesApp3
//
//  Created by Evgeniy Fakhretdinov on 26.06.2024.
//

import UIKit
import CoreData

extension NotesViewController: NSFetchedResultsControllerDelegate {
    
    // MARK: - NSFetchedResultsControllerDelegate Methods
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        notesView.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                notesView.tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                notesView.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath, let cell = notesView.tableView.cellForRow(at: indexPath) as? NoteTableViewCell {
                let note = fetchedResultsController.object(at: indexPath)
                cell.configureCell(with: note)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                notesView.tableView.moveRow(at: indexPath, to: newIndexPath)
            }
        @unknown default:
            fatalError("Unknown case in NSFetchedResultsController")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        notesView.tableView.endUpdates()
        updateFooterLabel()
    }
}

