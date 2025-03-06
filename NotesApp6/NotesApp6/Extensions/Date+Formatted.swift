//
//  Date+Formatted.swift
//  NotesApp6
//
//  Created by Evgeniy Fakhretdinov on 24.06.2024.
//

import Foundation

extension Date {
    // Метод для форматирования даты в строку
    func formatted() -> String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        
        if calendar.isDateInToday(self) {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: self)
        } else if calendar.isDateInYesterday(self) {
            return "Yesterday"
        } else if calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear) {
            let weekDay = calendar.component(.weekday, from: self)
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.weekdaySymbols[weekDay - 1]
        } else {
            dateFormatter.dateFormat = "dd.MM.yy"
            return dateFormatter.string(from: self)
        }
    }
}
