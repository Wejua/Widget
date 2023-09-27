//
//  CalendarSmallTwo.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/12.
//

import SwiftUI
import SwiftUITools

struct CalendarSmallTwo: View {
    @ObservedObject var model: WidgetModel
    
    var body: some View {
        let calender = Calendar(identifier: .chinese)
        let chineseMonth = calender.component(.month, from: Date())
        let chineseDay = calender.component(.day, from: Date())
        
        let month = Calendar.current.component(.month, from: Date())
        let week = Calendar.current.component(.weekday, from: Date())
        let day = Calendar.current.component(.day, from: Date())
        
        let font: String = "San Francisco"
        let backgroundColor: Color = Color(hex: "#FFFFFFFF")!
        let dayColor: Color = Color(hex: "#000000FF")!
        let textColor: Color = Color(hex: "#333333FF")!
        
        FitScreen(referencedWidth: 155) {factor in
            ZStack {
                Rectangle()
                    .ifdo(!AppData.activateLink, transform: { view in
                        view.cornerRadius(defaultCornerRadius*factor, corners: .allCorners)
                    })
                    .changeBorder(model: model)
                    .changeBackgroundColor(model: model, originalColor: backgroundColor)
                
                VStack(spacing: 0) {
                    Text("\(day)")
                        .bold()
                        .minimumScaleFactor(0.2)
                        .changeFont(model: model, originalFont: font, fontSize: 57.6*factor)
                        .changeTextColor(model: model, originalColor: dayColor)
                    
                    Text("\(month)月\(day)日 周\(ChineseFestivals.weeks[week-1])")
                        .minimumScaleFactor(0.2)
                        .padding(.top, 9*factor)
                        .bold()
                        .changeFont(model: model, originalFont: font, fontSize: 14.4*factor)
                        .changeTextColor(model: model, originalColor: textColor)
                    
                    Text("农历\(ChineseFestivals.months[chineseMonth-1])\(ChineseFestivals.days[chineseDay-1])")
                        .minimumScaleFactor(0.2)
                        .padding(.top, 7*factor)
                        .changeFont(model: model, originalFont: font, fontSize: 12*factor)
                        .changeTextColor(model: model, originalColor: textColor)
                }
            }
            .clickToDetailView(model: model)
        }
    }
}

struct CalendarSmallTwo_Previews: PreviewProvider {
    static let style = WidgetStyle(backgroud: "#998833", textFont: CommonFontNames.HelveticaLight.rawValue, textColor: "#008800", border: .border1, biaoPanYangShi: nil, adcCode: nil)
    @StateObject static var model = WidgetModel(id:.CalendarSmallTwo, style: style)
    static var previews: some View {
        CalendarSmallTwo(model: model)
            .environmentObject(model)
            .frame(width: 355, height: 355)
    }
}
