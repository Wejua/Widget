//
//  CalendarLargeOne.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/13.
//

import SwiftUI
import WidgetKit
import SwiftUITools

struct CalendarLargeOne: View {
    @ObservedObject var model: WidgetModel
    let now = Date()
    let chineseCalender = Calendar(identifier: .chinese)
    var chineseMonth: Int {chineseCalender.component(.month, from: now)}
    var chineseDay: Int {chineseCalender.component(.day, from: now)}
    var month:Int {Calendar.current.component(.month, from: now)}
    var week: Int {Calendar.current.component(.weekday, from: now)}
    var day: Int {Calendar.current.component(.day, from: now)}
    var titleColor: Color = Color(hex: "#000000FF")!
    var textColor: Color = Color(hex: "#333333FF")!
    var font: String = "San Francisco"
    
    @ViewBuilder func backView(factor: CGFloat, model: WidgetModel) -> some View {
        Rectangle()
            .ifdo(!AppData.activateLink, transform: { view in
                view.cornerRadius(defaultCornerRadius*factor, corners: .allCorners)
            })
            .changeBorder(model: model)
    }

    var body: some View {
        FitScreen(referencedWidth: 222.0) { factor in
            ZStack {
                if model.id == .CalendarLargeOne {
                    backView(factor: factor, model: model)
                        .changeBackgroundColor(model: model, originalColor: .white)
                } else if model.id == .CalendarLargeTwo {
                    backView(factor: factor, model: model)
                        .changeBackgroundColor(model: model, image: Image("calenderbackgroundLarge"))
                }
                
                VStack(spacing: 5*factor) {
                    HStack(alignment: .lastTextBaseline, spacing: 0) {
                        Text("\(day)")
                            .minimumScaleFactor(0.2)
                            .bold()
                            .changeFont(model: model, originalFont: font, fontSize: 50*factor)
                            .changeTextColor(model: model, originalColor: titleColor)
                        if model.id == .CalendarLargeOne {
                            VStack(alignment: .trailing, spacing: 0) {
                                Text("\(month)月\(day)日 周\(ChineseFestivals.weeks[week-1])")
                                    .minimumScaleFactor(0.2)
                                    .bold()
                                    .changeFont(model: model, originalFont: font, fontSize: 13*factor)
                                    .changeTextColor(model: model, originalColor: textColor)
                                Text("农历\(ChineseFestivals.months[chineseMonth-1])\(ChineseFestivals.days[chineseDay-1])")
                                    .minimumScaleFactor(0.2)
                                    .changeFont(model: model, originalFont: font, fontSize: 10*factor)
                                    .padding(.top, 6*factor)
                                    .changeTextColor(model: model, originalColor: textColor)
                            }
                            .padding(.leading, 50*factor)
                        } else if  model.id == .CalendarLargeTwo {
                            Spacer()
                            VStack(alignment: .trailing, spacing: 0*factor) {
                                Text(String(format: "%d", now.year))
                                    .minimumScaleFactor(0.2)
                                    .changeFont(model: model, originalFont: CommonFontNames.HelveticaBold.rawValue, fontSize: 14*factor)
                                    .changeTextColor(model: model, originalColor: "#FFA01B".color!)
                                Text(now.monthString)
                                    .minimumScaleFactor(0.2)
                                    .changeFont(model: model, originalFont: CommonFontNames.HelveticaBold.rawValue, fontSize: 18*factor)
                                    .changeTextColor(model: model, originalColor: "#8B5528".color!)
                            }
                            .padding(.trailing, 10*factor)
                        }
                    }
                    .frame(width: 186*factor)
                    MonthView(model: model, factor: factor, daysSpacing: 13)
                }
                .padding(15*factor)
            }
            .changeLink(linkUrl: URL(string: widgetClickScheme + "?id=\(model.id)")!)
        }
    }
}

struct CalendarLargeOne_Previews: PreviewProvider {
    static var previews: some View {
        let model = WidgetModel(id: .CalendarLargeTwo)
//        CalendarLargeOne(model: model)
//            .environmentObject(model)
//            .frame(width: 55, height: 55)
        
        CalendarLargeOne(model: model)
//            .environmentObject(model)
            .frame(width: 329, height: 345)
//            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
