//
//  NotesViewController.swift
//  NotesApp7
//
//  Created by Evgeniy Fakhretdinov on 22.06.2024.
//

import UIKit
import RealmSwift

class NotesViewController: UIViewController {
    
    // MARK: - UI Elements
    
    lazy var notesView: NotesView = NotesView(frame: .zero)
    
    // MARK: - Properties
    
    var notes: Results<Note>!
    var filteredNotes: Results<Note>!
    var isSearchActive: Bool = false
    var notificationToken: NotificationToken?
    
    // Состояние выбора заметок
    var isSelecting: Bool = false
    var selectedNotes: Set<Note> = []
    
    var dataSource: UITableViewDiffableDataSource<Int, Note>!
    
    // MARK: - View Lifecycle
    
    override func loadView() {
        view = notesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        
        setupDelegates()
        setupButtonActions()
        setupNavigationBar()
        setupDataSource()
        
        //Создаем одну заметку при первом запуске
        if UserDefaults.standard.isFirstLaunch {
            UserDefaults.standard.isFirstLaunch = false
            let initialNote = RealmManager.shared.createNote(title: "First Note", content: "This is your first note.")
            RealmManager.shared.add(initialNote)
        }
        
        loadNotes()
        
    }
    
    // MARK: - Data Loading
    
