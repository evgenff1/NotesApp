//
//  NotesViewController+UISearchBarDelegate.swift
//  NotesApp1
//
//  Created by Evgeniy Fakhretdinov on 24.06.2024.
//

import UIKit

// MARK: - UISearchBarDelegate

extension NotesViewController: UISearchBarDelegate {
    // Обновление данных при изменении текста поиска
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        if searchText.isEmpty {
            isSearchActive = false
            notesView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        } else {
            isSearchActive = true
            filteredNotes = notes.filter { note in
                let searchTextLowercased = searchText.lowercased()
                return (note.title.lowercased().contains(searchTextLowercased) ) ||
                (note.content.lowercased().contains(searchTextLowercased) )
            }
            notesView.tableView.reloadData()
        }
        updateFooterLabel()
    }
    
    // Показ кнопки cancel при начале редактирования
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    // Сброс поиска
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        isSearchActive = false
        notesView.tableView.reloadData()
        updateFooterLabel()
    }
    
    // Скрытие клавиатуры при нажатии кнопки поиска
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
