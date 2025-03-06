//
//  NotesViewController+UITableViewDelegate.swift
//  NotesApp6
//
//  Created by Evgeniy Fakhretdinov on 24.06.2024.
//

import UIKit

// MARK: - UITableViewDelegate

extension NotesViewController: UITableViewDelegate {
    // Обработка выбора ячейки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = isSearchActive ? filteredNotes[indexPath.row] : notes[indexPath.row]
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
        let note = isSearchActive ? filteredNotes[indexPath.row] : notes[indexPath.row]
        if isSelecting {
            selectedNotes.remove(note)
            updateHeaderAndFooter()
        }
    }
    
    // Удаление ячейки с заметкой
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            let note = self.isSearchActive ? self.filteredNotes[indexPath.row] : self.notes[indexPath.row]
            
            try! RealmManager.shared.realm.write {
                RealmManager.shared.realm.delete(note)
            }
            
            // Если поиск активен, обновляем filteredNotes и перезагружаем таблицу
            if self.isSearchActive {
                self.filteredNotes = self.notes.filter("title CONTAINS[c] %@ OR content CONTAINS[c] %@", self.notesView.searchBar.text ?? "", self.notesView.searchBar.text ?? "")
                loadNotes()
            }
            
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}
