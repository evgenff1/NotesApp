//
//  NoteDetailView.swift
//  NotesApp7
//
//  Created by Evgeniy Fakhretdinov on 23.06.2024.
//

import UIKit

class NoteDetailView: UIView {
    
    // MARK: - UI Elements
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: FontSizes.body)
        return textView
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Margins.medium),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Margins.medium),
            textView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
