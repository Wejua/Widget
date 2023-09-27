//
//  WeatherLargeOne.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/6/3.
//

import SwiftUI
import SwiftUITools

struct WeatherLargeOne: View {
    var model: WidgetModel
    var date: Date
    
    var body: some View {
        FitScreenMin(reference: 222) { factor, geo in
            ZStack {
                Rectangle()
                    .ifdo(!AppData.activateLink, transform: { view in
                        view.cornerRadius(defaultCornerRadius*factor)
                    })
                    .changeBackgroundColor(model: model, originalColor: "#54A1FF".color)
                    .changeBorder(model: model)
                
                VStack(spacing: 13*factor) {
                    topView(factor: factor, model: model)
                    
                    VStack(spacing: 3*factor) {
                        Image(WeatherSmallOne.weatherImage(weather: Store.shared.realTimeForcasting?.weather ?? "")).resizable().scaledToFit()
                            .frame(height: 82*factor)
                        Text("8°C")
                            .changeTextColor(model: model, originalColor: .white)
                            .changeFont(model: model, originalFont: CommonFontNames.PingFangSCMedium.rawValue, fontSize: 16.19*factor)
                    }
                    
                    forcastView(factor: factor, model: model)
                }
            }
        }
    }

    @ViewBuilder func forcastView(factor: CGFloat, model: WidgetModel) -> some View {
        HStack(spacing: 25*factor) {
            ForEach(0..<4, id: \.self) { index in
                VStack(spacing: 3*factor) {
                    Text(WeatherMediumOne.dayweek(index: index))
                        .changeTextColor(model: model, originalColor: .white)
                        .changeFont(model: model, originalFont: CommonFontNames.PingFangSCMedium.rawValue, fontSize: 9.45*factor)
                    
                    Image(WeatherSmallOne.weatherImage(weather: Store.shared.forcastings?[index].dayweather ?? "")).resizable().scaledToFit()
                        .frame(height: 22*factor)
                    
                    Text(WeatherMediumOne.temperature(index: index))
                        .changeTextColor(model: model, originalColor: .white)
                        .changeFont(model: model, originalFont: CommonFontNames.PingFangSCMedium.rawValue, fontSize: 8.1*factor)
                }
            }
        }
    }
    
    @ViewBuilder func topView(factor: CGFloat, model: WidgetModel) -> some View {
        let fontN = CommonFontNames.PingFangSCMedium.rawValue
        let realTimeForcast = Store.shared.realTimeForcasting
        HStack(spacing: 7*factor) {
            Text(Store.shared.location?.district ?? "北京市")
            Spacer()
            Text(Store.shared.realTimeForcasting?.weather ?? "多云")
            Text("风\(realTimeForcast?.windpower ?? "0")级")
            Text("湿度\(realTimeForcast?.humidity ?? "")%")
        }
        .changeTextColor(model: model, originalColor: .white)
        .changeFont(model: model, originalFont: fontN, fontSize: 9.45*factor)
        .padding([.leading, .trailing], 20*factor)
    }
}

struct WeatherLargeOne_Previews: PreviewProvider {
    static var previews: some View {
        WeatherLargeOne(model: WidgetModel(id: .WeatherLargeOne), date: Date())
            .frame(width: 329, height: 345)
    }
}
