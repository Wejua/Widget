//
//  WeatherSmallOne.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/6/3.
//

import SwiftUI
import SwiftUITools

struct WeatherSmallOne: View {
    @ObservedObject var model: WidgetModel
    
    var body: some View {
        FitScreenMin(reference: 155) { factor, geo in
            ZStack {
                Rectangle()
                    .ifdo(!AppData.activateLink, transform: { view in
                        view.cornerRadius(defaultCornerRadius*factor, corners: .allCorners)
                    })
                    .changeBackgroundColor(model: model, originalColor: "#54A1FF".color!)
                    .changeBorder(model: model)
                
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text(Store.shared.location?.district ?? "北京市")
                            .changeFont(model: model, originalFont: CommonFontNames.PingFangSCMedium.rawValue, fontSize: 14*factor)
                            .changeTextColor(model: model, originalColor: .white)
                        Spacer()
                        Text(Store.shared.realTimeForcasting?.weather ?? "多云")
                            .changeFont(model: model, originalFont: CommonFontNames.PingFangSCMedium.rawValue, fontSize: 14*factor)
                            .changeTextColor(model: model, originalColor: .white)
                    }
                    
                    HStack(spacing: 0) {
                        Image(Self.weatherImage(weather: Store.shared.realTimeForcasting?.weather ?? "")).resizable().scaledToFit()
                            .frame(height: 48*factor)
                        Spacer()
                        Text("\(Store.shared.realTimeForcasting?.temperature ?? "8")℃")
                            .minimumScaleFactor(0.3)
                            .changeFont(model: model, originalFont: CommonFontNames.PingFangSCMedium.rawValue, fontSize: 24)
                            .changeTextColor(model: model, originalColor: .white)
                    }
                    .padding(.top, 5*factor)
                    
                    let todayForcast = Store.shared.forcastings?[0]
                    let todayTemp = "\(todayForcast?.nighttemp ?? "")°/\(todayForcast?.daytemp ?? "")°"
                    let tomorrowForcast = Store.shared.forcastings?[1]
                    let tomorrowTemp = "\(tomorrowForcast?.nighttemp ?? "")°/\(tomorrowForcast?.daytemp ?? "")°"
                    HStack(spacing: 0) {
                        VStack(spacing: 0) {
                            Text("今日")
                                .changeTextColor(model: model, originalColor: .white)
                                .changeFont(model: model, originalFont: CommonFontNames.PingFangSCRegular.rawValue, fontSize: 10)
                            Image(Self.weatherImage(weather: todayForcast?.dayweather ?? "")).resizable().scaledToFit()
                                .frame(height: 24*factor)
                            Text(todayTemp)
                                .changeTextColor(model: model, originalColor: .white)
                                .changeFont(model: model, originalFont: CommonFontNames.PingFangSCRegular.rawValue, fontSize: 10)
                        }
                        Spacer()
                        VStack(spacing: 0) {
                            Text("明日")
                                .changeTextColor(model: model, originalColor: .white)
                                .changeFont(model: model, originalFont: CommonFontNames.PingFangSCRegular.rawValue, fontSize: 10)
                            Image(Self.weatherImage(weather: tomorrowForcast?.dayweather ?? "")).resizable().scaledToFit()
                                .frame(height: 24*factor)
                            Text(tomorrowTemp)
                                .changeTextColor(model: model, originalColor: .white)
                                .changeFont(model: model, originalFont: CommonFontNames.PingFangSCRegular.rawValue, fontSize: 10)
                        }
                    }
                    .padding(.top, 10*factor)
                }
                .padding([.leading, .trailing], 20*factor)
                
            }
            .clickToDetailView(model: model)
        }
    }
    
    static func weatherImage(weather: String) -> String {
        if weather == "晴" {
            return "tianqi_qing"
        }
        else if weather == "少云" {
            return "shaoyun"
        }
        else if weather == "晴间多云" {
            return "qingjianduoyun"
        }
        else if weather == "多云" {
            return "tianqi_duoyun"
        }
        else if weather == "阴" {
            return "tianqi_yintian"
        }
        else if weather == "有风" || weather == "微风" || weather == "和风" || weather ==  "平静" || weather == "清风" {
            return "youfeng"
        }
        else if weather == "烈风" || weather == "强风" || weather == "疾风"  || weather == "大风" || weather == "风暴"  || weather == "狂暴风" || weather == "飓风" || weather == "热带风暴" {
            return "liefeng"
        }
        else if weather == "霾" || weather == "中度霾" || weather == "重度霾" || weather == "严重霾" || weather == "中度霾" {
            return "mai"
        }
        else if weather == "雨" || weather == "小雨" || weather == "中雨" || weather == "大雨" || weather == "暴雨" || weather == "大暴雨" || weather == "特大暴雨" || weather == "毛毛雨" || weather == "细雨" || weather == "小雨-中雨" || weather == "中雨-大雨" || weather == "大雨-暴雨" || weather == "暴雨-大暴雨" || weather == "大暴雨-特大暴雨" || weather == "冻雨" || weather == "极端降雨"{
            return "tianqi_yu"
        }
        else if weather == "雷阵雨伴有冰雹" || weather == "强雷阵雨" || weather == "雷阵雨" {
            return "tianqi_leiyu"
        }
        else if weather == "阵雨" || weather == "强阵雨" {
            return "zhengyu"
        }
        else if weather == "雪" || weather == "阵雪" || weather == "小雪" || weather == "中雪" || weather == "大雪" || weather == "暴雪" || weather == "小雪-中雪" || weather == "中雪-大雪" || weather == "大雪-暴雪" {
            return "xue"
        }
        else if weather == "浮尘" {
            return "fucen"
        }
        else if weather == "扬沙" {
            return "yangsha"
        }
        else if weather == "沙尘暴" || weather == "强沙尘暴" {
            return "shacenbao"
        }
        else if weather == "龙卷风" {
            return "longjuanfeng"
        }
        else if weather == "雾" || weather == "浓雾" || weather == "强浓雾" || weather == "轻雾" || weather == "大雾" || weather == "特强浓雾" {
            return "tianqi_wu"
        }
        else if weather == "雨夹雪" || weather == "雨雪天气" || weather == "阵雨夹雪" {
            return "tianqi_yujiaxue"
        }
        //热，冷，未知
        return "tianqi_duoyun"
    }
}

struct WeatherSmallOne_Previews: PreviewProvider {
    static var previews: some View {
        WeatherSmallOne(model: WidgetModel(id: .WeatherSmallOne))
            .frame(width: 155, height: 155)
    }
}
