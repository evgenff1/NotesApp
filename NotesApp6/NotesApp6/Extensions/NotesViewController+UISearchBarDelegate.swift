//
//  NotesViewController+UISearchBarDelegate.swift
//  NotesApp6
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
        } else {
            isSearchActive = true
            filteredNotes = notes.filter("title CONTAINS[c] %@ OR content CONTAINS[c] %@", searchText, searchText)
        }
        notesView.tableView.reloadData()
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
