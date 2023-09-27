//
//  MediumWidget.swift
//  HotWidgetsExtension
//
//  Created by weijie.zhou on 2023/3/11.
//

import WidgetKit
import SwiftUI
import SwiftUITools

struct MediumWidgetProvider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> MediumWidgetEntry {
        return MediumWidgetEntry(date: Date(), model: WidgetModel(id: .DefaultWidgetMedium))
    }
    
    func getSnapshot(for configuration: MediumWidgetSelectIntent, in context: Context, completion: @escaping (MediumWidgetEntry) -> Void) {
        let id = configuration.currentWidget?.identifier
        AppData.shared.fetchWidgetsFromSharedContainer()
        let model = AppData.shared.myMediumWidgets.filter{"\($0.id.rawValue)"==id}.first
        completion(MediumWidgetEntry(date: Date(), model: model ?? WidgetModel(id: .DefaultWidgetMedium)))
    }
    
    func getTimeline(for configuration: MediumWidgetSelectIntent, in context: Context, completion: @escaping (Timeline<MediumWidgetEntry>) -> Void) {
        let id = configuration.currentWidget?.identifier
        AppData.shared.fetchWidgetsFromSharedContainer()
        let model = AppData.shared.myMediumWidgets.filter {"\($0.id.rawValue)"==id}.first ?? WidgetModel(id: .DefaultWidgetMedium)
        var entries: [MediumWidgetEntry] = []
        if (model.id == .WeiBoReSouMediumOne || model.id == .WeiBoReSouMediumTwo) {
            AppData.fetchReSou { resoumodel in
                let date =  Date()
                AppData.shared.reSouModel = resoumodel
                entries.append(MediumWidgetEntry(date: date, model: model))
                let timeLine = Timeline(entries: entries, policy: .after(date.advanced(by: 50.0)))
                completion(timeLine)
            }
        }
        else if (model.id == .DigitalClockMediumOne || model.id == .DashBoardMediumOne || model.id == .DashBoardMediumTwo || model.id == .DashBoardMediumThree) {
            Task {
                let distance = try await getWalkingRunningDistance()
                AppData.shared.runningDistance = distance
                
                var entries: [MediumWidgetEntry] = []
                let _ = try await AppData.shared.fetchWeather()
                let calendar = Calendar(identifier: .chinese)
                let date = Date()
                let startOfMinute = calendar.startOfMinute(for: date)
                entries.append(MediumWidgetEntry(date: date, model: model))
                for i in 1...15 {
                    let nextDate = calendar.date(byAdding: .minute, value: i, to: startOfMinute)!
                    entries.append(MediumWidgetEntry(date: nextDate, model: model))
                }
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }
        }
        else {
            let date =  Date()
            entries.append(MediumWidgetEntry(date: date, model: model))
            let timeLine = Timeline(entries: entries, policy: .atEnd)
            completion(timeLine)
        }
    }
    
    typealias Entry = MediumWidgetEntry
    
    typealias Intent = MediumWidgetSelectIntent
    
}

struct MediumWidgetEntry: TimelineEntry {
    var date: Date
    
    var model: WidgetModel
}

struct MediumWidgetView: View {
    var entry: MediumWidgetProvider.Entry
    
    var body: some View {
        let model = entry.model
        switch model.id {
        case .DigitalClockMediumOne:
            DigitalClockMediumOne(model: model, date: entry.date)
        case .DashBoardMediumOne:
            DashBoardSmallOne(model: model, date: entry.date)
        case .DashBoardMediumTwo:
            DashBoardMediumTwo(model: model, date: entry.date)
        case .DashBoardMediumThree:
            DashBoardMediumThree(model: model, date: entry.date)
        default:
            widgetViewWithModel(model: entry.model)
        }
    }
}

struct MediumWidget: Widget {
    let kind: String = "MediumWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: MediumWidgetSelectIntent.self, provider: MediumWidgetProvider()) { entry in
            MediumWidgetView(entry: entry)
        }
        .configurationDisplayName("中号")
        .description("")
        .supportedFamilies([.systemMedium])
    }
}

