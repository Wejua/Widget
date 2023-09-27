//
//  API.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/7/12.
//

import Foundation
import SwiftUITools

struct API {
    
    static func login(deviceID: String) async throws -> String {
        let url = baseUrl + "/user/deviceLogin"
        let para = ["device_id": deviceID]
        let data = try await Requester.request(method: .POST, otherHeader: [:], urlString: url, parameters: para)
        let json = JSON(data)["data"]
        let token = json["access_token"].stringValue
        Store.shared.token = token
        Store.shared.refreshToken = json["refresh_token"].stringValue
        return token
    }
    
    static func widgetList(token: String) async throws -> WidgetList {
        let url = baseUrl + "/component/list"
        let data = try await Requester.request(method: .GET, otherHeader: ["token": token], urlString: url, parameters: [:])
        let isExpired = try JSON(data: data)["msg"] == "token expired"
        if isExpired {
            fatalError("token expired")
        } else {
            let model = try JSONDecoder().decode(WidgetList.self, from: data)
            return model
        }
    }
    
    static func refreshToken() async throws -> Bool {
        guard let refreshToken = Store.shared.refreshToken else {return false}
        let url = baseUrl + "/user/refresh"
        let para = ["refresh_token": refreshToken]
        let data = try await Requester.request(method: .POST, otherHeader: [:], urlString: url, parameters: para)
        let json = try JSON(data: data)["data"]
        let token = json["refresh_token"].string
        let refreshTokenNew = json["access_token"].string
        Store.shared.token = token
        Store.shared.refreshToken = refreshTokenNew
        return true
    }
}

struct WidgetList: Codable {
    var data: [WidgetListCategories]
    
    struct WidgetListCategories: Codable {
        var id: WidgetCategory
        var name: String
        var list: [WidgetItem]
        
        struct WidgetItem: Codable {
            var id: WidgetViewID
            var name: String
            var icon: String
            var is_free: String
        }
    }
}


