//
//  ControlPanelLargeOne.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/6/4.
//

import SwiftUI
import SwiftUITools
import DeviceKit

struct ControlPanelLargeOne: View {
    var date: Date
    @ObservedObject var model: WidgetModel
    @ObservedObject var netMoniter = NetworkMonitor()
    @ObservedObject var bluetooth = BluetoothManager()
    
    var body: some View {
        FitScreenMin(reference: 222) { factor, geo in
            ZStack {
                let cornerRadius = !AppData.activateLink ? defaultCornerRadius*factor : 0.0
                RoundedRectangle(cornerRadius: cornerRadius)
                    .changeBackgroundColor(model: model, originalColor: .clear)
                    .changeBorder(model: model)
                let margin = 5*factor
                VStack(spacing: margin) {
                    HStack(spacing: margin) {
                        VStack(spacing: margin) {
                            wifi(factor: factor, model: model)
                            bluetooth(factor: factor, model: model)
                        }
                        VStack(spacing: margin) {
                            network(factor: factor, model: model)
                            brightness(factor: factor, model: model)
                        }
                        VStack(spacing: margin) {
                            battery(factor: factor, model: model)
                            phoneInfo(factor: factor, model: model)
                        }
                    }
                    HStack(spacing: margin) {
                        VStack(spacing: margin) {
                            time(factor: factor, model: model)
                            deviceDescription(factor: factor, model: model)
                        }
                        VStack(spacing: margin) {
                            dateView(factor: factor, model: model)
                            capacityView(factor: factor, model: model)
                        }
                        systemVersion(factor: factor, model: model)
                    }
                }
            }
            .changeLink(linkUrl: URL(string: panelDetalTag)!)
        }
    }
    
    @ViewBuilder func dateView(factor: CGFloat, model: WidgetModel) -> some View {
        let fontN = CommonFontNames.PingFangSCRegular.rawValue
        VStack(spacing: 1*factor) {
            Text(String(date.year) + "年" + String(date.month) + "月")
                .changeFont(model: model, originalFont: fontN, fontSize: 5.4*factor)
            Text(String(date.day))
                .changeFont(model: model, originalFont: CommonFontNames.PingFangSCMedium.rawValue, fontSize: 16.19*factor)
            Text("周" + date.chineseWeekString)
                .changeFont(model: model, originalFont: fontN, fontSize: 5.4*factor)
        }
        .changeTextColor(model: model, originalColor: .white)
        .frame(width: 53.98*factor, height: 48.96*factor)
        .background(secondaryColor)
        .cornerRadius(6.75*factor)
    }
    
