//
//  NotesViewController.swift
//  NotesApp1
//
//  Created by Evgeniy Fakhretdinov on 22.06.2024.
//

import UIKit

class NotesViewController: UIViewController {
    
    // MARK: - UI Elements
    
    lazy var notesView: NotesView = NotesView(frame: .zero)
    
    // MARK: - Properties
    
    var notes: [Note] = []
    var filteredNotes: [Note] = []
    var isSearchActive: Bool = false
    
    // Состояние выбора заметок
    var isSelecting: Bool = false
    var selectedNotes: Set<Note> = []
    
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
        
        loadNotes()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Перезапуск поиска, если он активен
        if isSearchActive, let searchText = notesView.searchBar.text {
            searchBar(notesView.searchBar, textDidChange: searchText)
        }
    }
    
    // MARK: - Data Loading
    
    private func loadNotes() {
        // Для примера мы просто создаем одну заметку при первом запуске
        if UserDefaults.standard.isFirstLaunch {
            UserDefaults.standard.isFirstLaunch = false
            let initialNote = createNote(title: "First Note", content: "This is your first note.")
            notes.append(initialNote)
        }
        
        sortNotes(&notes)
        notesView.tableView.reloadData()
        updateFooterLabel()
    }
    
    private func createNote(title: String, content: String) -> Note {
        let newNote = Note(
            id: UUID(),
            title: title,
            content: content,
            created: Date(),
            edited: Date()
        )
        return newNote
    }
    
    // MARK: - Delegates Setup and Buttons Setup
    
    // Настройка делегатов для UITableView и UISearchBar
    private func setupDelegates() {
        notesView.tableView.delegate = self
        notesView.tableView.dataSource = self
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
            let selectNotesAction = UIAction(title: "Select Notes", image: UIImage(systemName: "checkmark.circle")) { _ in
                self.startSelectingNotes()
            }
            let menu = UIMenu(title: "", children: [selectNotesAction])
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: menu)
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
    
    // Сортировка заметок по дате редактирования
    func sortNotes(_ notes: inout [Note]) {
        notes.sort(by: { $0.edited > $1.edited })
    }
    
    // MARK: - Actions
    
    // Метод для добавления новой заметки
    @objc private func addNote() {
        openNewNoteScreen(withTitle: "", andContent: "")
    }
    
    // Начинает режим выбора заметок
    private func startSelectingNotes() {
        isSelecting = true
        notesView.searchBar.isUserInteractionEnabled = false
        if let cancelButton = notesView.searchBar.value(forKey: "cancelButton") as? UIButton {
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
        if let cancelButton = notesView.searchBar.value(forKey: "cancelButton") as? UIButton {
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
            deleteButton.setTitle(selectedNotes.isEmpty && !isSearchActive ? "Delete All" : "Delete", for: .normal)
            deleteButton.addTarget(self, action: #selector(deleteSelectedNotes), for: .touchUpInside)
            deleteButton.translatesAutoresizingMaskIntoConstraints = false
            notesView.footerView.addSubview(deleteButton)
            NSLayoutConstraint.activate([
                deleteButton.trailingAnchor.constraint(equalTo: notesView.footerView.trailingAnchor, constant: -16),
                deleteButton.centerYAnchor.constraint(equalTo: notesView.footerView.centerYAnchor)
            ])
        }
    }
    
    // Удаление выбранных заметок
    @objc private func deleteSelectedNotes() {
        if selectedNotes.isEmpty && !isSearchActive {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete All", style: .destructive, handler: { _ in
                self.notes.removeAll()
                self.filteredNotes.removeAll()
                self.selectedNotes.removeAll()
                self.notesView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                self.doneSelecting()
            }))
            present(alert, animated: true, completion: nil)
        } else {
            // Получаем индексы выбранных заметок
            let indexPaths = selectedNotes.compactMap { note -> IndexPath? in
                if self.isSearchActive, let index = filteredNotes.firstIndex(of: note) {
                    return IndexPath(row: index, section: 0)
                } else if let index = notes.firstIndex(of: note) {
                    return IndexPath(row: index, section: 0)
                }
                return nil
            }
            
            selectedNotes.forEach { note in
                if let index = notes.firstIndex(of: note) {
                    notes.remove(at: index)
                }
                if isSearchActive, let index = filteredNotes.firstIndex(of: note) {
                    filteredNotes.remove(at: index)
                }
            }
            selectedNotes.removeAll()
            
            // Обновляем таблицу
            notesView.tableView.performBatchUpdates({
                notesView.tableView.deleteRows(at: indexPaths, with: .automatic)
            }, completion: { _ in
                self.updateFooterLabel()
                self.doneSelecting()
            })
        }
    }

    // MARK: - Navigation
    
    // Метод для открытия экрана новой заметки
    func openNewNoteScreen(withTitle title: String, andContent content: String) {
        let newNote = createNote(title: title, content: content)
        let noteDetailController = NoteDetailViewController(with: newNote, delegate: self)
        navigationController?.pushViewController(noteDetailController, animated: true)
    }
}
