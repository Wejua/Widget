//
//  CalendarSmallOne.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/2/24.
//

import SwiftUI
import WidgetKit
import SwiftUITools

struct CalendarSmallOne: View {
    @StateObject var model: WidgetModel
    
    private var week: String {
        let index = Calendar.current.component(.weekday, from: Date()) - 1
        return DateFormatter().shortStandaloneWeekdaySymbols[index].uppercased()
    }
    
    let dayColor: Color = Color(hex: "#442506FF")!
    let textColor: Color = Color(hex: "#82592F")!
    let backgroundImage: Image = Image("Calendar_small_lunar")
    
    var body: some View {
        FitScreen(referencedWidth: 155) { factor in
            ZStack {
                Rectangle()
                    .ifdo(!AppData.activateLink, transform: { view in
                        view.cornerRadius(defaultCornerRadius*factor, corners: .allCorners)
                    })
                    .changeBackgroundColor(model: model, image: backgroundImage)
                    .changeBorder(model: model)
                
                VStack(alignment: .center) {
                    Text("\(Calendar.current.component(.day, from: Date()))")
                        .minimumScaleFactor(0.2)
                        .changeTextColor(model: model, originalColor: dayColor)
                        .changeFont(model: model, originalFont: defaultFont, fontSize: 66*factor)
                    
                    Text("\(week)")
                        .minimumScaleFactor(0.2)
                        .changeTextColor(model: model, originalColor: textColor)
                        .changeFont(model: model, originalFont: defaultFont, fontSize: 26*factor)
                }
            }
            .clickToDetailView(model: model)
        }
    }
}

struct CalendarSmallOne_Previews: PreviewProvider {
    
    @StateObject static var model = {
        let mo = WidgetModel(id: .CalendarSmallOne);
        mo.style.textColor = "#442506FF"
//        mo.style.background = "#00ffff"
//        mo.style.border = "#662506"
        return mo
    }()
    
    static var previews: some View {
        CalendarSmallOne(model: model)
            .environmentObject(model)
            .frame(width: 155, height: 155)
    }
}
