//
//  UITableViewCell+ReuseIdentifier.swift
//  NotesApp2
//
//  Created by Evgeniy Fakhretdinov on 22.06.2024.
//

import UIKit

// Свойство для получения идентификатора ячейки
extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
