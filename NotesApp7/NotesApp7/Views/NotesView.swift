//
//  NotesView.swift
//  NotesApp7
//
//  Created by Evgeniy Fakhretdinov on 22.06.2024.
//

import UIKit

class NotesView: UIView {
    
    // MARK: - UI Elements
    
    // Заголовок для экрана заметок
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Notes"
        label.font = UIFont.boldSystemFont(ofSize: FontSizes.header)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Таблица для отображения списка заметок
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.layer.cornerRadius = 15
        table.clipsToBounds = true
        table.backgroundColor = .white
        table.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.reuseIdentifier)
        return table
    }()
    
    // Метка для отображения количества заметок
    lazy var footerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Кнопка для добавления новой заметки
    lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: UIElements.squareAndPencil), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Вид для нижней панели с меткой и кнопкой
    lazy var footerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Добавляем строку поиска
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.barTintColor = UIColor.systemGray6
        searchBar.backgroundImage = UIImage() // Убираем границу строки поиска
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subview Setup
    
    private func setupSubviews() {
        addSubview(headerLabel)
        addSubview(searchBar)
        addSubview(tableView)
        addSubview(footerView)
        footerView.addSubview(footerLabel)
        footerView.addSubview(addButton)
    }
    
    // MARK: - Layout Setup
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Margins.medium),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margins.medium),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Margins.medium),
            
            searchBar.topAnchor.constraint(equalTo: headerLabel.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margins.small),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Margins.small),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: Margins.small),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margins.medium),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Margins.medium),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            
            footerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: Heights.footer),
            
            footerLabel.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            footerLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            
            addButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -Margins.medium),
            addButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])
    }
}
