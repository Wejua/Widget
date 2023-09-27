//
//  HotWidgetApp.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/2/25.
//

import SwiftUI
import WidgetKit
import SwiftUITools


@main
struct HotWidgetApp: App {
    @Environment(\.scenePhase) var phase
    @StateObject var store = Store.shared
    @State var showWebView: (show: Bool, url: String?) = (false, nil)
    
    init() {
        TalkingDataSDK.`init`("D43B2BD95D874FD7856BFEFBBD56E1B9", channelId: "AppStore", custom: "")
    }
    
    var body: some Scene {
        WindowGroup {
            let _ = AppData.shared
            ContentView(navPath: $store.navPath)
                .onOpenURL { url in
                    if url.absoluteString.contains(widgetClickScheme), let query = url.query()?.replacing("id=", with: "") {
                        let appData = AppData.shared
                        appData.fetchWidgetsFromSharedContainer()
                        let allMyWidgets = appData.myLargeWidgets + appData.myMediumWidgets + appData.mySmallWidgets
                        if let model = allMyWidgets.filter({String($0.id.rawValue) == query}).first {
                            store.navPath.removeLast(store.navPath.count)
                            store.navPath.append(model)
                        }
                    }
                    else if url.absoluteString.contains("https://s.weibo.com") {
                        showWebView = (true, url.absoluteString)
                    }
                    else if url.absoluteString.contains(panelDetalTag) {
                        store.navPath.append(panelDetalTag)
                    }
                    else {
                        UIApplication.shared.open(url)
                    }
                }
                .onChange(of: phase) { newValue in
                    if newValue == .background {
                        WidgetCenter.shared.reloadAllTimelines()
                    } else if newValue == .active {
                        
                    }
                }
                .sheet(isPresented: $showWebView.show) {
                    if let urlString = showWebView.url {
                        WeiBoReSouWebView(urlString: urlString)
                    }
                }
        }
    }
}