    func loadNotes() {
        notes = RealmManager.shared.fetchNotes()
        notificationToken = notes.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case .initial:
                self.updateSnapshot(animatingDifferences: false)
            case .update(_, _, _, _):
                self.updateSnapshot(animatingDifferences: true)
            case .error(let error):
                fatalError("\(error)")
            }
        }
        
        updateFooterLabel()
    }
    
    // MARK: - Delegates Setup and Buttons Setup
    
    // Настройка делегатов для UITableView и UISearchBar
    private func setupDelegates() {
        notesView.tableView.delegate = self
        notesView.searchBar.delegate = self
    }
    
    private func setupButtonActions() {
        notesView.addButton.addTarget(self, action: #selector(addNote), for: .touchUpInside)
    }
    
    // MARK: - Navigation Bar Setup
    
    // Настройка навигационной панели
    private func setupNavigationBar() {
        configureNavigationBarButton(isSelecting: false)
    }
    
    // Конфигурация навигационной панели
    private func configureNavigationBarButton(isSelecting: Bool) {
        if isSelecting {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneSelecting))
        } else {
            let selectNotesAction = UIAction(title: UIElements.selectNotes, image: UIImage(systemName: UIElements.checkmarkCircle)) { _ in
                self.startSelectingNotes()
            }
            let menu = UIMenu(title: "", children: [selectNotesAction])
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", image: UIImage(systemName: UIElements.ellipsisCircle), primaryAction: nil, menu: menu)
        }
    }
    
    // MARK: - Footer Label Update
    
    //Обновление текста футера
    func updateFooterLabel() {
        if isSearchActive {
            let foundCount = filteredNotes.count
            notesView.footerLabel.text = foundCount == 0 ? "None Found" : "\(foundCount) Found"
        } else {
            notesView.footerLabel.text = "\(notes.count) Notes"
        }
    }
    
    // MARK: - Helper Methods
    
    // Функция для создания даты
    private func createDate(daysAgo: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date()
    }
    
    // MARK: - Actions
    
    @objc private func addNote() {
        // Создание новой заметки
        let newNote = RealmManager.shared.createNote(title: "", content: "")
        RealmManager.shared.add(newNote)
        
        // Открытие экрана для редактирования новой заметки
        openNewNoteScreen(with: newNote)
    }
    
    // Начинает режим выбора заметок
    private func startSelectingNotes() {
        isSelecting = true
        notesView.searchBar.isUserInteractionEnabled = false
        if let cancelButton = notesView.searchBar.value(forKey: UIElements.cancelButton) as? UIButton {
            cancelButton.isEnabled = false
        }
        updateHeaderAndFooter()
        notesView.tableView.allowsMultipleSelectionDuringEditing = true
        notesView.tableView.setEditing(true, animated: true)
        configureNavigationBarButton(isSelecting: true)
    }
    
    // Завершает режим выбора заметок
    @objc func doneSelecting() {
        isSelecting = false
        selectedNotes.removeAll()
        notesView.searchBar.isUserInteractionEnabled = true
        if let cancelButton = notesView.searchBar.value(forKey: UIElements.cancelButton) as? UIButton {
            cancelButton.isEnabled = true
        }
        updateHeaderAndFooter()
        notesView.tableView.setEditing(false, animated: true)
        notesView.tableView.allowsMultipleSelectionDuringEditing = false
        configureNavigationBarButton(isSelecting: false)
        updateFooterLabel()
    }
    
    // Обновление заголовка и футера
    func updateHeaderAndFooter() {
        if isSelecting {
            notesView.headerLabel.text = selectedNotes.isEmpty ? "Notes" : "\(selectedNotes.count) Selected"
            notesView.footerLabel.isHidden = true
            notesView.addButton.isHidden = true
        } else {
            notesView.headerLabel.text = "Notes"
            notesView.footerLabel.text = "\(notes.count) Notes"
            notesView.footerLabel.isHidden = false
            notesView.addButton.isHidden = false
        }
        notesView.footerView.subviews.filter { $0 is UIButton && $0 != notesView.addButton }.forEach { $0.removeFromSuperview() }
        if isSelecting {
            let deleteButton = UIButton(type: .system)
            deleteButton.setTitle(selectedNotes.isEmpty && !isSearchActive ? UIElements.deleteAll : UIElements.delete, for: .normal)
            deleteButton.addTarget(self, action: #selector(deleteSelectedNotes), for: .touchUpInside)
            deleteButton.translatesAutoresizingMaskIntoConstraints = false
            notesView.footerView.addSubview(deleteButton)
            NSLayoutConstraint.activate([
                deleteButton.trailingAnchor.constraint(equalTo: notesView.footerView.trailingAnchor, constant: -Margins.medium),
                deleteButton.centerYAnchor.constraint(equalTo: notesView.footerView.centerYAnchor)
            ])
        }
    }
    
    // Удаление выбранных заметок
    @objc private func deleteSelectedNotes() {
        if selectedNotes.isEmpty && !isSearchActive {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: UIElements.cancel, style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: UIElements.deleteAll, style: .destructive, handler: { _ in
                RealmManager.shared.realm.beginWrite()
                RealmManager.shared.realm.deleteAll()
                try! RealmManager.shared.realm.commitWrite()
                self.doneSelecting()
            }))
            present(alert, animated: true, completion: nil)
        } else {
            let notesToDelete = Array(selectedNotes)
            
            // Удаляем заметки из snapshot
            var snapshot = dataSource.snapshot()
            snapshot.deleteItems(notesToDelete)
            dataSource.apply(snapshot, animatingDifferences: true) {
                // Удаляем заметки из Realm
                try! RealmManager.shared.realm.write {
                    RealmManager.shared.realm.delete(notesToDelete)
                }
                self.selectedNotes.removeAll()
                self.updateFooterLabel()
                
                self.doneSelecting()
            }
        }
    }
    
    // MARK: - Navigation
    
    // Метод для открытия экрана новой заметки
    func openNewNoteScreen(with note: Note) {
        let noteDetailController = NoteDetailViewController(with: note, delegate: self)
        navigationController?.pushViewController(noteDetailController, animated: true)
    }
    
    // MARK: - Diffable Data Source Setup
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, Note>(tableView: notesView.tableView) { (tableView, indexPath, note) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier, for: indexPath) as? NoteTableViewCell else {
                fatalError("Unable to dequeue NoteTableViewCell")
            }
            cell.configureCell(with: note)
            return cell
        }
    }
    
    func updateSnapshot(animatingDifferences: Bool = true) {
        DispatchQueue.main.async {
            guard let notes = self.notes else { return }
            let notesToShow = self.isSearchActive ? Array(self.filteredNotes.map { $0 }) : Array(notes.map { $0 })
            var snapshot = NSDiffableDataSourceSnapshot<Int, Note>()
            snapshot.appendSections([0])
            snapshot.appendItems(notesToShow)
            self.dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        }
    }
    
    func updateExistingSnapshot(for note: Note, deleted: Bool) {
        var snapshot = dataSource.snapshot()
        if deleted {
            snapshot.deleteItems([note])
        } else {
            if snapshot.itemIdentifiers.contains(note) {
                snapshot.reloadItems([note])
            } else {
                snapshot.appendItems([note])
            }
        }
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }

}
