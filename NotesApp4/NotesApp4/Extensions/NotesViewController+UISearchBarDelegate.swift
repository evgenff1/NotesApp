//
//  NotesViewController+UISearchBarDelegate.swift
//  NotesApp4
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
            updateDataSourceWithNewSnapshot(with: notes, animate: true)
        } else {
            isSearchActive = true
            filteredNotes = notes.filter { note in
                let searchTextLowercased = searchText.lowercased()
                return (note.title?.lowercased().contains(searchTextLowercased) ?? false) ||
                (note.content?.lowercased().contains(searchTextLowercased) ?? false)
            }
            updateDataSourceWithNewSnapshot(with: filteredNotes, animate: true)
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
        updateDataSourceWithNewSnapshot(with: notes, animate: true)
        updateFooterLabel()
    }
    
    // Скрытие клавиатуры при нажатии кнопки поиска
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
