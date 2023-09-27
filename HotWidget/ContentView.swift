//
//  ContentView.swift
//  HotWidget
//
//  Created by 周位杰 on 2022/12/10.
//

import SwiftUI
import SwiftUITools

// "https://dy.yiqiyouwan.cn/imgs/ysxy.html"
// "https://dy.yiqiyouwan.cn/imgs/yyxy.html"

enum PushingViews: CaseIterable, Hashable {
    case widgetDetailView
    case vipView
}
let showPrivacyAlertKey = "showPrivacyAlertKey"


struct ContentView: View {
    
    @State private var selection: Tab = .widgetsHome
    @Binding var navPath: NavigationPath
    @State var showDisagreeAlert: Bool = false
    @State private var showPrivacyAlert: Bool = !UserDefaults.standard.bool(forKey: showPrivacyAlertKey)
    
    enum Tab {
        case widgetsHome
        case themeHome
        case profileHome
    }
    
    init(navPath: Binding<NavigationPath>) {
        _navPath = navPath
    }
    
    var body: some View {
        let _  = AppData.activateLink = false
        NavigationStack(path: $navPath) {
            TabView(selection: $selection) {
                WidgetsHome()
                    .tabItem {
                        Text("组件")
                            .foregroundColor(Color(red: 130/255.0, green: 91/255.0, blue: 118/255.0))
                        Image(systemName: "star")
                            .renderingMode(.original)
                            .foregroundColor(Color(red: 130/255.0, green: 91/255.0, blue: 118/255.0))
                    }
                    .tag(Tab.widgetsHome)
                
                ThemeHome()
                    .tabItem {
                        Text("主题")
                            .foregroundColor(Color(red: 130/255.0, green: 91/255.0, blue: 118/255.0))
                        Image(systemName: "message")
                            .renderingMode(.original)
                            .foregroundColor(Color(red: 130/255.0, green: 91/255.0, blue: 118/255.0))
                    }
                    .tag(Tab.themeHome)

                ProfileHome()
                    .tabItem {
                        Text("我的")
                            .foregroundColor(Color(red: 130/255.0, green: 91/255.0, blue: 118/255.0))
                        Image(systemName: "person.crop.circle")
                            .renderingMode(.original)
                    }
                    .tag(Tab.profileHome)

            }
            .navigationDestination(for: WidgetModel.self) { model in
                WidgetDetailView(model: model)
            }
            .navigationDestination(for: String.self, destination: { string in
                if string == panelDetalTag {
                    ControlPanelDetail(date: Date())
                } else if string == areaSelectViewTag {
                    AreaSelectView()
                }
            })
            .customAlert(isPresent: $showPrivacyAlert) {
                CustomAlert(isPresent: $showPrivacyAlert) {
                    UserDefaults.standard.set(true, forKey: showPrivacyAlertKey)
                } disagree: {
                    showDisagreeAlert.toggle()
                }
            }
            .alert("同意用户协议和隐私政策才能登录", isPresented: $showDisagreeAlert) {
                Button(role: .destructive) {
                    exit(0)
                } label: {
                    Text("退出应用")
                }
                Button(role: .cancel) {
                    UserDefaults.standard.set(true, forKey: showPrivacyAlertKey)
                } label: {
                    Text("同意")
                }
            }

        }
        .accentColor(Color(hex: "#FF226AFF"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(navPath: .constant(NavigationPath()))
    }
}
