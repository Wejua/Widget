//
//  WidgetsHandler.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/16.
//

import SwiftUI
import SwiftUITools

//推荐，快捷（3个id），新闻（5个id），仪表盘（9个id），日历(6个id)，天气(3个id)，时钟(6个id)，面板(3个id)
enum WidgetCategory: Int, CaseIterable, Codable {
    case recommend = 1
    case news = 2
    case kuaiJie = 3
    case dashboard = 4
    case calendar = 5
    case weather = 6
    case clock = 7
    case panel = 8
}

enum WidgetViewID: Int, CaseIterable, Codable {
    case DefaultWidgetSmall = -1
    case DefaultWidgetMedium = -2
    case DefaultWidgetLarge = -3
    case CalendarSmallOne = 1
    case CalendarSmallTwo = 2
    case CalendarMediumOne = 3
    case CalendarMediumTwo = 4
    case CalendarLargeOne = 5
    case CalendarLargeTwo = 6
    case ShortCutsLargeOne = 7
    case WeChatScanSmall = 8
    case ShortCutsMediumOne = 9
    case WeiBoReSouSmallOne = 10
    case WeiBoReSouSmallTwo = 11
    case WeiBoReSouMediumOne = 12
    case WeiBoReSouMediumTwo = 13
    case WeiBoReSouLargeOne = 14
    case DashBoardSmallOne = 15
    case DashBoardSmallTwo = 16
    case DashBoardSmallThree = 17
    case DashBoardMediumOne = 18
    case DashBoardMediumTwo = 19
    case DashBoardMediumThree = 20
    case DashBoardLargeOne = 21
    case DashBoardLargeTwo = 22
    case DashBoardLargeThree = 23
    case WeatherSmallOne = 24
    case WeatherMediumOne = 25
    case WeatherLargeOne = 26
    case DigitalClockSmallOne = 27
    case DigitalClockMediumOne = 28
    case DigitalClockLargeOne = 29
    case ClockSmallOne = 30
    case ClockMediumOne = 31
    case ClockLargeOne = 32
    case ControlPanelSmallOne = 33
    case ControlPanelMediumOne = 34
    case ControlPanelLargeOne = 35
    
    var category: WidgetCategory? {
        switch self {
        case .DefaultWidgetSmall, .DefaultWidgetMedium, .DefaultWidgetLarge: return nil
        case .CalendarSmallOne, .CalendarSmallTwo, .CalendarMediumOne, .CalendarMediumTwo, .CalendarLargeOne, .CalendarLargeTwo: return WidgetCategory.calendar
        case .ShortCutsLargeOne, .WeChatScanSmall, .ShortCutsMediumOne: return WidgetCategory.kuaiJie
        case .WeiBoReSouSmallOne, .WeiBoReSouSmallTwo, .WeiBoReSouMediumOne, .WeiBoReSouMediumTwo, .WeiBoReSouLargeOne: return WidgetCategory.news
        case .DashBoardSmallOne, .DashBoardSmallTwo, .DashBoardSmallThree, .DashBoardMediumOne, .DashBoardMediumTwo, .DashBoardMediumThree,.DashBoardLargeOne, .DashBoardLargeTwo, .DashBoardLargeThree: return WidgetCategory.dashboard
        case .WeatherSmallOne, .WeatherMediumOne, .WeatherLargeOne: return WidgetCategory.weather
        case .DigitalClockSmallOne, .DigitalClockMediumOne, .DigitalClockLargeOne, .ClockSmallOne, .ClockMediumOne, .ClockLargeOne: return WidgetCategory.clock
        case .ControlPanelSmallOne, .ControlPanelMediumOne, .ControlPanelLargeOne: return WidgetCategory.panel
        }
    }
    
    static func familyWithID(id: WidgetViewID) -> Family {
        switch id {
        case .DefaultWidgetSmall: return .small
        case .DefaultWidgetMedium: return .medium
        case .DefaultWidgetLarge: return .large
        case .CalendarSmallOne: return .small
        case .CalendarSmallTwo: return .small
        case .CalendarMediumOne: return .medium
        case .CalendarMediumTwo: return .medium
        case .CalendarLargeOne: return .large
        case .CalendarLargeTwo: return .large
        case .ShortCutsLargeOne: return .large
        case .WeChatScanSmall: return .small
        case .ShortCutsMediumOne: return .medium
        case .WeiBoReSouSmallOne: return .small
        case .WeiBoReSouMediumOne: return .medium
        case .WeiBoReSouMediumTwo: return .medium
        case .WeiBoReSouSmallTwo: return .small
        case .WeiBoReSouLargeOne: return .large
        case .DashBoardSmallOne: return .small
        case .DashBoardSmallTwo: return .small
        case .DashBoardSmallThree: return .small
        case .DashBoardMediumOne: return .medium
        case .DashBoardMediumTwo: return .medium
        case .DashBoardMediumThree: return .medium
        case .DashBoardLargeOne: return .large
        case .DashBoardLargeTwo: return .large
        case .DashBoardLargeThree: return .large
        case .WeatherSmallOne: return .small
        case .WeatherMediumOne: return .medium
        case .WeatherLargeOne: return .large
        case .DigitalClockSmallOne: return .small
        case .DigitalClockMediumOne: return .medium
        case .DigitalClockLargeOne: return .large
        case .ClockSmallOne: return .small
        case .ClockMediumOne: return .medium
        case .ClockLargeOne: return .large
        case .ControlPanelSmallOne: return .small
        case .ControlPanelMediumOne: return .medium
        case .ControlPanelLargeOne: return .large
        }
    }
}
