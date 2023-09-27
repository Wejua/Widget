//
//  SmallWidget.swift
//  HotWidgetsExtension
//
//  Created by weijie.zhou on 2023/3/11.
//

import WidgetKit
import SwiftUI
import SwiftUITools

struct SmallWidgetProvider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> SmallWidgetEntry {
        return SmallWidgetEntry(date: Date(), model: WidgetModel(id: .DefaultWidgetSmall))
    }
    
    func getSnapshot(for configuration: SmallWidgetSelectIntent, in context: Context, completion: @escaping (SmallWidgetEntry) -> Void) {
        let id = configuration.currentWidget?.identifier
        AppData.shared.fetchWidgetsFromSharedContainer()
        let model = AppData.shared.mySmallWidgets.filter{"\($0.id.rawValue)"==id}.first
        completion(SmallWidgetEntry(date: Date(), model: model ?? WidgetModel(id: .DefaultWidgetSmall)))
    }
    
    func getTimeline(for configuration: SmallWidgetSelectIntent, in context: Context, completion: @escaping (Timeline<SmallWidgetEntry>) -> Void) {
        let id = configuration.currentWidget?.identifier
        var entries = [SmallWidgetEntry]()
        AppData.shared.fetchWidgetsFromSharedContainer()
        let model = AppData.shared.mySmallWidgets.filter {"\($0.id.rawValue)"==id}.first ?? WidgetModel(id: .DefaultWidgetSmall)
        if (model.id == .WeiBoReSouSmallOne || model.id == .WeiBoReSouSmallTwo) {
            AppData.fetchReSou { resoumodel in
                let date =  Date()
                AppData.shared.reSouModel = resoumodel
                entries.append(SmallWidgetEntry(date: date, model: model))
                completion(Timeline(entries: entries, policy: .after(date.advanced(by: 50.0))))
            }
        }
        else if model.id == .DigitalClockSmallOne || model.id == .DashBoardSmallOne || model.id == .DashBoardSmallTwo || model.id == .DashBoardSmallThree {
            Task {
                let distance = try await getWalkingRunningDistance()
                AppData.shared.runningDistance = distance
                
                var entries = [SmallWidgetEntry]()
                let calendar = Calendar(identifier: .chinese)
                let date = Date()
                let startOfMinute = calendar.startOfMinute(for: date)
                entries.append(SmallWidgetEntry(date: date, model: model))
                for i in 1...15 {
                    let nextDate = calendar.date(byAdding: .minute, value: i, to: startOfMinute)!
                    entries.append(SmallWidgetEntry(date: nextDate, model: model))
                }
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }
        }
        else {
            let date = Date()
            entries.append(SmallWidgetEntry(date: date, model: model))
            let timeLine = Timeline(entries: entries, policy: .never)
            completion(timeLine)
        }
    }
    
    typealias Entry = SmallWidgetEntry
    
    typealias Intent = SmallWidgetSelectIntent
    
}

struct SmallWidgetEntry: TimelineEntry {
    var date: Date
    
    var model: WidgetModel
}

struct SmallWidgetView: View {
    let entry: SmallWidgetProvider.Entry
    
    var body: some View {
        let model = entry.model
        switch model.id {
        case .DigitalClockSmallOne:
            DigitalClockSmallOne(model: model, date: entry.date)
        case .DashBoardSmallOne:
            DashBoardSmallOne(model: model, date: entry.date)
        case .DashBoardSmallTwo:
            DashBoardSmallTwo(model: model, date: entry.date)
        case .DashBoardSmallThree:
            DashBoardSmallThree(model: model, date: entry.date)
        default:
            widgetViewWithModel(model: entry.model)
        }
    }
}

struct SmallWidget: Widget {
    let kind: String = "SmallWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SmallWidgetSelectIntent.self, provider: SmallWidgetProvider()) { entry in
            SmallWidgetView(entry: entry)
        }
        .configurationDisplayName("小号")
        .description("")
        .supportedFamilies([.systemSmall])
    }
}
