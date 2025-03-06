//
//  NotesViewController+UISearchBarDelegate.swift
//  NotesApp7
//
//  Created by Evgeniy Fakhretdinov on 24.06.2024.
//

import UIKit

// MARK: - UISearchBarDelegate

extension NotesViewController: UISearchBarDelegate {
    // Обновление данных при изменении текста поиска
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        isSearchActive = !searchText.isEmpty
        filteredNotes = notes.filter("title CONTAINS[c] %@ OR content CONTAINS[c] %@", searchText, searchText)
        updateSnapshot()
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
        updateSnapshot()
        updateFooterLabel()
    }
    
    // Скрытие клавиатуры при нажатии кнопки поиска
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
