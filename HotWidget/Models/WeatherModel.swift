//
//  File.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/29.
//

import Foundation

final class WeatherModel: ObservableObject, Codable {
    var info: String
    var infocode: String
    @Published var lives: [WeatherItemModel]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.info = try container.decode(String.self, forKey: .info)
        self.infocode = try container.decode(String.self, forKey: .infocode)
        self.lives = try container.decode([WeatherItemModel].self, forKey: .lives)
    }
    
    enum CodingKeys: CodingKey {
        case info
        case infocode
        case lives
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.info, forKey: .info)
        try container.encode(self.infocode, forKey: .infocode)
        try container.encode(self.lives, forKey: .lives)
    }
}

final class WeatherItemModel: ObservableObject, Codable {
    @Published var province: String
    @Published var city: String
    @Published var adcode: String
    @Published var weather: String
    @Published var temperature: String
    @Published var winddirection: String
    @Published var windpower: String
    @Published var humidity: String
    @Published var reporttime: String
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.province, forKey: .province)
        try container.encode(self.city, forKey: .city)
        try container.encode(self.adcode, forKey: .adcode)
        try container.encode(self.weather, forKey: .weather)
        try container.encode(self.temperature, forKey: .temperature)
        try container.encode(self.winddirection, forKey: .winddirection)
        try container.encode(self.windpower, forKey: .windpower)
        try container.encode(self.humidity, forKey: .humidity)
        try container.encode(self.reporttime, forKey: .reporttime)
    }
    
    enum CodingKeys: CodingKey {
        case province
        case city
        case adcode
        case weather
        case temperature
        case winddirection
        case windpower
        case humidity
        case reporttime
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.province = try container.decode(String.self, forKey: .province)
        self.city = try container.decode(String.self, forKey: .city)
        self.adcode = try container.decode(String.self, forKey: .adcode)
        self.weather = try container.decode(String.self, forKey: .weather)
        self.temperature = try container.decode(String.self, forKey: .temperature)
        self.winddirection = try container.decode(String.self, forKey: .winddirection)
        self.windpower = try container.decode(String.self, forKey: .windpower)
        self.humidity = try container.decode(String.self, forKey: .humidity)
        self.reporttime = try container.decode(String.self, forKey: .reporttime)
    }
}
