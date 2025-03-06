//
//  NoteDetailViewController.swift
//  NotesApp4
//
//  Created by Evgeniy Fakhretdinov on 23.06.2024.
//

import UIKit

class NoteDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private weak var delegate: NoteDetailControllerDelegate?
    
    //Детальный экран полностью завязан на модели заметки, если модели нет, нет смысла отображать детальный экран, можно зафорсить
    private var currentNote: Note!
    
    var isNoteModified = false
    private var isDeleted = false
    
    private lazy var noteDetailView = NoteDetailView()
    
    // MARK: - Initializers
    
    init(with note: Note, delegate: NoteDetailControllerDelegate?) {
        super.init(nibName: nil, bundle: nil)
        
        self.currentNote = note
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    // Метод для загрузки представления
    override func loadView() {
        view = noteDetailView
    }
    
    // Метод, вызываемый после загрузки представления
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupNavigationBar()
        setupTextViewDelegate()
        // Установка текста с атрибутами
        setTextViewText()
    }
    
    // Метод, вызываемый после появления представления
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if currentNote.title?.isEmpty ?? true && currentNote.content?.isEmpty ?? true {
            noteDetailView.textView.becomeFirstResponder()
            let startPosition = noteDetailView.textView.beginningOfDocument
            noteDetailView.textView.selectedTextRange = noteDetailView.textView.textRange(from: startPosition, to: startPosition)
        }
    }
    
    // Метод, вызываемый перед исчезновением представления
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isDeleted {
            return
        }
        
        let fullText = noteDetailView.textView.text ?? ""
        let lines = fullText.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: false)
        let title = lines.first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let content = lines.count > 1 ? lines[1].trimmingCharacters(in: .whitespacesAndNewlines) : ""
        
        // Если заметка была пустая изначально и не была изменена
        if !isNoteModified && currentNote.title?.isEmpty ?? true && currentNote.content?.isEmpty ?? true && title.isEmpty && content.isEmpty {
            CoreDataManager.shared.context.delete(currentNote)
            return
        }
        
        if !isNoteModified && (title == currentNote.title && content == currentNote.content) {
            return
        }
        
        if title.isEmpty && content.isEmpty {
            delegate?.dataUpdated(for: currentNote, deleted: true)
        } else {
            currentNote.title = title
            currentNote.content = content
            currentNote.edited = Date()
            delegate?.dataUpdated(for: currentNote, deleted: false)
        }
    }
    
    // MARK: - Helper Methods
    // Установка делегата для UITextView
    private func setupTextViewDelegate() {
        noteDetailView.textView.delegate = self
    }
    
    // Устанавливаем текст для UITextView с форматированием
    private func setTextViewText() {
        let attributedText = NSMutableAttributedString()
        
        // Добавляем заголовок жирным шрифтом и большего размера
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 20) // Увеличенный размер шрифта
        ]
        if let title = currentNote.title {
            let titleAttributedString = NSAttributedString(string: title + "\n", attributes: titleAttributes)
            attributedText.append(titleAttributedString)
        }
        
        // Добавляем содержимое обычным шрифтом
        let contentAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16)
        ]
        if let content = currentNote.content {
            let contentAttributedString = NSAttributedString(string: content, attributes: contentAttributes)
            attributedText.append(contentAttributedString)
        }
        
        noteDetailView.textView.attributedText = attributedText
    }
    
    // Настройка навигационной панели
    private func setupNavigationBar() {
        let moreActions = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: nil)
        let shareAction = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAction))
        
        let menu = UIMenu(title: "", children: [
            UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { [weak self] _ in
                self?.deleteNote()
            })
        ])
        
        moreActions.menu = menu
        navigationItem.rightBarButtonItems = [moreActions, shareAction]
    }
    
    // Действие по завершению редактирования заметки
    @objc func doneAction() {
        noteDetailView.textView.resignFirstResponder()
    }
    
    // Действие для кнопки "Share"
    @objc private func shareAction() {
        let currentNoteTitle = currentNote.title ?? ""
        let currentNoteContent = currentNote.content ?? ""
        let shareText = currentNoteTitle + "\n" + currentNoteContent
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    // Удаление заметки
    private func deleteNote() {
        isDeleted = true
        DispatchQueue.main.async {
            self.delegate?.dataUpdated(for: self.currentNote, deleted: true)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
