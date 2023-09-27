//
//  ControlPanelDetail.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/7/5.
//

import SwiftUI
import SwiftUITools
import DeviceKit

struct ControlPanelDetail: View {
    var date: Date
    @ObservedObject var netMoniter = NetworkMonitor()
    @ObservedObject var bluetooth = BluetoothManager()
    @ObservedObject var wifiSpeed = NetSpeed()
    @State var memoryUsage = CPUAndMemoryUsage().systemMemoryUsage()
    @State var memoryTotal = CPUAndMemoryUsage().systemMemoryTotal()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        FitScreenMin(reference: 375) { factor, geo in
            VStack(spacing: 10*factor) {
                HStack(spacing: 10*factor) {
                    VStack(spacing: 10*factor) {
                        CpuInfoView(factor: factor)
                        HStack(spacing: 10*factor) {
                            phoneInfo(factor: factor)
                            dateView(factor: factor)
                        }
                    }
                    capacity(factor: factor)
                }
                HStack(spacing: 10*factor) {
                    wifiSpeed(factor: factor)
                    batteryUsage(factor: factor)
                }
                HStack(spacing: 10*factor) {
                    memory(factor: factor)
                    VStack(spacing: 10*factor) {
                        systemVersion(factor: factor)
                        HStack(spacing: 10*factor) {
                            network(factor: factor)
                            wifi(factor: factor)
                        }
                    }
                }
                HStack(spacing: 10*factor) {
                    time(factor: factor)
                    bluetooth(factor: factor)
                    brightness(factor: factor)
                }
                Spacer()
            }
            .padding(15)
        }
        .inlineNavigationTitle(title: Text("面板详情"))
        .customBackView {
            Image("popbackImage")
        }
        .onReceive(timer) { _ in
            memoryUsage = CPUAndMemoryUsage().systemMemoryUsage()
            memoryTotal = CPUAndMemoryUsage().systemMemoryTotal()
        }
    }
    
    @ViewBuilder func phoneInfo(factor: CGFloat) -> some View {
        VStack(spacing: 7*factor) {
            Image("mianban_apple").resizable().scaledToFill()
                .frame(width: 20*factor, height: 20*factor)
            Text("\(Device.current.cpu.description)")
                .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 14*factor, lineLi: nil)
        }
        .frame(width: 122*factor, height: 71*factor)
        .background(secondaryColor)
        .cornerRadius(10*factor)
    }
    
    @ViewBuilder func dateView(factor: CGFloat) -> some View {
        VStack(spacing: 0*factor) {
            Text(String(date.month) + "月")
                .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 12*factor, lineLi: nil)
            Text(String(date.day))
                .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 27*factor, lineLi: nil)
                .minimumScaleFactor(0.3)
        }
        .frame(width: 66*factor, height: 71*factor)
        .background(secondaryColor)
        .cornerRadius(10*factor)
    }
    
    @ViewBuilder func capacity(factor: CGFloat) -> some View {
        let lineW = 8*factor
        let storagePercent = (try? getStorageUsed()) ?? 0.0
        let totalGB = (try? getTotalCapacity()) ?? 0.0
        let idle = String(format:"%.2f",(1.0-storagePercent)*totalGB)
        RoundedRectangle(cornerRadius: 10*factor)
            .fill(secondaryColor)
            .frame(width: 137*factor, height: 178*factor)
            .overlay(alignment: .topLeading) {
                Text("存储")
                    .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 14*factor, lineLi: nil)
                    .padding(12*factor)
            }
            .overlay {
                ZStack {
                    Circle()
                        .stroke(captionColor, style: .init(lineWidth: lineW*factor))
                    Circle()
                        .trim(from: 0, to: storagePercent)
                        .rotation(Angle(degrees: -90))
                        .stroke(LinearGradient(colors: buttonColors, startPoint: .leading, endPoint: .trailing), style: .init(lineWidth: lineW*factor, lineCap: .round))
                }
                .frame(width: 80*factor, height: 80*factor)
                .overlay(alignment: .center) {
                    VStack(spacing: 2) {
                        Text("已用")
                            .textSett(color: captionColor, FName: .PingFangSCRegular, Fsize: 12*factor, lineLi: nil)
                        Text("\(String(format: "%.0f", storagePercent*100))%")
                            .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 18*factor, lineLi: nil)
                    }
                }
                .offset(y: -7*factor)
            }
            .overlay(alignment: .bottom) {
                HStack(spacing: 6*factor) {
                    VStack(alignment:.leading, spacing: 0*factor) {
                        Text(idle)
                            .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 12*factor, lineLi: nil)
                        Text("剩余")
                            .textSett(color: captionColor, FName: .PingFangSCRegular, Fsize: 12*factor, lineLi: nil)
                    }
                    VStack(alignment: .leading, spacing: 0*factor) {
                            Text(String(format:"%.2fGB", totalGB))
                            .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 12*factor, lineLi: nil)
                        Text("总量")
                            .textSett(color: captionColor, FName: .PingFangSCRegular, Fsize: 12*factor, lineLi: nil)
                    }
                }
                .padding(12*factor)
            }
    }
    
    @ViewBuilder func wifiSpeed(factor: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 10*factor)
            .fill(secondaryColor)
            .frame(width: 137*factor, height: 142*factor)
            .overlay {
                VStack(alignment: .leading, spacing: 18*factor) {
                    Text("WiFi")
                        .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 14*factor, lineLi: nil)
                    HStack(spacing: 0*factor) {
                        Text("下载")
                            .textSett(color: captionColor, FName: .PingFangSCRegular, Fsize: 14*factor, lineLi: 1)
                        let wifiReceived = String(format: "%.1f", wifiSpeed.wifiReceived)
                        Spacer(minLength: 12*factor)
                        Text("\(wifiReceived)KB")
                            .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 14*factor, lineLi: 1)
                            .minimumScaleFactor(0.3)
                    }
                    HStack(spacing: 0*factor) {
                        Text("上传")
                            .textSett(color: captionColor, FName: .PingFangSCRegular, Fsize: 14*factor, lineLi: 1)
                        Spacer(minLength: 12*factor)
                        let wifiSend = String(format: "%.1f", wifiSpeed.wifiSend)
                        Text("\(wifiSend)KB")
                            .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 14*factor, lineLi: 1)
                            .minimumScaleFactor(0.3)
                    }
                }
                .padding(12*factor)
            }
    }
    
    @ViewBuilder func batteryUsage(factor: CGFloat) -> some View {
        HStack(spacing: 10*factor) {
            RoundedRectangle(cornerRadius: 10*factor)
                .fill(secondaryColor)
                .frame(width: 87*factor, height: 142*factor)
                .overlay {
                    ZStack {
                        Rectangle().fill(LinearGradient(colors: buttonColors, startPoint: .leading, endPoint: .trailing))
                            .mask {
                                WaveView(color: .green, amplify: 15, percent: CGFloat(getBatteryUsage()))
                                    .cornerRadius(10*factor)
                            }
                        VStack(alignment: .leading, spacing: 0) {
                            Text("电量")
                                .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 14*factor, lineLi: nil)
                            Spacer()
                            let usage = String(format: "%.0f", getBatteryUsage()*100)
                            Text("\(usage)%")
                                .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 22*factor, lineLi: 1)
                                .minimumScaleFactor(0.3)
                        }
                        .padding([.leading, .top, .bottom], 12*factor)
                    }
                }
            
            // battery detail
            VStack(spacing: 10*factor) {
                RoundedRectangle(cornerRadius: 10*factor)
                    .fill(secondaryColor)
                    .frame(width: 101*factor, height: 66*factor)
                    .overlay(alignment: .leading) {
                        VStack(alignment: .leading, spacing: 2*factor) {
                            Text("\(maxBatteryCapacity(for: Device.current.description))mAh")
                                .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 14*factor, lineLi: nil)
                                .minimumScaleFactor(0.3)
                            Text("电池容量")
                                .textSett(color: captionColor, FName: .PingFangSCRegular, Fsize: 12*factor, lineLi: 1)
                                .minimumScaleFactor(0.3)
                        }
                        .padding([.leading, .trailing], 12*factor)
                    }
                
                RoundedRectangle(cornerRadius: 10*factor)
                    .fill(secondaryColor)
                    .frame(width: 101*factor, height: 66*factor)
                    .overlay(alignment: .leading) {
                        VStack(alignment: .leading, spacing: 2*factor) {
                            let useTime = 24 * 60 * getBatteryUsage()
                            let hour = Int(useTime) / 60
                            let minute = Int(useTime) % 60
                            Text("\(hour)小时\(minute)分钟")
                                .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 14*factor, lineLi: 1)
                                .minimumScaleFactor(0.3)
                            Text("电池预计可用")
                                .textSett(color: captionColor, FName: .PingFangSCRegular, Fsize: 12*factor, lineLi: 1)
                                .minimumScaleFactor(0.3)
                        }
                        .padding([.leading, .trailing], 12*factor)
                    }
            }
        }
    }
    
    @ViewBuilder func memory(factor: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10*factor)
                .fill(secondaryColor)
            VStack(alignment: .leading, spacing: 24*factor) {
                Text("内存")
                    .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 14*factor, lineLi: 1)
                HStack(spacing: 12*factor) {
                    Circle().fill(.linearGradient(colors: buttonColors, startPoint: .leading, endPoint: .trailing))
                        .frame(width: 72*factor, height: 72*factor)
                        .mask {
                            WaveView(color: .blue, amplify: 15, percent: memoryUsage)
                        }
                        .overlay {
                            Circle().stroke("#91F036".color!, style: .init(lineWidth: 2*factor))
                        }
                        .overlay {
                            let used = memoryUsage*memoryTotal/1024
                            Text(String(format:"%.2fGB", used))
                                .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 14*factor, lineLi: 1)
                        }
                    VStack(alignment:.leading, spacing: 6*factor) {
                        VStack(alignment:.leading, spacing: 0*factor) {
                            let free = (1-memoryUsage) * memoryTotal / 1024.0
                            Text(String(format: "%.2fGB", free))
                                .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 14*factor, lineLi: 1)
                                .minimumScaleFactor(0.3)
                                .frame(width: 57*factor, height: 20*factor, alignment: .leading)
                            Text("空闲")
                                .textSett(color: captionColor, FName: .PingFangSCRegular, Fsize: 12*factor, lineLi: 1)
                                .minimumScaleFactor(0.3)
                        }
                        VStack(alignment:.leading, spacing: 0*factor) {
                            let total = CPUAndMemoryUsage().systemMemoryTotal()/1024.0
                            Text(String(format: "%.1fGB", total))
                                .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 14*factor, lineLi: 1)
                                .minimumScaleFactor(0.3)
                                .frame(width: 57*factor, height: 20*factor, alignment: .leading)
                            Text("总量")
                                .textSett(color: captionColor, FName: .PingFangSCRegular, Fsize: 12*factor, lineLi: 1)
                                .minimumScaleFactor(0.3)
                        }
                    }
                }
            }
            .padding(12*factor)
        }
        .frame(width: 168*factor, height: 157*factor)
    }
    
    @ViewBuilder func systemVersion(factor: CGFloat) -> some View {
        HStack(spacing: 15*factor) {
            Image("mianban_shouji").resizable().scaledToFill()
                .frame(width: 28*factor, height: 51*factor)
                .padding(.leading, 15*factor)
            VStack(alignment: .leading, spacing: 1*factor) {
                Text(UIDevice.current.name)
                    .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 14*factor, lineLi: 1)
                    .minimumScaleFactor(0.3)
                Text(Device.current.description)
                    .textSett(color: captionColor, FName: .PingFangSCRegular, Fsize: 14*factor, lineLi: 1)
                    .minimumScaleFactor(0.3)
                    .padding(.trailing, 15*factor)
            }
        }
        .frame(width: 167*factor, height: 85*factor)
        .background(secondaryColor)
        .cornerRadius(6.75*factor)
    }
    
    @ViewBuilder func bluetooth(factor: CGFloat) -> some View {
        let imageN = bluetooth.isOn ? "mianban_lanya" : "mianban_bluetoothOff"
        HStack(spacing: 0*factor) {
            Image(imageN)
                .resizable().scaledToFit()
                .frame(width: 24*factor, height: 24*factor)
            Text("\(bluetooth.isOn ? "On" : "Off")")
                .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 14*factor, lineLi: 1)
                .minimumScaleFactor(0.3)
                .frame(width: 37*factor, height: 20*factor)
        }
        .frame(width: 78*factor, height: 60*factor)
        .background(secondaryColor)
        .cornerRadius(10*factor)
    }
    
    @ViewBuilder func brightness(factor: CGFloat) -> some View {
        let imageN = Device.current.screenBrightness > 0 ? "mianban_brightness" : "mianban_brightnessOff"
        HStack(spacing: 0*factor) {
            Image(imageN)
                .resizable().scaledToFit()
                .frame(width: 24*factor, height: 24*factor)
            Text("\(Device.current.screenBrightness)%")
                .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 14*factor, lineLi: 1)
                .minimumScaleFactor(0.3)
                .frame(width: 37*factor, height: 20*factor)
        }
        .frame(width: 78*factor, height: 60*factor)
        .background(secondaryColor)
        .cornerRadius(10*factor)
    }
    
    @ViewBuilder func wifi(factor: CGFloat) -> some View {
        HStack(spacing: 0*factor) {
            Image(netMoniter.isWifiConnected ? "mianban_wifi" : "mianban_wifiOff")
                .resizable().scaledToFit()
                .frame(width: 24*factor, height: 24*factor)
            Text("\(netMoniter.isWifiConnected ? "On" : "Off")")
                .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 14*factor, lineLi: 1)
                .minimumScaleFactor(0.3)
                .frame(width: 37*factor, height: 20*factor)
        }
        .frame(width: 78*factor, height: 60*factor)
        .background(secondaryColor)
        .cornerRadius(10*factor)
    }
    
    @ViewBuilder func network(factor: CGFloat) -> some View {
        HStack(spacing: 0*factor) {
            Image(netMoniter.isCellularConnected ? "mianban_network" : "mianban_cellularOff")
                .resizable().scaledToFit()
                .frame(width: 24*factor, height: 24*factor)
            Text("\(netMoniter.isCellularConnected ? "On" : "Off")")
                .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 14*factor, lineLi: 1)
                .minimumScaleFactor(0.3)
                .frame(width: 37*factor, height: 20*factor)
        }
        .frame(width: 78*factor, height: 60*factor)
        .background(secondaryColor)
        .cornerRadius(10*factor)
    }
    
    @ViewBuilder func time(factor: CGFloat) -> some View {
        Text("\(date.hourString):\(date.minuteString)")
            .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 14*factor, lineLi: 1)
            .minimumScaleFactor(0.3)
            .frame(width: 168*factor, height: 58*factor)
            .background(secondaryColor)
            .cornerRadius(10*factor)
    }
}

