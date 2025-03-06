//
//  NotesViewController.swift
//  NotesApp3
//
//  Created by Evgeniy Fakhretdinov on 22.06.2024.
//

import UIKit
import CoreData

class NotesViewController: UIViewController {
    
    // MARK: - UI Elements
    
    lazy var notesView: NotesView = NotesView(frame: .zero)
    
    // MARK: - Properties
    
    var fetchedResultsController: NSFetchedResultsController<Note>!
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
        
        // Настраиваем навигационную панель и DataSource
        setupNavigationBar()
        
        setupFetchedResultsController()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Перезапуск поиска, если он активен
        if isSearchActive, let searchText = notesView.searchBar.text {
            searchBar(notesView.searchBar, textDidChange: searchText)
        }
    }
    
    // MARK: - FetchedResultsController Initialization
    
    private func setupFetchedResultsController() {
        
        // Проверка, первый ли это запуск приложения
        if UserDefaults.standard.isFirstLaunch {
            // Установить значение в UserDefaults, чтобы отметить, что первый запуск был произведен
            UserDefaults.standard.isFirstLaunch = false

            // Создание одной заметки при первом запуске
            let initialNote = CoreDataManager.shared.createNote(title: "First Note", content: "This is your first note.")
            CoreDataManager.shared.saveNote(initialNote)
        }
        
        // Настройка fetch-запроса
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "edited", ascending: false)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        performFetchAndUpdateTableView()
    }
    
    // Выполняет fetch и обновляет DataSource
    func performFetchAndUpdateTableView() {
        do {
            try fetchedResultsController.performFetch()
            notesView.tableView.reloadData()
            updateFooterLabel()
        } catch {
            print("Failed to fetch notes: \(error)")
        }
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
        let count = fetchedResultsController.fetchedObjects?.count ?? 0
        if isSearchActive {
            notesView.footerLabel.text = count > 0 ? "\(count) Found" : "None Found"
        } else {
            notesView.footerLabel.text = "\(count) Notes"
        }
    }
    
    // MARK: - Helper Methods
    
    // Функция для создания даты
    private func createDate(daysAgo: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date()
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
            updateFooterLabel()
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
                guard let notes = self.fetchedResultsController.fetchedObjects else { return }
                for note in notes {
                    CoreDataManager.shared.context.delete(note)
                }
                CoreDataManager.shared.saveContext()
                self.selectedNotes.removeAll()
                self.doneSelecting()
            }))
            present(alert, animated: true, completion: nil)
        } else {
            // Удаляем выбранные заметки из базы данных
            selectedNotes.forEach { CoreDataManager.shared.deleteNote($0) }
            CoreDataManager.shared.saveContext()
            selectedNotes.removeAll()
            updateFooterLabel()
            doneSelecting()
        }
    }

    // MARK: - Navigation
    
    // Метод для открытия экрана новой заметки
    func openNewNoteScreen(withTitle title: String, andContent content: String) {
        let newNote = CoreDataManager.shared.createNote(title: title, content: content)
        let noteDetailController = NoteDetailViewController(with: newNote, delegate: self)
        navigationController?.pushViewController(noteDetailController, animated: true)
    }
}
