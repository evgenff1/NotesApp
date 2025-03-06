//
//  NotesViewController+UISearchBarDelegate.swift
//  NotesApp5
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
            fetchedResultsController.fetchRequest.predicate = nil
        } else {
            isSearchActive = true
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "title CONTAINS[cd] %@ OR content CONTAINS[cd] %@", searchText, searchText)
        }
        performFetchAndUpdateDataSource(animate: true)
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
        fetchedResultsController.fetchRequest.predicate = nil
        performFetchAndUpdateDataSource(animate: true)
        updateFooterLabel()
    }
    
    // Скрытие клавиатуры при нажатии кнопки поиска
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
