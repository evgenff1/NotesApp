//
//  NotesViewController+UITableViewDataSource.swift
//  NotesApp2
//
//  Created by Evgeniy Fakhretdinov on 23.06.2024.
//

import UIKit

// MARK: - UITableViewDataSource

extension NotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchActive ? filteredNotes.count : notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier, for: indexPath) as? NoteTableViewCell else {
            fatalError("Unable to dequeue NoteTableViewCell")
        }
        let note = isSearchActive ? filteredNotes[indexPath.row] : notes[indexPath.row]
        cell.configureCell(with: note)
        return cell
    }
}

