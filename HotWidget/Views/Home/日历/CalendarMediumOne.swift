//
//  CalendarMediumOne.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/12.
//

import SwiftUI
import WidgetKit
import SwiftUITools

struct CalendarMediumOne: View {
    @ObservedObject var model: WidgetModel
    let now = Date()
    let calendar = Calendar.current
    let chineseCalender = Calendar(identifier: .chinese)
    var chineseMonth: Int {chineseCalender.component(.month, from: now)}
    var chineseDay: Int {chineseCalender.component(.day, from: now)}
    
    var month:Int {Calendar.current.component(.month, from: now)}
    var week: Int {Calendar.current.component(.weekday, from: now)}
    var day: Int {Calendar.current.component(.day, from: now)}
    
    let backgroundColor: Color = Color(hex: "#FFFFFFFF")!
    let dayColor: Color = Color(hex: "#000000FF")!
    let textColor: Color = Color(hex: "#333333FF")!
    let font: String = "San Francisco"
    
    var body: some View {
        FitScreen(referencedWidth: 329) {factor in
            ZStack {
                Rectangle()
                    .ifdo(!AppData.activateLink, transform: { view in
                        view.cornerRadius(defaultCornerRadius*factor, corners: .allCorners)
                    })
                    .ifdo(model.id == .CalendarMediumTwo, transform: { view in
                        view.changeBackgroundColor(model: model, image: Image("calenderbackgroundmedium"))
                    })
                    .ifdo(model.id == .CalendarMediumOne, transform: { view in
                        view.changeBackgroundColor(model: model, originalColor: backgroundColor)
                    })
                    .changeBorder(model: model)
                HStack(spacing: 25*factor) {
                    VStack(spacing: 0) {
                        if model.id == .CalendarMediumOne {
                            Text("\(month)月\(day)日 周\(ChineseFestivals.weeks[week-1])")
                                .minimumScaleFactor(0.2)
                                .bold()
                                .padding(.bottom, 7*factor)
                                .padding(.top, 28*factor)
                                .changeFont(model: model, originalFont: font, fontSize: 14.4*factor)
                                .changeTextColor(model: model, originalColor: textColor)
                            Text("农历\(ChineseFestivals.months[chineseMonth-1])\(ChineseFestivals.days[chineseDay-1])")
                                .minimumScaleFactor(0.2)
                                .padding(.bottom, 9*factor)
                                .changeFont(model: model, originalFont: font, fontSize: 12*factor)
                                .changeTextColor(model: model, originalColor: textColor)
                        }
                        Text("\(day)")
                            .minimumScaleFactor(0.2)
                            .bold()
                            .changeFont(model: model, originalFont: font, fontSize: 57.6*factor)
                            .changeTextColor(model: model, originalColor: dayColor)
                        if model.id == .CalendarMediumTwo {
                            HStack(spacing: 2*factor) {
                                Text("\(now.weekShortString)")
                                    .textSett(color: "#82592F".color!, FName: .HelveticaBold, Fsize: 14*factor, lineLi: 1)
                                Text("\(now.monthString)")
                                    .textSett(color: "#82592F".color!, FName: .PingFangSCMedium, Fsize: 16*factor, lineLi: 1)
                            }
                        }
                    }
                    MonthView(model: model, factor: factor)
                }
            }
            .clickToDetailView(model: model)
        }
    }
}

struct CalendarMediumOne_Previews: PreviewProvider {
    static var previews: some View {
        CalendarMediumOne(model: WidgetModel(id:.CalendarMediumTwo, style: WidgetStyle(textColor: "#330000", border: .border2)))
//            .frame(width: 100, height: 100/329*155)
//            .previewContext(WidgetPreviewContext(family: .systemMedium))
        
        
//            CalendarMediumOne(model: WidgetModel(family: "中"))
                .frame(width: 329, height: 155)
    }
}