struct CpuInfoView: View {
    var factor: CGFloat
    @State var cpuUsage: Double = CPUAndMemoryUsage().applicationCPU()
    @State var cpuFrequency: UInt = CPUAndMemoryUsage().cpuFrequency()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10*factor)
            .fill(secondaryColor)
            .frame(width: 198*factor, height: 97*factor)
            .overlay {
                Rectangle().fill(LinearGradient(colors: buttonColors, startPoint: .leading, endPoint: .trailing))
                    .mask {
                        WaveView(color: .blue, amplify: 15, percent: cpuUsage/100.0)
                            .cornerRadius(10*factor)
                    }
            }
            .overlay(alignment: .topLeading) {
                VStack(alignment:.leading, spacing: 5*factor) {
                    Text("CPU")
                        .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 14*factor, lineLi: nil)
                    let cpuUsage = String(format: "%.0f", cpuUsage)
                    Text("\(cpuUsage)%")
                        .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 26*factor, lineLi: nil)
                        .minimumScaleFactor(0.3)
                }
                .padding(12*factor)
            }
//            .overlay(alignment: .bottomTrailing) {
//                Text("频率 \(cpuFrequency)GHz")
//                    .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 12*factor, lineLi: nil)
//                    .padding(12*factor)
//            }
            .onReceive(timer) { _ in
                cpuUsage = CPUAndMemoryUsage().applicationCPU()
                cpuFrequency =  CPUAndMemoryUsage().cpuFrequency()
            }
    }
}

