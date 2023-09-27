//
//  CalendarView.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/13.
//

import SwiftUI

extension Date {
    var minute: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        return formatter.string(from: self)
    }
    var hour: String {
        "\(Calendar.current.component(.hour, from: self))"
    }
    var day: String {
        "\(Calendar.current.component(.day, from: self))"
    }
    var week: String {
        let index = Calendar.current.component(.weekday, from: self)
        let weekday = DateFormatter().veryShortWeekdaySymbols[index-1]
        return weekday
    }
    var month: String {
        "\(Calendar.current.component(.month, from: self))"
    }
    var year: String {
        "\(Calendar.current.component(.year, from: self))"
    }
    var chineseDay: String {
        let index = Calendar(identifier: .chinese).component(.day, from: self)
        let day = ChineseFestivals.days[index-1]
        return day
    }
    var chineseWeek: String {
        let index = Calendar(identifier: .chinese).component(.weekday, from: self)
        let weekday = ChineseFestivals.weeks[index-1]
        return weekday
    }
    var chineseMonth: String {
        let index = Calendar(identifier: .chinese).component(.month, from: self)
        let month = ChineseFestivals.months[index-1]
        return month
    }
    var chineseYear: String {
        "\(Calendar(identifier: .chinese).component(.year, from: self))"
    }
}

extension Calendar {
    func startOfMinute(for date: Date) -> Date {
        let components = self.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let date = self.date(from: components)!
        return date
    }
    func endOfDay(for date: Date) -> Date {
        let components = DateComponents(day: 1, second: -1)
        return self.date(byAdding: components, to: startOfDay(for: date))!
    }
    func startOfWeek(for date: Date) -> Date {
        let components = dateComponents([.weekOfYear, .yearForWeekOfYear], from: date)
        return self.date(from: components)!
    }
    func endOfWeek(for date: Date) -> Date {
        let components = DateComponents(day: 7, second: -1)
        return self.date(byAdding: components, to: self.startOfWeek(for: date))!
    }
    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.month, .year], from: date)
        return self.date(from: components)!
    }
    func endOfMonth(for date: Date) -> Date {
        let components = DateComponents(month: 1, second: -1)
        return self.date(byAdding: components, to: self.startOfMonth(for: date))!
    }
    func startOfYear(for date: Date) -> Date {
        let components = dateComponents([.year], from: date)
        return self.date(from: components)!
    }
    func endOfYear(for date: Date) -> Date {
        let components = DateComponents(year: 1, second: -1)
        return self.date(byAdding: components, to: self.startOfYear(for: date))!
    }
}
