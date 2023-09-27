//
//  WidgetViewHandler.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/16.
//

import SwiftUI
import AVFAudio
import HealthKit
import SwiftUITools

@ViewBuilder func widgetViewWithModel(model: WidgetModel) -> some View {
    switch model.id {
    case .DefaultWidgetSmall: DefaultWidgetSmall()
    case .DefaultWidgetMedium: DefaultWidgetMedium()
    case .DefaultWidgetLarge: DefaultWidgetLarge()
    case .CalendarSmallOne: CalendarSmallOne(model: model)
    case .CalendarSmallTwo: CalendarSmallTwo(model: model)
    case .CalendarMediumOne: CalendarMediumOne(model: model)
    case .CalendarMediumTwo: CalendarMediumOne(model: model)
    case .CalendarLargeOne: CalendarLargeOne(model: model)
    case .CalendarLargeTwo: CalendarLargeOne(model: model)
    case .ShortCutsLargeOne: ShortCutsLargeOne(model: model)
    case .WeChatScanSmall: WeChatScanSmall(model: model)
    case .ShortCutsMediumOne: ShortCutsMediumOne(model: model)
    case .WeiBoReSouSmallOne: WeiBoReSouSmallOne(model: model)
    case .WeiBoReSouSmallTwo: WeiBoReSouSmallTwo(model: model)
    case .WeiBoReSouMediumOne: WeiBoReSouMediumOne(model: model)
    case .WeiBoReSouMediumTwo: WeiBoReSouMediumTwo(model: model)
    case .WeiBoReSouLargeOne: WeiBoReSouLargeOne(model: model)
    case .DashBoardSmallOne: DashBoardSmallOne(model: model, date: Date())
    case .DashBoardSmallTwo: DashBoardSmallTwo(model: model, date: Date())
    case .DashBoardSmallThree: DashBoardSmallThree(model: model, date: Date())
    case .DashBoardMediumOne: DashBoardSmallOne(model: model, date: Date())
    case .DashBoardMediumTwo: DashBoardMediumTwo(model: model, date: Date())
    case .DashBoardMediumThree: DashBoardMediumThree(model: model, date: Date())
    case .DashBoardLargeOne: DashBoardSmallOne(model: model, date: Date())
    case .DashBoardLargeTwo: DashBoardLargeTwo(model: model, date: Date())
    case .DashBoardLargeThree: DashBoardLargeThree(model: model, date: Date())
    case .WeatherSmallOne: WeatherSmallOne(model: model)
    case .WeatherMediumOne: WeatherMediumOne(model: model, date: Date())
    case .WeatherLargeOne: WeatherLargeOne(model: model, date: Date())
    case .DigitalClockSmallOne: DigitalClockSmallOne(model: model, date: Date())
    case .DigitalClockMediumOne: DigitalClockMediumOne(model: model, date: Date())
    case .DigitalClockLargeOne: DigitalClockLargeOne(model: model, date: Date())
    case .ClockSmallOne: ClockSmallOne(date: Date(), model: model)
    case .ClockMediumOne: ClockMediumOne(date: Date(), model: model)
    case .ClockLargeOne: ClockLargeOne(date: Date(), model: model)
    case .ControlPanelSmallOne: ControlPanelSmallOne(date: Date(), model: model)
    case .ControlPanelMediumOne: ControlPanelMediumOne(date: Date(), model: model)
    case .ControlPanelLargeOne: ControlPanelLargeOne(date: Date(), model: model)
    }
}

