//
//  NotesViewController+NSFetchedResultsControllerDelegate.swift
//  NotesApp5
//
//  Created by Evgeniy Fakhretdinov on 26.06.2024.
//

import UIKit
import CoreData

extension NotesViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // Начало обновления данных
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // Конец обновления данных
        updateDataSourceWithNewSnapshot(animate: true)
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let note = anObject as? Note else { return }
        
        guard var snapshot = dataSource?.snapshot() else {
            return
        }
        
        switch type {
        case .insert:
            snapshot.appendItems([note], toSection: .main)
        case .delete:
            snapshot.deleteItems([note])
        case .update:
            snapshot.reloadItems([note])
        case .move:
            snapshot.deleteItems([note])
            snapshot.appendItems([note], toSection: .main)
            snapshot.reloadItems([note])
        @unknown default:
            fatalError("Unknown case in NSFetchedResultsChangeType")
        }
        
        DispatchQueue.main.async {
            self.dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }
}

