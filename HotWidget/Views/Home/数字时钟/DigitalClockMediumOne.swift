//
//  DigitalClockMediumOne.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/24.
//

import SwiftUI
import SwiftUITools

struct DigitalClockMediumOne: View {
    @ObservedObject var model: WidgetModel
    var date: Date
    
    var body: some View {
        FitScreenMin(reference: 155) { factor, geo in
            ZStack {
                Rectangle()
                    .changeBorder(model: model)
                    .ifdo(!AppData.activateLink, transform: { view in
                        view.cornerRadius(defaultCornerRadius*factor, corners: .allCorners)
                    })
                    .changeBackgroundColor(model: model, originalColor: Color(red: 24/255.0, green: 27/255.0, blue: 40/255.0))
                VStack {
                    VStack(spacing: 0) {
                        Text("\(date.hourString)"+":"+date.minuteString)
                            .changeFont(model: model, originalFont: defaultFont, fontSize: 55*factor)
                            .changeTextColor(model: model, originalColor: .white)
                        Text("\(date.month)" + "月"+"\(date.day)" + "日 周" + date.chineseWeekString)
//                            .padding(.top, 10*factor)
                            .changeFont(model: model, originalFont: defaultFont, fontSize: 12*factor)
                            .changeTextColor(model: model, originalColor: .white)
                        Text("农历" + date.chineseMonthString + date.chineseDayString)
                            .padding(.top, 8*factor)
                            .padding(.bottom, 10*factor)
                            .changeFont(model: model, originalFont: defaultFont, fontSize: 11*factor)
                            .changeTextColor(model: model, originalColor: .white)
                    }
                }
            }
            .clickToDetailView(model: model)
        }
    }
}

struct DigitalClockMediumOne_Previews: PreviewProvider {
    static var previews: some View {
        DigitalClockMediumOne(model: WidgetModel(id: .DigitalClockMediumOne), date: Date())
            .frame(width: 329, height: 155)
    }
}
