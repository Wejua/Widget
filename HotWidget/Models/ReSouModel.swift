//
//  ReSouModel.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/16.
//

import Foundation

class ReSouModel: ObservableObject, Codable {
    @Published var data:[ReSouItemModel]
    
    init(data: [ReSouItemModel]) {
        self.data = data
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.data, forKey: .data)
    }
    
    enum CodingKeys: CodingKey {
        case data
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode([ReSouItemModel].self, forKey: .data)
    }
}

class ReSouItemModel: ObservableObject, Codable {
    var rank: Int
    var keyword: String
    var url: String
    var isHot: Bool
    var isNew: Bool
    var isBoil: Bool
    
    init(rank: Int, keyword: String, url: String, isHot: Bool, isNew: Bool, isBoil: Bool) {
        self.rank = rank
        self.keyword = keyword
        self.url = url
        self.isHot = isHot
        self.isNew = isNew
        self.isBoil = isBoil
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.rank, forKey: .rank)
        try container.encode(self.keyword, forKey: .keyword)
        try container.encode(self.url, forKey: .url)
        try container.encode(self.isHot, forKey: .isHot)
        try container.encode(self.isNew, forKey: .isNew)
        try container.encode(self.isBoil, forKey: .isBoil)
    }
    
    enum CodingKeys: CodingKey {
        case keyword
        case url
        case isHot
        case isNew
        case isBoil
        case rank
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rank = try container.decode(Int.self, forKey: .rank)
        self.keyword = try container.decode(String.self, forKey: .keyword)
        self.url = try container.decode(String.self, forKey: .url)
        self.isHot = try container.decode(Bool.self, forKey: .isHot)
        self.isNew = try container.decode(Bool.self, forKey: .isNew)
        self.isBoil = try container.decode(Bool.self, forKey: .isBoil)
    }
}