    @ViewBuilder func capacityView(factor: CGFloat, model: WidgetModel) -> some View {
        let fontN = CommonFontNames.PingFangSCMedium.rawValue
        let storage = (try? getStorageUsed()) ?? 0.0
        let totalGB = (try? getTotalCapacity()) ?? 0.0
        let idle = String(format:"%.2f",(1.0-storage)*totalGB)
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
                    .changeFont(model: model, originalFont: fontN, fontSize: 6.07*factor)
            })
            .frame(width: 21.59*factor, height: 21.59*factor)
            .padding(.bottom, 2*factor)
            VStack(spacing: -1*factor) {
                Text("空闲容量")
                    .changeTextColor(model: model, originalColor: .white)
                    .changeFont(model: model, originalFont: fontN, fontSize: 5.4*factor)
                Text("\(idle)GB")
                    .changeTextColor(model: model, originalColor: .white)
                    .changeFont(model: model, originalFont: fontN, fontSize: 5.4*factor)
            }
        }
        .frame(width: 53.98*factor, height: 48.96*factor)
        .offset(y: 2*factor)
        .background(secondaryColor)
        .cornerRadius(6.75*factor)
    }
    
    @ViewBuilder func wifi(factor: CGFloat, model: WidgetModel) -> some View {
        let font = CommonFontNames.PingFangSCMedium.rawValue
        VStack(spacing: 6*factor) {
            Image(netMoniter.isWifiConnected ? "mianban_wifi" : "mianban_wifiOff")
                .resizable().scaledToFit()
                .frame(width: 22*factor, height: 22*factor)
            Text("WiFi:\(netMoniter.isWifiConnected ? "On" : "Off")")
                .changeFont(model: model, originalFont: font, fontSize: 6.75*factor)
                .changeTextColor(model: model, originalColor: .white)
        }
        .frame(width: 46.56*factor, height: 52*factor)
        .background(secondaryColor)
        .cornerRadius(6.75*factor)
    }
    
    @ViewBuilder func time(factor: CGFloat, model: WidgetModel) -> some View {
        Text("\(date.hourString):\(date.minuteString)")
            .minimumScaleFactor(0.3)
            .changeTextColor(model: model, originalColor: .white)
            .changeFont(model: model, originalFont: CommonFontNames.PingFangSCMedium.rawValue, fontSize: 16.19*factor)
            .frame(width: 98.52*factor, height: 49.64*factor)
            .background(secondaryColor)
            .cornerRadius(6.75*factor)
    }
    
    @ViewBuilder func deviceDescription(factor: CGFloat, model: WidgetModel) -> some View {
        Text(Device.current.description)
            .changeFont(model: model, originalFont: CommonFontNames.PingFangSCMedium.rawValue, fontSize: 9.45*factor)
            .changeTextColor(model: model, originalColor: .white)
            .frame(width: 98.52*factor, height: 49.64*factor)
            .background(secondaryColor)
            .cornerRadius(6.75*factor)
    }
    
    @ViewBuilder func phoneInfo(factor: CGFloat, model: WidgetModel) -> some View {
        VStack(spacing: 10*factor) {
            Text("\(UIDevice.current.name)")
                .changeFont(model: model, originalFont: CommonFontNames.PingFangSCRegular.rawValue, fontSize: 9.45*factor)
                .changeTextColor(model: model, originalColor: .white)
            HStack(spacing: 2*factor) {
                Image("mianban_apple").resizable().scaledToFill()
                    .frame(width: 21*factor, height: 21*factor)
                Text("\(Device.current.cpu.description)")
                    .changeFont(model: model, originalFont: CommonFontNames.PingFangSCMedium.rawValue, fontSize: 13.5*factor)
                    .changeTextColor(model: model, originalColor: .white)
            }
        }
        .frame(width: 104.59*factor, height: 71.59*factor)
        .background(secondaryColor)
        .cornerRadius(6.75*factor)
    }
    
    @ViewBuilder func network(factor: CGFloat, model: WidgetModel) -> some View {
        let font = CommonFontNames.PingFangSCMedium.rawValue
        VStack(spacing: 6*factor) {
            Image(netMoniter.isCellularConnected ? "mianban_network" : "mianban_cellularOff")
                .resizable().scaledToFit()
                .frame(width: 22*factor, height: 22*factor)
            Text("蜂窝:\(netMoniter.isCellularConnected ? "On" : "Off")")
                .changeFont(model: model, originalFont: font, fontSize: 6.75*factor)
                .changeTextColor(model: model, originalColor: .white)
        }
        .frame(width: 46.56*factor, height: 52*factor)
        .background(secondaryColor)
        .cornerRadius(6.75*factor)
    }
    
    @ViewBuilder func battery(factor: CGFloat, model: WidgetModel) -> some View {
        let width = 104.59
        let strokeW = 3.0
        let batteryUsage = Double(getBatteryUsage())
        let cornerRadius = 6.75
        RoundedRectangle(cornerRadius: cornerRadius*factor)
            .strokeBorder(style: .init(lineWidth: strokeW*factor))
            .foregroundColor(secondaryColor)
            .frame(width: width*factor, height: 32.42*factor)
            .overlay(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4.72*factor)
                    .fill(LinearGradient(colors: buttonColors, startPoint: .leading, endPoint: .trailing))
                    .padding([.leading, .trailing], strokeW*factor)
                    .frame(width: batteryUsage*width*factor, height: 25.67*factor)
            }
            .overlay(alignment: .leading) {
                Text("电量:\(Int(batteryUsage*100))%")
                    .changeFont(model: model, originalFont: CommonFontNames.PingFangSCMedium.rawValue, fontSize: 6.75*factor)
                    .changeTextColor(model: model, originalColor: secondaryColor)
                    .padding(.leading, 10*factor)
            }
    }
    
    @ViewBuilder func systemVersion(factor: CGFloat, model: WidgetModel) -> some View {
        let device = Device.current
        VStack(spacing: 8*factor) {
            Image("mianban_shouji").resizable().scaledToFill()
                .frame(width: 35*factor, height: 63*factor)
            Text((device.systemName ?? "") + " " + (device.systemVersion ?? ""))
                .changeTextColor(model: model, originalColor: .white)
                .changeFont(model: model, originalFont: CommonFontNames.PingFangSCMedium.rawValue, fontSize: 6.75*factor)
        }
        .frame(width: 45.21*factor, height: 104.68*factor)
        .background(secondaryColor)
        .cornerRadius(6.75*factor)
    }
    
    @ViewBuilder func bluetooth(factor: CGFloat, model: WidgetModel) -> some View {
        let imageN = bluetooth.isOn ? "mianban_lanya" : "mianban_bluetoothOff"
        VStack(spacing: 6*factor) {
            Image(imageN)
                .resizable().scaledToFit()
                .frame(width: 22*factor, height: 22*factor)
            Text("蓝牙:\(bluetooth.isOn ? "On" : "Off")")
                .changeTextColor(model: model, originalColor: .white)
                .changeFont(model: model, originalFont: CommonFontNames.PingFangSCMedium.rawValue, fontSize: 6.75*factor)
        }
        .frame(width: 46.56*factor, height: 52*factor)
        .background(secondaryColor)
        .cornerRadius(6.75*factor)
    }
    
    @ViewBuilder func brightness(factor: CGFloat, model: WidgetModel) -> some View {
        let imageN = Device.current.screenBrightness > 0 ? "mianban_brightness" : "mianban_brightnessOff"
        VStack(spacing: 6*factor) {
            Image(imageN)
                .resizable().scaledToFit()
                .frame(width: 22*factor, height: 22*factor)
            Text("亮度:\(Device.current.screenBrightness)%")
                .changeTextColor(model: model, originalColor: .white)
                .changeFont(model: model, originalFont: CommonFontNames.PingFangSCMedium.rawValue, fontSize: 6.75*factor)
        }
        .frame(width: 46.56*factor, height: 52*factor)
        .background(secondaryColor)
        .cornerRadius(6.75*factor)
    }
}

struct ControlPanelLargeOne_Previews: PreviewProvider {
    static var previews: some View {
        ControlPanelLargeOne(date: Date(), model: WidgetModel(id: .ControlPanelLargeOne))
            .frame(width: 329, height: 345)
            .background(.gray)
    }
}
