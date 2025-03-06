//
//  NotesViewController+UITableViewDelegate.swift
//  NotesApp7
//
//  Created by Evgeniy Fakhretdinov on 24.06.2024.
//

import UIKit

// MARK: - UITableViewDelegate

extension NotesViewController: UITableViewDelegate {
    // Обработка выбора ячейки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let note = dataSource.itemIdentifier(for: indexPath) else { return }
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
        guard let note = dataSource.itemIdentifier(for: indexPath) else { return }
        if isSelecting {
            selectedNotes.remove(note)
            updateHeaderAndFooter()
        }
    }
    
    // Удаление ячейки с заметкой
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: UIElements.delete) { [weak self] (action, view, completionHandler) in
            guard let self = self, let note = self.dataSource.itemIdentifier(for: indexPath) else { return }
            
            // Удаляем заметку из snapshot
            var snapshot = self.dataSource.snapshot()
            snapshot.deleteItems([note])
            self.dataSource.apply(snapshot, animatingDifferences: true) {
                // Удаляем заметку из Realm
                try! RealmManager.shared.realm.write {
                    RealmManager.shared.realm.delete(note)
                }
                self.updateFooterLabel()
            }
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}


