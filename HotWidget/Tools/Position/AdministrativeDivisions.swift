//
//  AdministrativeDivisions.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/29.
//

import Foundation

struct AdministrativeDivisions {
    static let provinces: [Province] = {
        let path = Bundle.main.path(forResource: "adc", ofType: "json")!
        let fileUrl = URL(filePath: path)
        let data = try! Data(contentsOf: fileUrl)
        let provinces = try! JSONDecoder().decode([Province].self, from: data)
        return provinces
    }()
}

struct Province: Codable {
    var provinceCode: String
    var provinceName: String
    var cities: [City]
    
    enum CodingKeys: String, CodingKey {
        case provinceCode = "code"
        case provinceName = "name"
        case cities = "children"
    }
}

struct City: Codable {
    var cityCode: String
    var cityName: String
    var districts: [District]
    
    enum CodingKeys: String, CodingKey {
        case cityCode = "code"
        case cityName = "name"
        case districts = "children"
    }
}

struct District: Codable {
    var districtCode: String
    var districtName: String
    
    enum CodingKeys: String, CodingKey {
        case districtCode = "code"
        case districtName = "name"
    }
}
