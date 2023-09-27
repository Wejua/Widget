//
//  AppData.swift
//  HotWidget
//
//  Created by 周位杰 on 2022/12/11.
//

import Foundation
import SwiftUI
import SwiftUITools
import CoreLocation

let smallRatio = 155.0/155.0
let mediumRatio = 329.0/155.0
let largeRatio = 329.0/345.0
let widgetClickScheme = "hotwidget://widgetclick"
let defaultCornerRadius = 20.0
let defaultBorderWidth = 10.0
let defaultFont = "San Francisco"
let weiboresouparameter = ["access-key":"475a7d866f3f74df1857b8e55747af25","secret-key":"38fd7ba1bf9d5667c2d0403b61f35afd"]
let weiboresouurl = "https://www.coderutil.com/api/resou/v1/weibo"
let weiBoReSouHomeURL = "https://s.weibo.com/top/summary"
let baseUrl = "https://zujian.olbibo.cn/api"
let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2Nzk1Nzg2NzUsIm5iZiI6MTY3OTU3ODY3NSwiZXhwIjoxNjgwMTgzNDc1LCJ0eXBlIjoiYWNjZXNzIiwidWlkIjoiNTAzNzQ3MDQ0MTkifQ.4AEfyJV1vi_wqo_rTwMOpVxDHYu2gJuZCkbK72hRmDI"
let weatherUrl = "https://restapi.amap.com/v3/weather/weatherInfo"
let weatherParameter = ["key":"24091d02677c4415e9cd40a8960aa052"]
let LatitudeAndLongitudeToDistrictUrl = "https://restapi.amap.com/v3/geocode/regeo"
let LatitudeAndLongitudeToDistrictParameter = ["key":"24091d02677c4415e9cd40a8960aa052"]

#if DEBUG
let appGroupName = "group.com.hotWidget.appAndWidgetShare"
#else
let appGroupName = "group.w.com.emCgC.Widgeter"
#endif

let backgroundImagesKey = "bacgroundImagesKey"
let borderImagesKey = "borderImagesKey"


let panelDetalTag = "panelDetail"
let areaSelectViewTag = "AreaSelectViewTag"

class AppData: ObservableObject {
    static let shared = AppData()
    static var activateLink = true
    @Published var mySmallWidgets: [WidgetModel] = []
    @Published var myMediumWidgets: [WidgetModel] = []
    @Published var myLargeWidgets: [WidgetModel] = []
    static var reSouModelRequestTime: Date?
    @Published var reSouModel: ReSouModel?
    var runningDistance: Double = 0
    
    init() {
        let path = Bundle.main.path(forResource: "ReSouDefaultData", ofType: nil)
        let url = URL(fileURLWithPath: path!)
        if let data = try? Data(contentsOf:url) {
            if let model = try? JSONDecoder().decode(ReSouModel.self, from: data) {
                self.reSouModel = model
            }
        }
        AppData.fetchReSou { resouM in
            if let model = resouM {
                self.reSouModel = model
            }
        }
    }
}

enum LocationAuthorizationError: Error {
    case authorizationFail
    case formatFail
}

extension AppData {
//    func fetchWeather(completion: @escaping (WeatherModel?, LocationAuthorizationError?) -> Void) {
//        let manager = LocationManager()
//        manager.locationManager.requestWhenInUseAuthorization()
//        guard manager.locationManager.authorizationStatus == .authorizedAlways || manager.locationManager.authorizationStatus == .authorizedWhenInUse else {completion(nil, .authorizationFail); return}
//        guard let location = manager.locationManager.location else {completion(nil, nil); return}
//        var para = LatitudeAndLongitudeToDistrictParameter
//        para["location"] = "\(location.coordinate.longitude),\(location.coordinate.latitude)"
//        Requester.request(method: .GET, otherHeader: [:], urlString: LatitudeAndLongitudeToDistrictUrl, parameters: para) { data, error in
//            guard let data = data else {completion(nil, nil); return}
//            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String:Any],let regeocode = json["regeocode"] as? [String:Any],let addressComponent = regeocode["addressComponent"] as? [String:Any],let adcCode = addressComponent["adcode"] as? String  else {completion(nil, nil); return}
//            if let addressComponentData = try? JSONSerialization.data(withJSONObject: addressComponent) {
//                Store.shared.location = try? JSONDecoder().decode(LocationMessages.self, from: addressComponentData)
//            }
//            var para = weatherParameter
//            para["city"] = adcCode
//            Requester.request(method: .GET, otherHeader: [:], urlString: weatherUrl, parameters: para, mapModel: WeatherModel.self) { model, error in
//                self.weather = model
//                completion(model, nil)
//            }
//        }
//    }
    
