//
//  MonthView.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/13.
//

import SwiftUI

struct MonthView: View {
    @ObservedObject var model: WidgetModel
    var factor: CGFloat
    var dayViewSize = CGSize(width: 14, height: 14)
    var daysSpacing = 10.0
    let now = Date()
    let calendar = Calendar.current
    var startOfMonth: Date {calendar.startOfMonth(for: now)}
    var lineSpacing: CGFloat = 10.0
    var textColor: Color = Color(hex: "#A3A3A3FF")!
    let font: String = "San Francisco"
    
    var body: some View {
        VStack(spacing: daysSpacing*factor) {
            HStack(spacing: daysSpacing*factor) {
                ForEach(ChineseFestivals.weeks, id: \.self) { week in
                    Text(week)
                        .frame(width:dayViewSize.width*factor, height: dayViewSize.height*factor)
                        .changeFont(model: model, originalFont: font, fontSize: 9*factor)
                        .changeTextColor(model: model, originalColor: textColor)
                }
            }
            VStack(spacing: lineSpacing*factor) {
                WeekView(model: model, oneDateInTheWeek: startOfMonth, factor: factor, daysSpacing: daysSpacing)
                WeekView(model: model, oneDateInTheWeek: calendar.date(byAdding: .weekOfMonth, value: 1, to: startOfMonth)!, factor: factor, daysSpacing: daysSpacing)
                WeekView(model: model, oneDateInTheWeek: calendar.date(byAdding: .weekOfMonth, value: 2, to: startOfMonth)!, factor: factor, daysSpacing: daysSpacing)
                WeekView(model: model, oneDateInTheWeek: calendar.date(byAdding: .weekOfMonth, value: 3, to: startOfMonth)!, factor: factor, daysSpacing: daysSpacing)
                WeekView(model: model, oneDateInTheWeek: calendar.date(byAdding: .weekOfMonth, value: 4, to: startOfMonth)!, factor: factor, daysSpacing: daysSpacing)
            }
        }
    }
}

struct MonthView_Previews: PreviewProvider {
    static var previews: some View {
        MonthView(model: WidgetModel(id: .DefaultWidgetSmall, style: WidgetStyle(textColor: "#009999", border: .border6)), factor: 1)
    }
}
