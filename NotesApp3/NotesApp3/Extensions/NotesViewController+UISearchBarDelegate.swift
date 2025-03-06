//
//  NotesViewController+UISearchBarDelegate.swift
//  NotesApp3
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
        let predicate: NSPredicate?
        if searchText.isEmpty {
            predicate = nil
        } else {
            predicate = NSPredicate(format: "title CONTAINS[cd] %@ OR content CONTAINS[cd] %@", searchText, searchText)
        }
        fetchedResultsController.fetchRequest.predicate = predicate
        performFetchAndUpdateTableView()
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
        performFetchAndUpdateTableView()
    }
    
    // Скрытие клавиатуры при нажатии кнопки поиска
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
