//
//  NotesViewController+UITableViewDelegate.swift
//  NotesApp3
//
//  Created by Evgeniy Fakhretdinov on 24.06.2024.
//

import UIKit

// MARK: - UITableViewDelegate

extension NotesViewController: UITableViewDelegate {
    // Обработка выбора ячейки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = fetchedResultsController.object(at: indexPath)
        if isSelecting {
            selectedNotes.insert(note)
            updateHeaderAndFooter()
        } else {
            let noteDetailController = NoteDetailViewController(with: note, delegate: self)
            navigationController?.pushViewController(noteDetailController, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // Обработка снятия выбора с ячейки
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let note = fetchedResultsController.object(at: indexPath)
        if isSelecting {
            selectedNotes.remove(note)
            updateHeaderAndFooter()
        }
    }
    
    // Удаление ячейки с заметкой
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            let note = self.fetchedResultsController.object(at: indexPath)
            
            CoreDataManager.shared.deleteNote(note)
            
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
