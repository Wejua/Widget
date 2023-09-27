//
//  NetSpeed.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/7/7.
//

import Foundation

class NetSpeed: NSObject, ObservableObject {
    @Published var wifiSend: Float = 0.0
    @Published var wifiReceived: Float = 0.0
    
    private let flow = MonitorFlow()
    lazy var timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
        if let dic = self.flow.getWifiDataIncrement() {
            self.wifiSend = (dic["send"] as? Float) ?? 0.0
            self.wifiReceived = (dic["received"] as? Float) ?? 0.0
        }
    }
    
    override init() {
        super.init()
        self.timer.fire()
    }
}
