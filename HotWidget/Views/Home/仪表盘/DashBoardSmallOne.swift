//
//  DashBoardSmallOne.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/20.
//

import SwiftUI
import SwiftUITools

class DashBoardVM: ObservableObject {
    
}

struct DashBoardSmallOne: View {
    @ObservedObject var model: WidgetModel
    @StateObject var vm: DashBoardVM = DashBoardVM()
    var batteryProgress: Double {Double(getBatteryUsage())}
    var lightProgress: Double {Double(getLight())}
    var volumeProgress: Double {Double(getVolume())}
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
    
    
    var backgoundColor = Color(hex: "#000000FF")
    let inset: CGFloat = 5.0/60.0
    let start: CGFloat = 2.5/60.0
    let long: CGFloat = 10.0/60.0
    var hourWidth: CGFloat = 20.0
    var minuteWidth: CGFloat = 37.0
    var date: Date
    var hour: Int {Calendar.current.component(.hour, from: date)}
    var minute: Int {Calendar.current.component(.minute, from: date)}
    var iconSize = 12.0
    var iconPadding = 110.0
    var labelsPadding = 132.0
    
    init(model: WidgetModel, date: Date) {
        self.model = model
        self.date = date
    }
    
    var body: some View {
        FitScreenMin(reference: 155) { factor, geo in
            ZStack {
                Rectangle()
                    .ifdo(!AppData.activateLink, transform: { view in
                        view.cornerRadius(defaultCornerRadius*factor, corners: .allCorners)
                    })
                    .changeBackgroundColor(model: model, originalColor: backgoundColor)
                    .changeBorder(model: model)
                Image("dashboarddial")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(15*factor)
                outsideCircles(factor: factor)
                insideSmallCircles(factor: factor)
                hourAndMinute(factor: factor)
                icons(factor: factor)
                labels(factor: factor)
                runningDistance(factor: factor)
            }
            .clickToDetailView(model: model)
//            .onAppear{
//                getWalkingRunningDistance { distance in
//                    self.runningDistance = distance
//                }
//            }
        }
    }
    
    private func runningDistance(factor: CGFloat) -> some View {
        VStack(spacing: 0*factor) {
            Image("dashboardperson")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 12*factor)
            Text(String(format: "%.0f", runningDistance)+"km")
                .changeFont(model: model, originalFont: defaultFont, fontSize: 8*factor)
                .changeTextColor(model: model, originalColor: .white)
        }
        .padding(.bottom, 70*factor)
    }
    
    private func labels(factor: CGFloat) -> some View {
        ZStack {
            Text("\(Int(lightProgress*100))")
                .padding(.bottom, labelsPadding*factor)
                .changeFont(model: model, originalFont: defaultFont, fontSize: 8*factor)
                .changeTextColor(model: model, originalColor: .white)
            ZStack {
                Text("\(Int(volumeProgress*100))")
                    .rotationEffect(.degrees(90))
//                    .frame(width: 10*factor, height: 10*factor)
                    .changeFont(model: model, originalFont: defaultFont, fontSize: 8*factor)
                    .changeTextColor(model: model, originalColor: .white)
            }
            .padding(.leading, labelsPadding*factor)
            Text("\(Int(batteryProgress*100))%")
                .padding(.top, labelsPadding*factor)
                .changeFont(model: model, originalFont: defaultFont, fontSize: 8*factor)
                .changeTextColor(model: model, originalColor: .white)
        }
        .rotationEffect(.degrees(-4))
    }
    
    private func icons(factor: CGFloat) -> some View {
        ZStack {
            Image("dashboardlight")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: iconSize*factor)
                .padding([.trailing, .bottom], iconPadding*factor)
            Image("dashboardvolume")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: iconSize*factor)
                .padding([.leading, .bottom], iconPadding*factor)
            Image("dashboardbattery")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: iconSize*factor)
                .padding([.top, .leading], iconPadding*factor)
        }
    }
    
    private func hourAndMinute(factor: CGFloat) -> some View {
        ZStack {
            let hourOffsetX = hourWidth*0.5*factor-0.5*factor
            let hourOffsetY = -90.0/58.0*hourWidth*0.5*factor-1.0*factor
            let minuteOffsetX = minuteWidth*0.5*factor-0.2*factor
            let minuteOffsetY = minuteWidth*(118.0/108.0)*0.5*factor+0.5*factor
            let hourDegree = 30.0*Double(hour)+Double(minute)*0.5
            let minuteDegree = 6.0*Double(minute)
            Circle()
                .stroke(.white, style: StrokeStyle(lineWidth: 0.5*factor))
                .frame(width: 5*factor, height: 5*factor)
            Image("clockhour")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: hourWidth*factor)
                .offset(CGSize(width:hourOffsetX , height: hourOffsetY))
                .rotationEffect(.degrees(-30.75))
                .rotationEffect(.degrees(hourDegree))
                .animation(.easeInOut(duration: 0.3), value: hourDegree)
            Image("clockminute")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: minuteWidth*factor)
                .offset(CGSize(width: minuteOffsetX, height: minuteOffsetY))
                .rotationEffect(.degrees(-138))
                .rotationEffect(.degrees(minuteDegree))
                .animation(.easeInOut(duration: 0.3), value: minuteDegree)
        }
    }
    
    private func outsideCircles(factor: CGFloat) -> some View {
        ZStack {
            CircleProgress(start: start, long: long, color: Color(hex: "#17E84D44"), progressColors: [Color(hex: "#17E84DFF")!], lineWith: 5*factor, progress: batteryProgress)
                .padding(12*factor)
            CircleProgress(start: start+(long+inset), long: long, color: Color(hex: "#97979744"), progressColors: [Color(hex: "#979797FF")!], lineWith: 5*factor, progress: 1)
                .padding(12*factor)
            CircleProgress(start: start+(long+inset)*2, long: long, color: Color(hex: "#FF5A0044"), progressColors: [Color(hex: "#FF5A00FF")!], lineWith: 5*factor, progress: lightProgress)
                .padding(12*factor)
            CircleProgress(start: start+(long+inset)*3, long: long, color: Color(hex: "#1979FF44"), progressColors: [Color(hex: "#1979FFFF")!], lineWith: 5*factor, progress: volumeProgress)
                .padding(12*factor)
        }
    }
    
    private func insideSmallCircles(factor: CGFloat) -> some View {
        ZStack {
            let storageUsage = String(format: "%.0f", SDUsage*100)+"%"
            CircleProgressWithImageAndText(model: model, lineWidth: 3.5*factor, progress: 1, text: "\(temperature)℃", fontSize: 8*factor, color: Color(hex:"#FF432B4"), progressColors: [Color(hex:"#FF432BFF")!, Color(hex: "#FF8E49FF")!, Color(hex: "#FFDB58FF")!, Color(hex: "#9AFF8FFF")!, Color(hex: "#15E3FFFF")!], image: "temperature", factor: factor)
                .frame(width: 26*factor, height: 26*factor)
                .offset(CGSize(width: -30*factor, height: 0))
            CircleProgressWithImageAndText(model: model, lineWidth: 3.5*factor, progress: SDUsage, text: storageUsage, fontSize: 8*factor, color: Color(hex:"#FF9C3044"), progressColors: [Color(hex:"#FF9C30FF")!], image: "dashboardmemory", factor: factor)
                .frame(width: 26*factor, height: 26*factor)
                .offset(CGSize(width: 30*factor, height: 0))
            CircleProgressWithImageAndText(model: model, lineWidth: 3.5*factor, progress: humidity, text: "\(Int(humidity*100))%", fontSize: 8*factor, color: Color(hex:"#48FFFA44"), progressColors: [Color(hex:"#1AFEFFFF")! ,Color(hex:"#48FFFAFF")!], image: "dashboardhumidity", factor: factor)
                .frame(width: 26*factor, height: 26*factor)
                .offset(CGSize(width: 0, height: 30*factor))
        }
    }
}

