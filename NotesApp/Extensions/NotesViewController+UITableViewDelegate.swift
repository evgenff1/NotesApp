//
//  NotesViewController+UITableViewDelegate.swift
//  NotesApp
//
//  Created by Evgeniy Fakhretdinov on 24.06.2024.
//

import UIKit

// MARK: - UITableViewDelegate

extension NotesViewController: UITableViewDelegate {
    // Обработка выбора ячейки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let note = dataSource?.itemIdentifier(for: indexPath) else { return }
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
        guard let note = dataSource?.itemIdentifier(for: indexPath), isSelecting else { return }
        selectedNotes.remove(note)
        updateHeaderAndFooter()
    }

    // Удаление ячейки с заметкой
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            if let note = self.dataSource?.itemIdentifier(for: indexPath) {
                CoreDataManager.shared.deleteNote(note)
                self.notes.removeAll { $0.id == note.id }
                self.updateDataSourceWithNewSnapshot(with: self.notes, animate: true)
                self.updateFooterLabel()
                
                // Повторный запуск поиска, если он активен
                if self.isSearchActive, let searchText = self.notesView.searchBar.text {
                    self.searchBar(self.notesView.searchBar, textDidChange: searchText)
                }
            }
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