func image(borderType: BorderType, family: Family) -> Image? {
    switch borderType {
    case .none, .album:
        return nil
    case .border1:
        switch family {
        case .small:
            return Image("border1Small")
        case .medium:
            return Image("border1Medium")
        case .large:
            return Image("border1Large")
        }
    case .border2:
        switch family {
        case .small:
            return Image("border2Small")
        case .medium:
            return Image("border2Medium")
        case .large:
            return Image("border2Large")
        }
    case .border3:
        switch family {
        case .small:
            return Image("border3Small")
        case .medium:
            return Image("border3Medium")
        case .large:
            return Image("border3Large")
        }
    case .border4:
        switch family {
        case .small:
            return Image("border4Small")
        case .medium:
            return Image("border4Medium")
        case .large:
            return Image("border4Large")
        }
    case .border5:
        switch family {
        case .small:
            return Image("border5Small")
        case .medium:
            return Image("border5Medium")
        case .large:
            return Image("border5Large")
        }
    case .border6:
        switch family {
        case .small:
            return Image("border6Small")
        case .medium:
            return Image("border6Medium")
        case .large:
            return Image("border6Large")
        }
    case .border7:
        switch family {
        case .small:
            return Image("border7Small")
        case .medium:
            return Image("border7Medium")
        case .large:
            return Image("border7Large")
        }
    case .border8:
        switch family {
        case .small:
            return Image("border8Small")
        case .medium:
            return Image("border8Medium")
        case .large:
            return Image("border8Large")
        }
    case .border9:
        switch family {
        case .small:
            return Image("border9Small")
        case .medium:
            return Image("border9Medium")
        case .large:
            return Image("border9Large")
        }
    }
}

extension View {
    @ViewBuilder func changeBackgroundColor(model: WidgetModel, originalColor: Color?=nil, image: Image?=nil) -> some View {
        if model.style.background == "clear" {
            self.foregroundColor(.clear)
        } else {
            if let colorS = model.style.background, let color = Color(hex: colorS) {
                self.foregroundColor(color)
            } else {
                if let image = image {
                    self.foregroundColor(.white)
                        .overlay {
                            image.resizable().scaledToFill()
                        }
                } else {
                    self.foregroundColor(originalColor)
                }
            }
        }
    }
    
    @ViewBuilder func changeBorder(model: WidgetModel) -> some View {
        let border = model.style.border
        if border != .none, border != .album {
            self.overlay {
                image(borderType: border, family: model.family)!
                    .resizable()
            }
        } else {
            self
        }
    }
    
    @ViewBuilder func changeTextColor(model: WidgetModel, originalColor: Color) -> some View {
        if let textColor = model.style.textColor, let color = Color(hex: textColor) {
            self.foregroundColor(color)
        }
        else {
            self.foregroundColor(originalColor)
        }
    }
    
    @ViewBuilder func changeFont(model: WidgetModel, originalFont: String, fontSize: CGFloat) -> some View {
        if let fontT = model.style.textFont, let font = UIFont(name: fontT, size: fontSize) {
            self.font(Font(font))
        } else {
            self.font(Font.custom(originalFont, size: fontSize))
        }
    }
    
    @ViewBuilder func changeLink(linkUrl: URL) -> some View {
        if AppData.activateLink {
            Link(destination: linkUrl) {
                self
            }
        } else {
            self
        }
    }
    
    func clickToDetailView(model: WidgetModel) -> some View {
        self.widgetURL(URL(string: widgetClickScheme + "?id=\(model.id)"))
    }
}

func getStorageUsed() throws -> Double {
    let fileURL = URL(fileURLWithPath:"/")
    let values = try fileURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey, .volumeTotalCapacityKey])
    if let capacity = values.volumeAvailableCapacityForImportantUsage, let total = values.volumeTotalCapacity {
        let remain = 1.0 - Double(capacity)/Double(total)
        return remain
    } else {
        fatalError("Capacity is unavailable")
    }
}

func getTotalCapacity() throws -> Double {
    let fileURL = URL(fileURLWithPath:"/")
    let values = try fileURL.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey, .volumeTotalCapacityKey])
    if let total = values.volumeTotalCapacity {
        return Double(total)/1024.0/1024.0/1024.0
    } else {
        fatalError("Capacity is unavailable")
    }
}

func getWalkingRunningDistance() async throws -> Double {
    try await withCheckedThrowingContinuation { continuation in
        let healthStore = HKHealthStore()
        healthStore.requestAuthorization(toShare: nil, read: [HKQuantityType(.distanceWalkingRunning)]) { isSuccess, error in
            if isSuccess {
                guard let type = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning) else {
                    continuation.resume(returning: 0)
                    return
//                    fatalError("Something went wrong retriebing quantity type distanceWalkingRunning")
                }
                let date =  Date()
                let cal = Calendar.current
                let newDate = cal.startOfDay(for: date)
                let predicate = HKQuery.predicateForSamples(withStart: newDate, end: Date(), options: .strictStartDate)
                let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: [.cumulativeSum]) { (query, statistics, error) in
                    var value: Double = 0
                    if error != nil {
                        continuation.resume(returning: 0)
                    } else if let quantity = statistics?.sumQuantity() {
                        value = quantity.doubleValue(for: HKUnit.mile())
                        continuation.resume(returning: value)
                    } else {
                        continuation.resume(returning: value)
                    }
                }
                healthStore.execute(query)
            }
        }
    }
}

