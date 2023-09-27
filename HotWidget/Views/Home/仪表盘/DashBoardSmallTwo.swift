//
//  DashBoardSmallTwo.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/21.
//

import SwiftUI
import SwiftUITools

struct DashBoardSmallTwo: View {
    @ObservedObject var model: WidgetModel
    var batteryProgress: Double {Double(getBatteryUsage())}
    var SDUsage: Double {(try? getStorageUsed()) ?? 0.0}
    var humidity: Double {
        if var humidity = Store.shared.realTimeForcasting?.humidity.cgFloatValue() {
            humidity = humidity/100.0
            return humidity
        }
        return 0.88
    }
    var temperature: String { Store.shared.realTimeForcasting?.temperature ?? "3"}
    var runningDistance: Double = AppData.shared.runningDistance
    
    let date: Date
    
    var body: some View {
        FitScreenMin(reference: 155) { factor, geo in
            ZStack {
                Rectangle()
                    .ifdo(!AppData.activateLink, transform: { view in
                        view.cornerRadius(defaultCornerRadius*factor, corners: .allCorners)
                    })
                    .changeBackgroundColor(model: model, originalColor: Color(hex: "#000000FF"))
                    .changeBorder(model: model)
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text("\(date.hour)" + ":" + date.minuteString)
                            .changeFont(model: model, originalFont: defaultFont, fontSize: 33*factor)
                            .changeTextColor(model: model, originalColor: .white)
                        VStack(alignment: .trailing, spacing: 3*factor) {
                            Text("\(date.day) 周\(date.chineseWeekString)")
                                .minimumScaleFactor(0.2)
                                .changeFont(model: model, originalFont: defaultFont, fontSize: 10*factor)
                                .changeTextColor(model: model, originalColor: .white)
                            Text("农历\(date.chineseMonthString)")
                                .minimumScaleFactor(0.2)
                                .changeFont(model: model, originalFont: defaultFont, fontSize: 8*factor)
                                .changeTextColor(model: model, originalColor: Color(hex: "#A7A7A7FF")!)
                            Text("\(date.chineseDayString)")
                                .minimumScaleFactor(0.2)
                                .changeFont(model: model, originalFont: defaultFont, fontSize: 8*factor)
                                .changeTextColor(model: model, originalColor: Color(hex: "#A7A7A7FF")!)
                        }
                        .padding(.leading, 10*factor)
                    }
                    temperatureAndHumidityAndBattery(factor: factor)
                        .padding(.top, 20*factor)
                    storageUsageAndRunningDistance(factor: factor)
                        .padding(.top, 12*factor)
                }
            }
            .clickToDetailView(model: model)
//            .onAppear{
//                getWalkingRunningDistance { distance in
//                    self.runningDistance = distance
//                }
//            }
        }
    }
    
    private func temperatureAndHumidityAndBattery(factor: CGFloat) -> some View {
        HStack(spacing: 20*factor) {
            CircleProgressWithImageAndText(model: model, lineWidth: 3.5*factor, progress: 1, text: "\(temperature)℃", fontSize: 8*factor, color: Color(hex:"#FF432B4"), progressColors: [Color(hex:"#FF432BFF")!, Color(hex: "#FF8E49FF")!, Color(hex: "#FFDB58FF")!, Color(hex: "#9AFF8FFF")!, Color(hex: "#15E3FFFF")!], image: "temperature", factor: factor)
                .frame(width: 26*factor, height: 26*factor)
            CircleProgressWithImageAndText(model: model, lineWidth: 3.5*factor, progress: humidity, text: "\(Int(humidity*100))%", fontSize: 8*factor, color: Color(hex:"#48FFFA44"), progressColors: [Color(hex:"#1AFEFFFF")! ,Color(hex:"#48FFFAFF")!], image: "dashboardhumidity", factor: factor)
                .frame(width: 26*factor, height: 26*factor)
            CircleProgressWithImageAndText(model: model, lineWidth: 3.5*factor, progress: batteryProgress, text: "\(Int(batteryProgress*100))%", fontSize: 8*factor, color: Color(hex:"#17E84D44"), progressColors: [Color(hex:"#17E84DFF")!], image: "dashboardbattery", factor: factor)
                .frame(width: 26*factor, height: 26*factor)
        }
    }
    
    private func storageUsageAndRunningDistance(factor: CGFloat) -> some View {
        HStack(spacing: 20*factor) {
            let storageUsage = String(format: "%.0f", SDUsage*100)+"%"
            CircleProgressWithImageAndText(model: model, lineWidth: 3.5*factor, progress: SDUsage, text: storageUsage, fontSize: 8*factor, color: Color(hex:"#FF9C3044"), progressColors: [Color(hex:"#FF9C30FF")!], image: "dashboardmemory", factor: factor)
                .frame(width: 26*factor, height: 26*factor)
            CircleProgressWithImageAndText(model: model, lineWidth: 3.5*factor, progress: 1, text: String(format: "%.0f", runningDistance)+"km", fontSize: 8*factor, color: Color(hex:"#309FFF44"), progressColors: [Color(hex:"#309FFFFF")!], image: "runningdistance", factor: factor)
                .frame(width: 26*factor, height: 26*factor)
        }
    }
}

struct DashBoardSmallTwo_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    DashBoardSmallTwo(model: WidgetModel(id: .DashBoardSmallTwo), date: Date())
                        .frame(width: 155, height: 155)
                    Spacer()
                }
                Spacer()
            }
            .background(Color(hex: "#303234FF"))
        }
    }
}
