//
//  ControlPanelSmallOne.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/6/4.
//

import SwiftUI
import SwiftUITools

struct ControlPanelSmallOne: View {
    var date: Date
    @ObservedObject var model: WidgetModel
    @ObservedObject var netMoniter = NetworkMonitor()
    
    var body: some View {
        FitScreenMin(reference: 155) { factor, geo in
            ZStack {
                Rectangle()
                    .ifdo(!AppData.activateLink, transform: { view in
                        view.cornerRadius(defaultCornerRadius*factor, corners: .allCorners)
                    })
                    .changeBorder(model: model)
                    .changeBackgroundColor(model: model, originalColor: .clear)
                VStack(spacing: 4*factor) {
                    HStack(spacing: 6*factor) {
                        dateView(factor: factor, model: model)
                        capacityView(factor: factor, model: model)
                    }
                    battery(factor: factor, model: model)
                    HStack(spacing: 8*factor) {
                        wifi(factor: factor, model: model)
                        network(factor: factor, model: model)
                    }
                }
            }
        }
    }
    
    @ViewBuilder func dateView(factor: CGFloat, model: WidgetModel) -> some View {
        let fontN = CommonFontNames.PingFangSCRegular.rawValue
        VStack(spacing: 2*factor) {
            Text(String(date.year) + "年" + String(date.month) + "月")
                .changeFont(model: model, originalFont: fontN, fontSize: 8*factor)
            Text(String(date.day))
                .changeFont(model: model, originalFont: CommonFontNames.PingFangSCMedium.rawValue, fontSize: 20*factor)
            Text("周" + date.chineseWeekString)
                .changeFont(model: model, originalFont: fontN, fontSize: 8*factor)
        }
        .changeTextColor(model: model, originalColor: .white)
        .frame(width: 64.5*factor, height: 67*factor)
        .background(secondaryColor)
        .cornerRadius(10*factor)
    }
    
    @ViewBuilder func battery(factor: CGFloat, model: WidgetModel) -> some View {
        let width = 135.0
        let strokeW = 4.0
        let batteryUsage = Double(getBatteryUsage())
        let cornerRadius = 10.0
        RoundedRectangle(cornerRadius: cornerRadius*factor)
            .strokeBorder(style: .init(lineWidth: strokeW*factor))
            .foregroundColor(secondaryColor)
            .frame(width: width*factor, height: 27*factor)
            .overlay(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8*factor)
                    .fill(LinearGradient(colors: buttonColors, startPoint: .leading, endPoint: .trailing))
                    .padding([.leading, .trailing], strokeW*factor)
                    .frame(width: batteryUsage*width*factor, height: 19*factor)
            }
            .overlay(alignment: .leading) {
                Text("电量:\(Int(batteryUsage*100))%")
                    .changeFont(model: model, originalFont: CommonFontNames.PingFangSCMedium.rawValue, fontSize: 8*factor)
                    .changeTextColor(model: model, originalColor: secondaryColor)
                    .padding(.leading, 8*factor)
            }
    }
    
    @ViewBuilder func wifi(factor: CGFloat, model: WidgetModel) -> some View {
        let font = CommonFontNames.PingFangSCMedium.rawValue
        HStack(spacing: 5*factor) {
            Image(netMoniter.isWifiConnected ? "mianban_wifi" : "mianban_wifiOff")
                .resizable().scaledToFit()
                .frame(width: 25*factor, height: 25*factor)
            VStack(spacing: -1*factor) {
                Text("WiFi")
                    .changeFont(model: model, originalFont: font, fontSize: 8*factor)
                    .changeTextColor(model: model, originalColor: .white)
                Text(netMoniter.isWifiConnected ? "On" : "Off")
                    .changeFont(model: model, originalFont: font, fontSize: 8*factor)
                    .changeTextColor(model: model, originalColor: .white)
            }
        }
        .frame(width: 64.5*factor, height: 33*factor)
        .background(secondaryColor)
        .cornerRadius(10*factor)
    }
    
    @ViewBuilder func network(factor: CGFloat, model: WidgetModel) -> some View {
        let font = CommonFontNames.PingFangSCMedium.rawValue
        HStack(spacing: 5*factor) {
            Image(netMoniter.isCellularConnected ? "mianban_network" : "mianban_cellularOff")
                .resizable().scaledToFit()
                .frame(width: 24*factor, height: 25*factor)
            VStack(spacing: -1*factor) {
                Text("蜂窝")
                    .changeFont(model: model, originalFont: font, fontSize: 8*factor)
                    .changeTextColor(model: model, originalColor: .white)
                Text(netMoniter.isCellularConnected ? "On" : "Off")
                    .changeFont(model: model, originalFont: font, fontSize: 8*factor)
                    .changeTextColor(model: model, originalColor: .white)
            }
        }
        .frame(width: 64.5*factor, height: 33*factor)
        .background(secondaryColor)
        .cornerRadius(10*factor)
    }
    
    @ViewBuilder func capacityView(factor: CGFloat, model: WidgetModel) -> some View {
        let fontN = CommonFontNames.PingFangSCMedium.rawValue
        let storage = (try? getStorageUsed()) ?? 0.0
        let totalGB = (try? getTotalCapacity()) ?? 0.0
                    let gb = String(format:"%.2f",(1.0-storage)*totalGB)
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .stroke(captionColor, style: .init(lineWidth: 4*factor))
                Circle()
                    .trim(from: 0, to: storage)
                    .rotation(Angle(degrees: -90))
                    .stroke(LinearGradient(colors: buttonColors, startPoint: .leading, endPoint: .trailing), style: .init(lineWidth: 4*factor, lineCap: .round))
            }
            .overlay(content: {
                Text("存储")
                    .changeTextColor(model: model, originalColor: .white)
                    .changeFont(model: model, originalFont: fontN, fontSize: 9)
            })
            .frame(width: 28*factor, height: 28*factor)
            .padding(.bottom, 4*factor)
            VStack(spacing: -1*factor) {
                Text("空闲容量")
                    .changeTextColor(model: model, originalColor: .white)
                    .changeFont(model: model, originalFont: fontN, fontSize: 8*factor)
                Text("\(gb)GB")
                    .changeTextColor(model: model, originalColor: .white)
                    .changeFont(model: model, originalFont: fontN, fontSize: 8*factor)
            }
        }
        .frame(width: 64.5*factor, height: 67*factor)
        .offset(y: 2*factor)
        .background(secondaryColor)
        .cornerRadius(10*factor)
    }
}

struct ControlPanelSmallOne_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            primaryColor
            
            ControlPanelSmallOne(date: Date(), model: WidgetModel(id: .ControlPanelSmallOne))
                .frame(width: 155, height: 155)
        }
    }
}
