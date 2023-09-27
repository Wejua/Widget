//
//  LargeWidget.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/11.
//

import WidgetKit
import SwiftUI
import SwiftUITools

struct LargeWidgetProvider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> LargeWidgetEntry {
        return LargeWidgetEntry(date: Date(), model: WidgetModel(id: .DefaultWidgetLarge))
    }
    
    func getSnapshot(for configuration: LargeWidgetSelectIntent, in context: Context, completion: @escaping (LargeWidgetEntry) -> Void) {
        let id = configuration.currentWidget?.identifier
        AppData.shared.fetchWidgetsFromSharedContainer()
        let model = AppData.shared.myLargeWidgets.filter{"\($0.id.rawValue)"==id}.first
        completion(LargeWidgetEntry(date: Date(), model: model ?? WidgetModel(id: .DefaultWidgetLarge)))
    }
    
    func getTimeline(for configuration: LargeWidgetSelectIntent, in context: Context, completion: @escaping (Timeline<LargeWidgetEntry>) -> Void) {
        let id = configuration.currentWidget?.identifier
        AppData.shared.fetchWidgetsFromSharedContainer()
        let model: WidgetModel = AppData.shared.myLargeWidgets.filter {"\($0.id.rawValue)"==id}.first ?? WidgetModel(id: .DefaultWidgetLarge)
        var entrys: [LargeWidgetEntry] = []
        if (model.id == .WeiBoReSouLargeOne) {
            AppData.fetchReSou { resoumodel in
                let date =  Date()
                AppData.shared.reSouModel = resoumodel
                entrys.append(LargeWidgetEntry(date: date, model: model))
                let timeLine = Timeline(entries: entrys, policy: .after(date.advanced(by: 50.0)))
                completion(timeLine)
            }
        }
        else if model.id == .DigitalClockLargeOne || model.id == .DashBoardLargeOne || model.id == .DashBoardLargeTwo || model.id == .DashBoardLargeThree {
            Task {
                let distance = try await getWalkingRunningDistance()
                AppData.shared.runningDistance = distance
                
                var entrys: [LargeWidgetEntry] = []
                let calendar = Calendar(identifier: .chinese)
                let date = Date()
                let startOfMinute = calendar.startOfMinute(for: date)
                entrys.append(LargeWidgetEntry(date: date, model: model))
                for i in 1...15 {
                    let nextDate = calendar.date(byAdding: .minute, value: i, to: startOfMinute)!
                    entrys.append(LargeWidgetEntry(date: nextDate, model: model))
                }
                let timeLine = Timeline(entries: entrys, policy: .atEnd)
                completion(timeLine)
            }
        }
        else {
            let date =  Date()
            entrys.append(LargeWidgetEntry(date: date, model: model))
            let timeLine = Timeline(entries: entrys, policy: .never)
            completion(timeLine)
        }
    }
    
    typealias Entry = LargeWidgetEntry
    
    typealias Intent = LargeWidgetSelectIntent
    
}

struct LargeWidgetEntry: TimelineEntry {
    var date: Date
    
    var model: WidgetModel
}

struct LargeWidgetView: View {
    var entry: LargeWidgetProvider.Entry
    
    var body: some View {
        switch entry.model.id {
        case .DigitalClockLargeOne:
            DigitalClockLargeOne(model: entry.model, date: entry.date)
        case .DashBoardLargeOne:
            DashBoardSmallOne(model: entry.model, date: entry.date)
        case .DashBoardLargeTwo:
            DashBoardLargeTwo(model: entry.model, date: entry.date)
        case .DashBoardLargeThree:
            DashBoardLargeThree(model: entry.model, date: entry.date)
        default:
            widgetViewWithModel(model: entry.model)
        }
    }
}

struct LargeWidget: Widget {
    let kind: String = "LargeWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: LargeWidgetSelectIntent.self, provider: LargeWidgetProvider()) { entry in
            LargeWidgetView(entry: entry)
        }
        .configurationDisplayName("大号")
        .description("")
        .supportedFamilies([.systemLarge])
    }
}
