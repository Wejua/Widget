//
//  WeekView.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/13.
//

import SwiftUI

public struct WeekView: View {
    @ObservedObject var model: WidgetModel
    var oneDateInTheWeek: Date
    var factor: CGFloat
    let calendar = Calendar.current
    let now = Date()
    var startOfMonth: Date {calendar.startOfMonth(for: now)}
    var endOfMonth: Date {calendar.endOfMonth(for: now)}
    var daysSpacing: CGFloat = 10.0
    var textColor: Color = Color(hex: "#111111FF")!
    var circleColor = Color(hex: "#FF482DFF")
    let font: String = "San Francisco"
    
    public var body: some View {
        HStack(spacing: daysSpacing*factor) {
            ForEach(WeekView.weekDates(oneDateInTheWeek: oneDateInTheWeek, calendar: calendar), id: \.self) { date in
                Text("\(calendar.component(.day, from: date))")
                    .minimumScaleFactor(0.2)
                    .frame(width:14*factor, height: 14*factor)
                    .ifdo(startOfMonth > date || date > endOfMonth) { view in
                        view.hidden()
                    }
                    .ifdo(calendar.isDate(date, inSameDayAs: Date())) { view in
                        ZStack {
                            Circle()
                                .frame(width: 14*factor, height: 14*factor)
                                .foregroundColor(circleColor)
                            view
                        }
                    }
                    .changeFont(model: model, originalFont: font, fontSize: 10*factor)
                    .changeTextColor(model: model, originalColor: textColor)
            }
        }
    }
    
    static func weekDates(oneDateInTheWeek: Date, calendar: Calendar) -> [Date] {
        let startOfWeek = calendar.startOfWeek(for: oneDateInTheWeek)
        let weekdayOfFirstDay = calendar.component(.weekday, from: startOfWeek)
        let indexInWeek = weekdayOfFirstDay - 1
        var dates: [Date] = []
        for i in (0...indexInWeek).reversed() {
            if let date = calendar.date(byAdding: .day, value: -i, to: startOfWeek) {
                dates.append(date)
            }
        }
        for i in (1...6-indexInWeek) {
            if let date = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                dates.append(date)
            }
        }
        return dates
    }
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        WeekView(model: WidgetModel(id: .DefaultWidgetSmall, style: WidgetStyle(textColor: nil, border: .border5)), oneDateInTheWeek: Date(), factor: 1)
            .background(.white)
    }
}