import CoreBluetooth
final class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate {
    
    var manager = CBCentralManager()
    @Published var isOn: Bool = false
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            isOn = true
            break
        case .poweredOff:
            isOn = false
            break
        case .resetting:
            isOn = false
            break
        case .unauthorized:
            isOn = false
            break
        case .unsupported:
            isOn = false
            break
        case .unknown:
            isOn = false
            break
        default:
            isOn = false
            break
        }
    }
}

func getLight() -> CGFloat {
    let brightness = UIScreen.main.brightness
    return brightness
}

func getVolume() -> Float {
    var vol: Float
    let avInstance = AVAudioSession.sharedInstance()
    try? avInstance.setActive(true)
    vol = avInstance.outputVolume
    return vol
}

func getBatteryUsage() -> Float {
    UIDevice.current.isBatteryMonitoringEnabled = true
    let level = UIDevice.current.batteryLevel
    return level
}

///单位: mAh
func maxBatteryCapacity(for name: String) -> UInt {
    switch name {
    case "iPhone 14 Pro Max": return 4323
    case "iPhone 14 Pro": return 3200
    case "iPhone 14 Plus": return 4325
    case "iPhone 14": return 3279
    case "iPhone 13 Pro Max": return 4352
    case "iPhone 13 Pro": return 3095
    case "iPhone 13": return 3227
    case "iPhone 13 Mini": return 2406
    case "iPhone 12 Pro Max": return 3687
    case "iPhone 12 Pro": return 2815
    case "iPhone 12": return 2815
    case "iPhone 12 Mini": return 2227
    case "iPhone 11 Pro Max": return 3969
    case "iPhone 11 Pro": return 3048
    case "iPhone 11": return 3110
    case "iPhone XS Max": return 3180
    case "iPhone XS": return 2640
    case "iPhone XR": return 2950
    case "iPhone X": return 3000
    case "iPhone 8 Plus": return 2961
    case "iPhone 8": return 1800
    case "iPhone SE (2nd generation)": return 1821
    case "iPhone SE (3rd generation)": return 2018
    case "iPhone SE": return 1624
    case "iPhone 7 Plus": return 2900
    case "iPhone 7": return 2220
    case "iPhone 6s Plus": return 3500
    case "iPhone 6s": return 1715
    case "iPhone 6 Plus": return 2915
    case "iPhone 6": return 1810
    case "iPhone 5s": return 1560
    case "iPhone 5c": return 1510
    case "iPhone 5": return 1440
    case "iPhone 4s": return 1432
    case "iPhone 4": return 1420
    default: return 0000
    }
}

import NetworkExtension

final class NetworkMonitor: ObservableObject {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    @Published var isConnected: Bool = true
    
    
    let wifiMonitor = NWPathMonitor(requiredInterfaceType: .wifi)
    let wifiQueue = DispatchQueue(label: "wifiMonitor")
    @Published var isWifiConnected: Bool = true
    
    let cellularMonitor = NWPathMonitor(requiredInterfaceType: .cellular)
    let cellularQueue = DispatchQueue(label: "cellularMonitor")
    @Published var isCellularConnected: Bool = true
    
    init() {
        monitor.pathUpdateHandler = {[weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied ? true : false
            }
        }
        monitor.start(queue: queue)
        
        wifiMonitor.pathUpdateHandler = {[weak self] path in
            DispatchQueue.main.async {
                self?.isWifiConnected = path.status == .satisfied ? true : false
            }
        }
        wifiMonitor.start(queue: wifiQueue)
        
        cellularMonitor.pathUpdateHandler = {[weak self] path in
            DispatchQueue.main.async {
                self?.isCellularConnected = path.status == .satisfied ? true : false
            }
        }
        cellularMonitor.start(queue: cellularQueue)
    }
}
