//
//  WeatherMediumOne.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/6/3.
//

import SwiftUI
import SwiftUITools

struct WeatherMediumOne: View {
    var model: WidgetModel
    var date: Date
    
    var body: some View {
        FitScreenMin(reference: 155) { factor, geo in
            ZStack {
                Rectangle()
                    .ifdo(!AppData.activateLink, transform: { view in
                        view.cornerRadius(defaultCornerRadius*factor)
                    })
                    .changeBackgroundColor(model: model, originalColor: "#54A1FF".color)
                    .changeBorder(model: model)
                
                HStack(spacing: 0) {
                    realForcastView(factor: factor, model: model)
                    Spacer()
                    forcastingView(factor: factor, model: model)
                }
            }
        }
    }
    
    @ViewBuilder func forcastingView(factor: CGFloat, model: WidgetModel) -> some View {
        let fontN = CommonFontNames.PingFangSCRegular.rawValue
        VStack(spacing: 10*factor) {
            ForEach(0..<3, id:\.self) { index in
                HStack(spacing: 20*factor) {
                    VStack(spacing: 5*factor) {
                        Text(Self.dayweek(index: index))
                            .changeFont(model: model, originalFont: fontN, fontSize: 10)
                            .changeTextColor(model: model, originalColor: .white)
                        Text(Self.temperature(index: index))
                            .changeFont(model: model, originalFont: fontN, fontSize: 10)
                            .changeTextColor(model: model, originalColor: .white)
                    }
                    let imageN = WeatherSmallOne.weatherImage(weather: Store.shared.forcastings?[index].dayweather ?? "")
                    Image(imageN).resizable().scaledToFit()
                        .frame(height: 24*factor)
                }
            }
        }
        .padding(.trailing, 20*factor)
    }
    
    static func dayweek(index: Int) -> String {
        if index == 0 {
            return "今日"
        } else if index == 1 {
            return "明日"
        } else if index == 2 {
            let date = Calendar.current.startOfDay(for: Date())
            let dateAfter = Calendar.current.date(byAdding: .day, value: 2, to: date)
            let result = "周" + (dateAfter?.chineseWeekString ?? "")
            return result
        } else if index == 3 {
            let date = Calendar.current.startOfDay(for: Date())
            let dateAfter = Calendar.current.date(byAdding: .day, value: 3, to: date)
            let result = "周" + (dateAfter?.chineseWeekString ?? "")
            return result
        } else {
            return ""
        }
    }
    
    static func temperature(index: Int) -> String {
        let forcast = Store.shared.forcastings?[index]
        let temperature = "\(forcast?.nighttemp ?? "")°/\(forcast?.daytemp ?? "")°"
        return temperature
    }
    
    @ViewBuilder func realForcastView(factor: CGFloat, model: WidgetModel) -> some View {
        let fontN = CommonFontNames.PingFangSCMedium.rawValue
        VStack(spacing: 0) {
            HStack(spacing: 15*factor) {
                Text(Store.shared.location?.district ?? "北京市")
                    .changeFont(model: model, originalFont: fontN, fontSize: 14)
                    .changeTextColor(model: model, originalColor: .white)
                Text(Store.shared.realTimeForcasting?.weather ?? "多云")
                    .changeFont(model: model, originalFont: fontN, fontSize: 14)
                    .changeTextColor(model: model, originalColor: .white)
            }
            
            HStack(spacing: 11*factor) {
                Image(WeatherSmallOne.weatherImage(weather: Store.shared.realTimeForcasting?.weather ?? "")).resizable().scaledToFit()
                    .frame(height: 60*factor)
                Text("\(Store.shared.realTimeForcasting?.temperature ?? "8")℃")
                    .changeFont(model: model, originalFont: fontN, fontSize: 24)
                    .changeTextColor(model: model, originalColor: .white)
            }
            .padding(.top, 15*factor)
            .padding(.bottom, 10*factor)
            
            let realTimeForcast = Store.shared.realTimeForcasting
            HStack(spacing: 15*factor) {
                Text("风\(realTimeForcast?.windpower ?? "0")级")
                    .changeFont(model: model, originalFont: fontN, fontSize: 14)
                    .changeTextColor(model: model, originalColor: .white)
                Text("湿度\(realTimeForcast?.humidity ?? "")%")
                    .changeFont(model: model, originalFont: fontN, fontSize: 14)
                    .changeTextColor(model: model, originalColor: .white)
            }
        }
        .padding(.leading, 20*factor)
    }
}

struct WeatherMediumOne_Previews: PreviewProvider {
    static var previews: some View {
        WeatherMediumOne(model: WidgetModel(id: .WeatherMediumOne), date: Date())
            .frame(width: 329, height: 155)
    }
}
