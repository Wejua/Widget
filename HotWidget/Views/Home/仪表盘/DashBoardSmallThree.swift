//
//  DashBoardSmallThree.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/21.
//

import SwiftUI
import SwiftUITools

struct DashBoardSmallThree: View {
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
                    HStack(alignment: .firstTextBaseline, spacing: 0) {
                        Text("\(date.month)-\(date.day)" + " " + "周\(date.chineseWeekString)")
                            .changeFont(model: model, originalFont: defaultFont, fontSize: 9*factor)
                            .changeTextColor(model: model, originalColor: .white)
                            .padding(.trailing, 3*factor)
                        Text("\(date.hour):\(date.minute)")
                            .changeFont(model: model, originalFont: defaultFont, fontSize: 34*factor)
                            .changeTextColor(model: model, originalColor: .white)
                    }
                    lineIndicators(factor: factor)
                        .padding(.top, 20*factor)
                }
            }
            .clickToDetailView(model: model)
        }
    }
    
    private func lineIndicators(factor: CGFloat) -> some View {
        HStack(spacing: 0) {
            let storageUsage = String(format: "%.0f", SDUsage*100)+"%"
            LineProgress(model: model, progress: 1.0, factor: factor, text: "\(temperature)℃", color: "#FF432B44".color!, progressColors: ["#FF432BFF".color!, "#FF8E49FF".color!, "#FFDB58FF".color!, "#9AFF8FFF".color!, "#15E3FFFF".color!], imageName: "temperature")
            LineProgress(model: model, progress: SDUsage, factor: factor, text: storageUsage, color: "#FF9C3044".color!, progressColors: ["#FF9C30FF".color!], imageName: "dashboardmemory")
            LineProgress(model: model, progress: humidity, factor: factor, text: "\(Int(humidity*100))%", color: "#24DFDF44".color!, progressColors: ["#24DFDFFF".color!], imageName: "dashboardhumidity")
            LineProgress(model: model, progress: batteryProgress, factor: factor, text: "\(Int(batteryProgress*100))%", color: "#17E84D44".color!, progressColors: ["#17E84DFF".color!], imageName: "dashboardbattery")
            LineProgress(model: model, progress: 1.0, factor: factor, text: String(format: "%.0f", runningDistance)+"km", color: "#309FFF44".color!, progressColors: ["#309FFFFF".color!], imageName: "runningdistance")
        }
    }
}

struct LineProgress: View {
    @ObservedObject var model: WidgetModel
    var progress: Double
    var factor: CGFloat
    var text: String
    var color: Color
    var progressColors: [Color]
    var imageName: String
    var fontSize: CGFloat = 8.0
    var lineWidth: CGFloat = 6.0
    var width: CGFloat = 28.0
    
    var body: some View {
        VStack(spacing: 0) {
            Text(text)
                .changeFont(model: model, originalFont: defaultFont, fontSize: fontSize*factor)
                .changeTextColor(model: model, originalColor: .white)
            ZStack(alignment: .bottom) {
                let lineHeight = lineWidth*7*factor
                Rectangle()
                    .foregroundColor(color)
                    .frame(width: lineWidth*factor, height: lineHeight)
                    .cornerRadius(lineWidth/2.0*factor, corners: .allCorners)
                let ProgressLineHeight = lineHeight*progress
                Rectangle()
                    .frame(width: lineWidth*factor, height: ProgressLineHeight)
                    .cornerRadius(lineWidth/2.0*factor, corners: .allCorners)
                    .foregroundLinearGradient(colors: progressColors, startPoint: .top, endPoint: .bottom)
                    .animation(.easeInOut(duration: 0.5), value: ProgressLineHeight)
            }
            .padding(.top, lineWidth/3.0*factor)
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: lineWidth/3.0*4.0*factor)
                .padding(.top, lineWidth/3.0*2.0*factor)
        }
        .frame(width: width*factor)
    }
}

struct DashBoardSmallThree_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    DashBoardSmallThree(model: WidgetModel(id: .DashBoardSmallThree), date: Date())
                        .frame(width: 150, height: 150)
                    Spacer()
                }
                Spacer()
            }
            .background(Color(hex: "#303234FF"))
        }
    }
}