struct CircleProgress: View {
    var start: CGFloat = 2.5/60.0
    var long: CGFloat = 10.0/60.0
    var color: Color? = Color(hex: "#17E84D44")
    var progressColors: [Color] = [Color(hex: "17E84DFF")!]
    var lineWith: CGFloat = 5.0
    var progress: Double

    init(start: CGFloat, long: CGFloat, color: Color? = nil, progressColors: [Color], lineWith: CGFloat, progress: Double) {
        self.start = start
        self.long = long
        self.color = color
        self.progressColors = progressColors
        self.lineWith = lineWith
        self.progress = progress
    }
    
    var body: some View {
        ZStack {
        Circle()
            .trim(from: start, to: start+long)
            .stroke(style: StrokeStyle(lineWidth: lineWith, lineCap: .round, lineJoin: .round))
            .foregroundColor(color)
        Circle()
            .trim(from: start, to: start+long*progress)
            .stroke(style: StrokeStyle(lineWidth: lineWith, lineCap: .round, lineJoin: .round))
            .foregroundLinearGradient(colors: progressColors, startPoint: .leading, endPoint: .trailing)
            .animation(.easeInOut(duration: 0.3), value: progress)
        }
    }
}

struct CircleProgressWithImageAndText: View {
    @ObservedObject var model: WidgetModel
    var lineWidth: CGFloat
    var progress: Double
    var text: String
    var fontSize: CGFloat
    var color: Color?
    var progressColors: [Color]
    var image: String
    var factor: CGFloat
    var imageWidthHeight = 8.0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                CircleProgress(start: 1.0/4.0, long: 3.0/4.0, color:color, progressColors: progressColors, lineWith: lineWidth, progress: progress)
                    .rotationEffect(.degrees(45))
                Text(text)
                    .minimumScaleFactor(0.2)
                    .changeFont(model: model, originalFont: defaultFont, fontSize: fontSize)
                    .changeTextColor(model: model, originalColor: .white)
            }
            .overlay(alignment: .bottom) {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: imageWidthHeight*factor)
                    .offset(CGSize(width: 0, height: imageWidthHeight*factor/2.0))
            }
        }
    }
}

struct DashBoardSmallOne_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                DashBoardSmallOne(model: WidgetModel(id: .DashBoardSmallOne), date: Date())
                    .frame(width: 155, height: 155)
                Spacer()
            }
            Spacer()
        }
        .background(Color(hex: "#303234FF"))
        .ignoresSafeArea()
    }
}
