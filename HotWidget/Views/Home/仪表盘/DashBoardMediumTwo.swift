//
//  DashBoardMediumTwo.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/21.
//

import SwiftUI
import SwiftUITools

struct DashBoardMediumTwo: View {
    @ObservedObject var model: WidgetModel
    var batteryProgress: Double { Double(getBatteryUsage())}
    var storageUsageProgress: Double { (try? getStorageUsed()) ?? 0.0}
    var humidity: Double {
        if var humidity = Store.shared.realTimeForcasting?.humidity.cgFloatValue() {
            humidity = humidity/100.0
            return humidity
        }
        return 0.88
    }
    var temperature: String { Store.shared.realTimeForcasting?.temperature ?? "3"}
    var runningDistance: Double = AppData.shared.runningDistance
    
    let inset: CGFloat = 5.0/60.0
    let start: CGFloat = 2.5/60.0
    let long: CGFloat = 10.0/60.0
    let date: Date
    
    
    var body: some View {
        FitScreenMin(reference: 155) { factor, geo in
            ZStack(alignment: .leading) {
                Rectangle()
                    .ifdo(!AppData.activateLink, transform: { view in
                        view.cornerRadius(defaultCornerRadius*factor, corners: .allCorners)
                    })
                    .changeBackgroundColor(model: model, originalColor: Color(hex: "#000000FF"))
                    .changeBorder(model: model)
                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 3*factor) {
                        Text("\(date.day) 周\(date.chineseWeekString)")
                            .minimumScaleFactor(0.2)
                            .changeFont(model: model, originalFont: defaultFont, fontSize: 10*factor)
                            .changeTextColor(model: model, originalColor: .white)
                        Text("农历\(date.chineseMonthString) \(date.chineseDayString)")
                            .minimumScaleFactor(0.2)
                            .changeFont(model: model, originalFont: defaultFont, fontSize: 8*factor)
                            .changeTextColor(model: model, originalColor: Color(hex: "#A7A7A7FF")!)
                        Text("\(date.hour)" + ":" + date.minuteString)
                            .changeFont(model: model, originalFont: defaultFont, fontSize: 33*factor)
                            .changeTextColor(model: model, originalColor: .white)
                        circleProgressViews(factor: factor)
                            .padding(.top, 10*factor)
                    }
                    .padding(.leading, 20*factor)
                }
            }
            .clickToDetailView(model: model)
        }
    }
    
    private func circleProgressViews(factor: CGFloat) -> some View {
        HStack(spacing: 30*factor) {
            let storageUsage = String(format: "%.0f", storageUsageProgress*100)+"%"
            CircleProgressWithImageAndText(model: model, lineWidth: 5*factor, progress: 1, text: "\(temperature)℃", fontSize: 10.4*factor, color: Color(hex:"#FF432B4"), progressColors: [Color(hex:"#FF432BFF")!, Color(hex: "#FF8E49FF")!, Color(hex: "#FFDB58FF")!, Color(hex: "#9AFF8FFF")!, Color(hex: "#15E3FFFF")!], image: "temperature", factor: factor, imageWidthHeight: 10.4*factor)
                .frame(width: 33*factor)
            CircleProgressWithImageAndText(model: model, lineWidth: 5*factor, progress: humidity, text: "\(Int(humidity*100))%", fontSize: 10.4*factor, color: Color(hex:"#48FFFA44"), progressColors: [Color(hex:"#1AFEFFFF")! ,Color(hex:"#48FFFAFF")!], image: "dashboardhumidity", factor: factor, imageWidthHeight: 10.4*factor)
                .frame(width: 33*factor)
            CircleProgressWithImageAndText(model: model, lineWidth: 5*factor, progress: batteryProgress, text: "\(Int(batteryProgress*100))%", fontSize: 10.4*factor, color: Color(hex:"#17E84D44"), progressColors: ["#17E84DFF".color!], image: "dashboardbattery", factor: factor, imageWidthHeight: 10.4*factor)
                .frame(width: 33*factor)
            CircleProgressWithImageAndText(model: model, lineWidth: 5*factor, progress: storageUsageProgress, text: storageUsage, fontSize: 10.4*factor, color: Color(hex:"#FF9C3044"), progressColors: [Color(hex:"#FF9C30FF")!], image: "dashboardmemory", factor: factor, imageWidthHeight: 10.4*factor)
                .frame(width: 33*factor)
            CircleProgressWithImageAndText(model: model, lineWidth: 5*factor, progress: 1, text: String(format: "%.0f", runningDistance)+"km", fontSize: 10.4*factor, color: "#309FFF44".color!, progressColors: ["#309FFFFF".color!], image: "runningdistance", factor: factor, imageWidthHeight: 10.4*factor)
                .frame(width: 33*factor)
        }
    }
}

struct DashBoardMediumTwo_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    DashBoardMediumTwo(model: WidgetModel(id: .DashBoardMediumTwo), date: Date())
                        .frame(width: 329, height: 155)
                    Spacer()
                }
                Spacer()
            }
            .background(Color(hex: "#303234FF"))
        }
    }
}

