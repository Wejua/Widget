//
//  Store.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/5/31.
//

import Foundation
import SwiftUI

let primaryColor = "#303234".color!
let secondaryColor = "#111419".color!
let captionColor = "#999999".color!

let buttonColors = ["#91F036".color!, "#2CE2EE".color!]

let tokenKey = "tokenKey"
let refreshTokenKey = "refreshTokenKey"

struct LocationMessages: Codable {
    var country: String
    var province: String
    var city: String {
        didSet {
            if city == "市辖区" {
                city = self.province
            }
        }
    }
    var district: String
    var township: String
    var adcCode: String?
}

struct RealTimeForcasting: Codable {
    var province: String
    var city: String
    var adcode: String
    var weather: String
    var temperature: String
    var winddirection: String
    var windpower: String
    var humidity: String
    var reporttime: String
}

struct Forcasting: Codable {
    var date: String
    var daypower: String
    var nightpower: String
    var daytemp: String
    var nighttemp: String
    var dayweather: String
    var nightweather: String
    var daywind: String
    var nightwind: String
    var week: String
}

class Store: ObservableObject {
    static let shared = Store()
    var location: LocationMessages? //当前位置
    var realTimeForcasting: RealTimeForcasting? //今天天气
    var forcastings: [Forcasting]? //未来几天天气
    var token: String? {
        get {
            UserDefaults.standard.value(forKey: tokenKey) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
    var refreshToken: String? {
        get {
            UserDefaults.standard.value(forKey: refreshTokenKey) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: refreshTokenKey)
        }
    }
    
    @Published var navPath: NavigationPath = NavigationPath()
}
