//
//  IntentHandler.swift
//  HotWidgetIntentsExtension
//
//  Created by weijie.zhou on 2023/2/25.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}

extension IntentHandler: SmallWidgetSelectIntentHandling {
    
    func provideCurrentWidgetOptionsCollection(for intent: SmallWidgetSelectIntent) async throws -> INObjectCollection<WidgetType> {
        AppData.shared.fetchWidgetsFromSharedContainer()
        let widgetTypes = AppData.shared.mySmallWidgets.map { model in
            WidgetType(identifier: "\(model.id.rawValue)", display: model.name ?? "N/A")
        }

        let collection =  INObjectCollection(items: widgetTypes)
        return collection
    }
    
}

extension IntentHandler: MediumWidgetSelectIntentHandling {
    func provideCurrentWidgetOptionsCollection(for intent: MediumWidgetSelectIntent) async throws -> INObjectCollection<WidgetType> {
        AppData.shared.fetchWidgetsFromSharedContainer()
        let widgetTypes = AppData.shared.myMediumWidgets.map { model in
            WidgetType(identifier: "\(model.id.rawValue)", display: model.name ?? "N/A")
        }

        let collection =  INObjectCollection(items: widgetTypes)
        return collection
    }
}

extension IntentHandler: LargeWidgetSelectIntentHandling {
    func provideCurrentWidgetOptionsCollection(for intent: LargeWidgetSelectIntent) async throws -> INObjectCollection<WidgetType> {
        AppData.shared.fetchWidgetsFromSharedContainer()
        let widgetTypes = AppData.shared.myLargeWidgets.map { model in
            WidgetType(identifier: "\(model.id.rawValue)", display: model.name ?? "N/A")
        }

        let collection =  INObjectCollection(items: widgetTypes)
        return collection
    }
}
    
