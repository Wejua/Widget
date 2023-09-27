//
//  ControlPanelMediumOne.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/6/4.
//

import SwiftUI
import SwiftUITools
import DeviceKit

struct ControlPanelMediumOne: View {
    var date: Date
    @ObservedObject var model: WidgetModel
    @ObservedObject var netMoniter = NetworkMonitor()
    @ObservedObject var bluetooth = BluetoothManager()
    
    var body: some View {
        FitScreenMin(reference: 155) { factor, geo in
            ZStack {
                Rectangle()
                    .ifdo(!AppData.activateLink, transform: { view in
                        view.cornerRadius(defaultCornerRadius*factor, corners: .allCorners)
                    })
                    .changeBorder(model: model)
                    .changeBackgroundColor(model: model, originalColor: .clear)
                HStack(spacing: 4*factor) {
                    VStack(spacing: 4*factor) {
                        dateView(factor: factor, model: model)
                        capacityView(factor: factor, model: model)
                    }
                    VStack(spacing: 4*factor) {
                        HStack(spacing: 4*factor) {
                            wifi(factor: factor, model: model)
                            time(factor: factor, model: model)
                        }
                        phoneInfo(factor: factor, model: model)
                        HStack(spacing: 4*factor) {
                            deviceDescription(factor: factor, model: model)
                            network(factor: factor, model: model)
                        }
                    }
                    VStack(spacing: 4*factor) {
                        battery(factor: factor, model: model)
                        HStack(spacing: 4*factor) {
                            VStack(spacing: 4*factor) {
                                bluetooth(factor: factor, model: model)
                                brightness(factor: factor, model: model)
                            }
                            systemVersion(factor: factor, model: model)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder func dateView(factor: CGFloat, model: WidgetModel) -> some View {
        let fontN = CommonFontNames.PingFangSCRegular.rawValue
        VStack(spacing: 0*factor) {
            Text(String(date.year) + "年" + String(date.month) + "月")
                .changeFont(model: model, originalFont: fontN, fontSize: 8*factor)
            Text(String(date.day))
                .changeFont(model: model, originalFont: CommonFontNames.PingFangSCMedium.rawValue, fontSize: 24*factor)
            Text("周" + date.chineseWeekString)
                .changeFont(model: model, originalFont: fontN, fontSize: 8*factor)
        }
        .changeTextColor(model: model, originalColor: .white)
        .frame(width: 64*factor, height: 65.5*factor)
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
                    .stroke(captionColor, style: .init(lineWidth: 3*factor))
                Circle()
                    .trim(from: 0, to: storage)
                    .rotation(Angle(degrees: -90))
                    .stroke(LinearGradient(colors: buttonColors, startPoint: .leading, endPoint: .trailing), style: .init(lineWidth: 3*factor, lineCap: .round))
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
        .frame(width: 64*factor, height: 65.5*factor)
        .offset(y: 2*factor)
        .background(secondaryColor)
        .cornerRadius(10*factor)
    }
    
    @ViewBuilder func wifi(factor: CGFloat, model: WidgetModel) -> some View {
        let font = CommonFontNames.PingFangSCMedium.rawValue
        HStack(spacing: 3*factor) {
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
        .frame(width: 54*factor, height: 34*factor)
        .background(secondaryColor)
        .cornerRadius(10*factor)
    }
    
    @ViewBuilder func time(factor: CGFloat, model: WidgetModel) -> some View {
        Text("\(date.hourString):\(date.minuteString)")
            .minimumScaleFactor(0.3)
            .changeTextColor(model: model, originalColor: .white)
            .changeFont(model: model, originalFont: CommonFontNames.PingFangSCMedium.rawValue, fontSize: 22*factor)
            .frame(width: 73*factor, height: 34*factor)
            .background(secondaryColor)
            .cornerRadius(10*factor)
    }
    
    @ViewBuilder func deviceDescription(factor: CGFloat, model: WidgetModel) -> some View {
        Text(Device.current.description)
            .changeFont(model: model, originalFont: CommonFontNames.PingFangSCRegular.rawValue, fontSize: 12*factor)
            .changeTextColor(model: model, originalColor: .white)
            .frame(width: 73*factor, height: 34*factor)
            .background(secondaryColor)
            .cornerRadius(10*factor)
    }
    
    @ViewBuilder func phoneInfo(factor: CGFloat, model: WidgetModel) -> some View {
        VStack(spacing: 2*factor) {
            Text("\(UIDevice.current.name)")
                .changeFont(model: model, originalFont: CommonFontNames.PingFangSCRegular.rawValue, fontSize: 12*factor)
                .changeTextColor(model: model, originalColor: .white)
            HStack(spacing: 4*factor) {
                Image("mianban_apple").resizable().scaledToFill()
                    .frame(width: 20*factor, height: 20*factor)
                Text("\(Device.current.cpu.description)")
                    .changeFont(model: model, originalFont: CommonFontNames.PingFangSCMedium.rawValue, fontSize: 14*factor)
                    .changeTextColor(model: model, originalColor: .white)
            }
        }
        .frame(width: 131*factor, height: 59*factor)
        .background(secondaryColor)
        .cornerRadius(10*factor)
    }
    
    @ViewBuilder func network(factor: CGFloat, model: WidgetModel) -> some View {
        let font = CommonFontNames.PingFangSCMedium.rawValue
        HStack(spacing: 3*factor) {
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
        .frame(width: 54*factor, height: 34*factor)
        .background(secondaryColor)
        .cornerRadius(10*factor)
    }
    
    @ViewBuilder func battery(factor: CGFloat, model: WidgetModel) -> some View {
        let width = 106.0
        let strokeW = 4.0
        let batteryUsage = Double(getBatteryUsage())
        let cornerRadius = 10.0
        RoundedRectangle(cornerRadius: cornerRadius*factor)
            .strokeBorder(style: .init(lineWidth: strokeW*factor))
            .foregroundColor(secondaryColor)
            .frame(width: width*factor, height: 30*factor)
            .overlay(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8*factor)
                    .fill(LinearGradient(colors: buttonColors, startPoint: .leading, endPoint: .trailing))
                    .padding([.leading, .trailing], strokeW*factor)
                    .frame(width: batteryUsage*width*factor, height: 22*factor)
            }
            .overlay(alignment: .leading) {
                Text("电量:\(Int(batteryUsage*100))%")
                    .changeFont(model: model, originalFont: CommonFontNames.PingFangSCMedium.rawValue, fontSize: 8*factor)
                    .changeTextColor(model: model, originalColor: secondaryColor)
                    .padding(.leading, 8*factor)
            }
    }
    
    @ViewBuilder func systemVersion(factor: CGFloat, model: WidgetModel) -> some View {
        let device = Device.current
        VStack(spacing: 3*factor) {
            Image("mianban_shouji").resizable().scaledToFill()
                .frame(width: 43*factor, height: 77*factor)
            Text((device.systemName ?? "") + " " + (device.systemVersion ?? ""))
                .changeTextColor(model: model, originalColor: .white)
                .changeFont(model: model, originalFont: CommonFontNames.PingFangSCMedium.rawValue, fontSize: 8*factor)
        }
        .frame(width: 55*factor, height: 101*factor)
        .background(secondaryColor)
        .cornerRadius(10*factor)
    }
    
    @ViewBuilder func bluetooth(factor: CGFloat, model: WidgetModel) -> some View {
        let imageN = bluetooth.isOn ? "mianban_lanya" : "mianban_bluetoothOff"
        VStack(spacing: 3*factor) {
            Image(imageN)
            Text("蓝牙:\(bluetooth.isOn ? "On" : "Off")")
                .changeTextColor(model: model, originalColor: .white)
                .changeFont(model: model, originalFont: CommonFontNames.PingFangSCMedium.rawValue, fontSize: 8*factor)
        }
        .frame(width: 47*factor, height: 48.5*factor)
        .background(secondaryColor)
        .cornerRadius(10*factor)
    }
    
    @ViewBuilder func brightness(factor: CGFloat, model: WidgetModel) -> some View {
        let imageN = Device.current.screenBrightness > 0 ? "mianban_brightness" : "mianban_brightnessOff"
        VStack(spacing: 3*factor) {
            Image(imageN)
            Text("亮度:\(Device.current.screenBrightness)%")
                .changeTextColor(model: model, originalColor: .white)
                .changeFont(model: model, originalFont: CommonFontNames.PingFangSCMedium.rawValue, fontSize: 8*factor)
        }
        .frame(width: 47*factor, height: 48.5*factor)
        .background(secondaryColor)
        .cornerRadius(10*factor)
    }
}

struct ControlPanelMediumOne_Previews: PreviewProvider {
    static var previews: some View {
        ControlPanelMediumOne(date: Date(), model: WidgetModel(id: .ControlPanelMediumOne))
            .frame(width: 329, height: 155)
            .background(.gray)
    }
}
