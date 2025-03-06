//
//  NoteDetailViewController+UITextViewDelegate.swift
//  NotesApp1
//
//  Created by Evgeniy Fakhretdinov on 24.06.2024.
//

import UIKit

// MARK: - UITextViewDelegate
extension NoteDetailViewController: UITextViewDelegate {
    // Метод, вызываемый при начале редактирования UITextView
    func textViewDidBeginEditing(_ textView: UITextView) {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        // Добавляем кнопку "Done" в конец массива
        navigationItem.rightBarButtonItems?.insert(doneButton, at: 0)
    }
    
    // Метод, вызываемый при завершении редактирования UITextView
    func textViewDidEndEditing(_ textView: UITextView) {
        if let index = navigationItem.rightBarButtonItems?.firstIndex(where: { $0.style == .done }) {
            navigationItem.rightBarButtonItems?.remove(at: index)
        }
    }
    
    // Метод, вызываемый при изменении текста в UITextView
    func textViewDidChange(_ textView: UITextView) {
        isNoteModified = true
        
        guard let text = textView.text, !text.isEmpty else {
            return
        }
        
        let selectedRange = textView.selectedRange // Сохранение текущей позиции курсора
        
        let attributedText = NSMutableAttributedString(string: text)
        
        // Найти первую строку, включая случаи, когда нет новой строки
        if let rangeOfFirstLine = text.range(of: "^.*?(?:\n|$)", options: .regularExpression) {
            let nsRange = NSRange(rangeOfFirstLine, in: text)
            
            // Установить жирный шрифт и больший размер шрифта для первой строки
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 20) // Увеличьте размер шрифта здесь
            ]
            attributedText.addAttributes(titleAttributes, range: nsRange)
            
            // Установить обычный шрифт для остального текста
            if nsRange.upperBound < text.utf16.count {
                let restRange = NSRange(nsRange.upperBound..<text.utf16.count)
                attributedText.addAttributes([.font: UIFont.systemFont(ofSize: 16)], range: restRange)
            }
        }
        
        // Применить атрибутированный текст только в случае изменений
        if textView.attributedText != attributedText {
            textView.attributedText = attributedText
            textView.selectedRange = selectedRange // Восстановление позиции курсора
        }
    }
    
}