struct WaveView: View {
    var color: Color
    var amplify: CGFloat
    var percent: CGFloat
    
    var body: some View {
        ZStack {
            WaveForm(color: color, amplify: amplify, isReversed: false, percent: percent)
            WaveForm(color: color, amplify: amplify, isReversed: true, percent: percent)
                .opacity(0.6)
        }
    }
}

struct WaveForm: View {
    var color: Color
    var amplify: CGFloat
    var isReversed: Bool
    var percent: CGFloat
    
    var body: some View {
        // Using Time Line View for periodic Updates...
        TimelineView(.animation) { timeline in
            // Canvas View for drawing Wave...
            Canvas { context, size in
                let timeNow = timeline.date.timeIntervalSinceReferenceDate
                
                // animating the wave using current time...
                let angle = timeNow.remainder(dividingBy: 10) //2 means -1 to 1
                let offset = angle/5.0 * size.width
                
                context.translateBy(x: isReversed ? -offset : offset, y: 0)
                
                // Using SwiftUI Path for drawing Wave...
                context.fill(getPath(size: CGSize(width: size.width+1, height: size.height)), with: .color(color))
                
                //drawing curve front and back, so that translation will be look like wave animation...
                context.translateBy(x: -size.width+1, y: 0)
                
                context.fill(getPath(size: size), with: .color(color))
                
                context.translateBy(x: size.width*2-1, y: 0)
                
                context.fill(getPath(size: size), with: .color(color))
            }
        }
    }
    
    func getPath(size: CGSize) -> Path {
        return Path { path in
            let width = size.width
            let height = size.height * (1-percent) + amplify/3
            let x1 = isReversed ? 0.65 : 0.5
            let x2 = isReversed ? 0.5 : 0.65
            path.move(to: CGPoint(x: 0, y: height))
            path.addCurve(to: CGPoint(x: width, y: height), control1: CGPoint(x: width*x1, y: height+amplify),control2: CGPoint(x: width*x2, y: height-amplify))
            
            //filling the bottom remaining area...
            path.addLine(to: CGPoint(x: width, y: size.height))
            path.addLine(to: CGPoint(x: 0, y: size.height))
        }
    }
}

struct ControlPanelDetail_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.gray
            ControlPanelDetail(date: Date())
        }
    }
}
