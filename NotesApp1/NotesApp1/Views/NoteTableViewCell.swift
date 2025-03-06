//
//  NoteTableViewCell.swift
//  NotesApp1
//
//  Created by Evgeniy Fakhretdinov on 22.06.2024.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    // Заголовок заметки
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Содержимое заметки
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    // Инициализация ячейки
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    // Конфигурация ячейки с данными заметки
    func configureCell(with note: Note) {
        titleLabel.text = note.title
        contentLabel.text = formatContent(note)
    }
    
    // MARK: - Layout
    
    // Настройка макета ячейки
    private func setupLayout() {
        let mainStackView = UIStackView(arrangedSubviews: [titleLabel, contentLabel])
        mainStackView.axis = .vertical
        mainStackView.spacing = 4
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).with(priority: .defaultHigh),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).with(priority: .defaultHigh),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).with(priority: .defaultHigh),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).with(priority: .defaultHigh),
            
            // Установка констрайнта высоты с более низким приоритетом
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).with(priority: .defaultLow)
        ])
    }
    
    // MARK: - Helper Methods
    
    private func formatContent(_ note: Note) -> String {
        let editedDate = note.edited
        return "\(editedDate.formatted()) \(note.content )"
    }
}
