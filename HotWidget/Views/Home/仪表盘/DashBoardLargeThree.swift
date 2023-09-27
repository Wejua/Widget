//
//  DashBoardLargeThree.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/21.
//

import SwiftUI
import SwiftUITools

struct DashBoardLargeThree: View {
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
        FitScreenMin(reference: 222) { factor, geo in
            ZStack {
                Rectangle()
                    .ifdo(!AppData.activateLink, transform: { view in
                        view.cornerRadius(defaultCornerRadius*factor, corners: .allCorners)
                    })
                    .changeBackgroundColor(model: model, originalColor: Color(hex: "#000000FF"))
                    .changeBorder(model: model)
                VStack {
                    HStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 0*factor) {
                            Text("\(date.day) 周\(date.chineseWeekString)")
                                .minimumScaleFactor(0.2)
                                .changeFont(model: model, originalFont: defaultFont, fontSize: 10*factor)
                                .changeTextColor(model: model, originalColor: .white)
                                .padding(.leading, 5*factor)
                            Text("农历\(date.chineseMonthString) \(date.chineseDayString)")
                                .minimumScaleFactor(0.2)
                                .changeFont(model: model, originalFont: defaultFont, fontSize: 10*factor)
                                .changeTextColor(model: model, originalColor: Color(hex: "#A7A7A7FF")!)
                                .padding(.leading, 5*factor)
                        }
                        Text("\(date.hour):\(date.minute)")
                            .changeFont(model: model, originalFont: defaultFont, fontSize: 46*factor)
                            .changeTextColor(model: model, originalColor: .white)
                            .minimumScaleFactor(0.2)
                            .padding(.leading, 5*factor)
                    }
                    lineIndicators(factor: factor, fontSize: 11.5, lineWidth: 8, width: 39)
                        .padding(.top, 10*factor)
                        .padding(.bottom, 10*factor)
                }
            }
            .clickToDetailView(model: model)
        }
    }
    
    private func lineIndicators(factor: CGFloat, fontSize: CGFloat, lineWidth: CGFloat, width: CGFloat) -> some View {
        HStack(spacing: 0) {
            let storageUsage = String(format: "%.0f", SDUsage*100)+"%"
            let runningDistance = String(format: "%.0f", runningDistance)+"km"
            LineProgress(model: model, progress: 1.0, factor: factor, text: "\(temperature)℃", color: "#FF432B44".color!, progressColors: ["#FF432BFF".color!, "#FF8E49FF".color!, "#FFDB58FF".color!, "#9AFF8FFF".color!, "#15E3FFFF".color!], imageName: "temperature", fontSize: fontSize, lineWidth: lineWidth, width: width)
            LineProgress(model: model, progress: SDUsage, factor: factor, text: storageUsage, color: "#FF9C3044".color!, progressColors: ["#FF9C30FF".color!], imageName: "dashboardmemory", fontSize: fontSize, lineWidth: lineWidth, width: width)
            LineProgress(model: model, progress: humidity, factor: factor, text: "\(Int(humidity*100))%", color: "#24DFDF44".color!, progressColors: ["#24DFDFFF".color!], imageName: "dashboardhumidity", fontSize: fontSize, lineWidth: lineWidth, width: width)
            LineProgress(model: model, progress: batteryProgress, factor: factor, text: "\(Int(batteryProgress*100))%", color: "#17E84D44".color!, progressColors: ["#17E84DFF".color!], imageName: "dashboardbattery", fontSize: fontSize, lineWidth: lineWidth, width: width)
            LineProgress(model: model, progress: 1.0, factor: factor, text: runningDistance, color: "#309FFF44".color!, progressColors: ["#309FFFFF".color!], imageName: "runningdistance", fontSize: fontSize, lineWidth: lineWidth, width: width)
        }
    }
}

struct DashBoardLargeThree_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    DashBoardLargeThree(model: WidgetModel(id: .DashBoardLargeThree), date: Date())
                        .frame(width: 329/1.0, height: 345/1.0)
                    Spacer()
                }
                Spacer()
            }
            .background(Color(hex: "#303234FF"))
        }
    }
}
