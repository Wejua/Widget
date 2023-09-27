//
//  WidgetModel.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/2/26.
//

import Foundation
import WidgetKit
import SwiftUI

enum Family: Codable, CaseIterable, Hashable {
    case small
    case medium
    case large

    func familyValue() -> WidgetFamily {
        switch self {
        case .small: return .systemSmall
        case .medium: return .systemMedium
        case .large: return .systemLarge
        }
    }
    
    func defaultSize() -> CGSize {
        switch self {
        case .small: return CGSize(width: 155, height: 155)
        case .medium: return CGSize(width: 329, height: 155)
        case .large: return CGSize(width: 329, height: 345)
        }
    }
}

class WidgetModel: ObservableObject, Codable, Hashable {
    @Published var id: WidgetViewID
    @Published var name: String?
    @Published var icon: String?
    @Published var is_free: String?
    var family: Family
    @Published var style: WidgetStyle = WidgetStyle()
    
    func copy() -> WidgetModel {
        let model = WidgetModel(id: self.id)
        model.name = self.name
        model.icon = self.icon
        model.is_free = self.is_free
        model.family = self.family
        model.style = self.style.copy()
        return model
    }
    
    static func == (lhs: WidgetModel, rhs: WidgetModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init (id: WidgetViewID, name: String? = nil, icon: String? = nil, is_free:String? = nil, style: WidgetStyle? = WidgetStyle()) {
        self.id = id
        self.name = name
        self.icon = icon
        self.is_free = is_free
        self.style = style ?? WidgetStyle()
        self.family = WidgetViewID.familyWithID(id: id)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.name, forKey: .name)
        try container.encodeIfPresent(self.icon, forKey: .icon)
        try container.encodeIfPresent(self.is_free, forKey: .is_free)
        try container.encodeIfPresent(self.family, forKey: .family)
        try container.encodeIfPresent(self.style, forKey: .style)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(WidgetViewID.self, forKey: .id)
        self.id = id
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.icon = try container.decodeIfPresent(String.self, forKey: .icon)
        self.is_free = try container.decodeIfPresent(String.self, forKey: .is_free)
        self.family = try container.decodeIfPresent(Family.self, forKey: .family) ?? WidgetViewID.familyWithID(id: id)
        self.style = try container.decodeIfPresent(WidgetStyle.self, forKey: .style) ?? WidgetStyle()
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case icon
        case is_free
        case family
        case style
        case reSouModel
    }
}

enum BorderType: String, CaseIterable, Codable {
    case none = "none"
    case album = "album"
    case border1 = "border1"
    case border2 = "border2"
    case border3 = "border3"
    case border4 = "border4"
    case border5 = "border5"
    case border6 = "border6"
    case border7 = "border7"
    case border8 = "border8"
    case border9 = "border9"
}

class WidgetStyle: ObservableObject, Codable {
    @Published var background: String?
    @Published var textFont: String?
    @Published var textColor: String?
    @Published var border: BorderType = .none
    @Published var biaoPanYangShi: String? //表盘样式
    @Published var adcCode: String? //当前位置,用于获取天气
    
    func copy() -> WidgetStyle {
        let style = WidgetStyle(backgroud: self.background, textFont: self.textFont, textColor: self.textColor, border: self.border, biaoPanYangShi: self.biaoPanYangShi, adcCode: self.adcCode)
        return style
    }
    
    init(){}
    
    init(backgroud: String? = nil, textFont: String? = nil, textColor: String? = nil, border: BorderType, biaoPanYangShi: String? = nil, adcCode: String? = nil) {
        self.background = backgroud
        self.textFont = textFont
        self.textColor = textColor
        self.border = border
        self.biaoPanYangShi = biaoPanYangShi
        self.adcCode = adcCode
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.background, forKey: .background)
        try container.encodeIfPresent(self.textFont, forKey: .textFont)
        try container.encodeIfPresent(self.textColor, forKey: .textColor)
        try container.encode(self.border, forKey: .border)
        try container.encodeIfPresent(self.biaoPanYangShi, forKey: .biaoPanYangShi)
        try container.encodeIfPresent(self.adcCode, forKey: .adcCode)
    }
    
    enum CodingKeys: CodingKey {
        case background
        case textFont
        case textColor
        case border
        case biaoPanYangShi
        case adcCode
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.background = try container.decodeIfPresent(String.self, forKey: .background)
        self.textFont = try container.decodeIfPresent(String.self, forKey: .textFont)
        self.textColor = try container.decodeIfPresent(String.self, forKey: .textColor)
        self.border = try container.decode(BorderType.self, forKey: .border)
        self.biaoPanYangShi = try container.decodeIfPresent(String.self, forKey: .biaoPanYangShi)
        self.adcCode = try container.decodeIfPresent(String.self, forKey: .adcCode)
    }
    
}
