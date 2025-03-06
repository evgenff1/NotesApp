//
//  NSLayoutConstraint+Priority.swift
//  NotesApp3
//
//  Created by Evgeniy Fakhretdinov on 24.06.2024.
//

import UIKit

extension NSLayoutConstraint {
    func with(priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
