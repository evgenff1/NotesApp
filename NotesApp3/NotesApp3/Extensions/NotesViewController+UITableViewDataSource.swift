//
//  NotesViewController+UITableViewDataSource.swift
//  NotesApp3
//
//  Created by Evgeniy Fakhretdinov on 23.06.2024.
//

import UIKit

// MARK: - UITableViewDataSource

extension NotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier, for: indexPath) as? NoteTableViewCell else {
            fatalError("Unable to dequeue NoteTableViewCell")
        }
        let note = fetchedResultsController.object(at: indexPath)
        cell.configureCell(with: note)
        return cell
    }
}