    func getAdcCode() async throws -> LocationMessages? {
        let manager = LocationManager()
        manager.locationManager.requestWhenInUseAuthorization()
        let granted = manager.locationManager.authorizationStatus == .authorizedAlways || manager.locationManager.authorizationStatus == .authorizedWhenInUse
        if granted {
            guard let location = manager.locationManager.location else {return nil}
            var para = LatitudeAndLongitudeToDistrictParameter
            para["location"] = "\(location.coordinate.longitude),\(location.coordinate.latitude)"
            let data = try await Requester.request(method: .GET, otherHeader: [:], urlString: LatitudeAndLongitudeToDistrictUrl, parameters: para)
            let addressComponent = try JSON(data: data)["regeocode"]["addressComponent"]
            if let addressComponentData = try? addressComponent.rawData() {
                var location = try? JSONDecoder().decode(LocationMessages.self, from: addressComponentData)
                let adcCode = addressComponent["adcode"].string
                location?.adcCode = adcCode
                Store.shared.location = location
                return location
            } else {
                throw LocationAuthorizationError.formatFail
            }
        } else {
            throw LocationAuthorizationError.authorizationFail
        }
    }
    
    func fetchWeather() async throws -> (real:RealTimeForcasting, forcasting: [Forcasting]) {
        let location = try await getAdcCode()
        
        var para1 = weatherParameter
        para1["city"] = location?.adcCode
        
        var para2 = weatherParameter
        para2["city"] = location?.adcCode
        para2["extensions"] = "all"
        
        let realWeatherData = try await Requester.request(method: .GET, otherHeader: [:], urlString: weatherUrl, parameters: para1)
        let forcastData = try await Requester.request(method: .GET, otherHeader: [:], urlString: weatherUrl, parameters: para2)
        
        let realJson = try  JSON(data: realWeatherData)["lives"][0]
        let realModel = try JSONDecoder().decode(RealTimeForcasting.self, from: try realJson.rawData())
        Store.shared.realTimeForcasting = realModel
        
        let forcastJson = try  JSON(data: forcastData)["forecasts"][0]["casts"]
        let forcastModel = try JSONDecoder().decode([Forcasting].self, from: forcastJson.rawData())
        Store.shared.forcastings = forcastModel
        return (realModel, forcastModel)
    }
    
    static func fetchReSou(completion: @escaping (_ resoumodel: ReSouModel?) -> Void) {
        var para = weiboresouparameter
        para["size"] = "10"
        Requester.request(method: .GET, otherHeader: [:], urlString: weiboresouurl, parameters: para, mapModel: ReSouModel.self) { model, error in
            completion(model)
        }
    }
    
    func storeWidgetsToSharedContainer() {
        let defaults = UserDefaults(suiteName: appGroupName)
        if let data = try? JSONEncoder().encode(mySmallWidgets) {
            defaults?.set(data, forKey: "mySmallWidgets")
        }
        if let data = try? JSONEncoder().encode(myMediumWidgets) {
            defaults?.set(data, forKey: "myMediumWidgets")
        }
        if let data = try? JSONEncoder().encode(myLargeWidgets) {
            defaults?.set(data, forKey: "myLargeWidgets")
        }
    }
    
    func fetchWidgetsFromSharedContainer() {
        let defaults = UserDefaults(suiteName: appGroupName)
        guard let smallData = defaults?.object(forKey: "mySmallWidgets") as? Data else {return}
        guard let mediumData = defaults?.object(forKey: "myMediumWidgets") as? Data else {return}
        guard let largeData = defaults?.object(forKey: "myLargeWidgets") as? Data else {return}
        let mySmallWidgets = try? JSONDecoder().decode([WidgetModel].self, from: smallData)
        let myMediumWidgets = try? JSONDecoder().decode([WidgetModel].self, from: mediumData)
        let myLargeWidgets = try? JSONDecoder().decode([WidgetModel].self, from: largeData)
        self.mySmallWidgets = mySmallWidgets ?? []
        self.myMediumWidgets = myMediumWidgets ?? []
        self.myLargeWidgets = myLargeWidgets ?? []
    }
    
    func saveBackgroundImages(backgrounds: [String:UIImage]) {
        var images = self.getBackgroundImages() ?? [:]
        backgrounds.forEach { (key: String, value: UIImage) in
            images[key] = value
        }
        let defaults = UserDefaults(suiteName: appGroupName)
        defaults?.set(images, forKey: backgroundImagesKey)
    }

    func getBackgroundImages() -> [String:UIImage]? {
        let defaults = UserDefaults(suiteName: appGroupName)
        let dic = defaults?.value(forKey: backgroundImagesKey) as? [String:UIImage]
        return dic
    }
    
    func saveBorderImages(borders: [String:UIImage]) {
        var images = self.getBorderImages() ?? [:]
        borders.forEach { (key: String, value: UIImage) in
            images[key] = value
        }
        let defaults = UserDefaults(suiteName: appGroupName)
        defaults?.set(images, forKey: borderImagesKey)
    }

    func getBorderImages() -> [String:UIImage]? {
        let defaults = UserDefaults(suiteName: appGroupName)
        let dic = defaults?.value(forKey: borderImagesKey) as? [String:UIImage]
        return dic
    }
}
