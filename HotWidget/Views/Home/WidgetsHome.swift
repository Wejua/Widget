//
//  WidgetsHome.swift
//  HotWidget
//
//  Created by 周位杰 on 2022/12/10.
//

import SwiftUI

struct WidgetsHome: View {
    
    @State var widgetLists: WidgetList?
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 25) {
                ForEach(widgetLists?.data ?? [], id: \.id) {category in
                    CategoryRow(category: category)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color(hex: "#303234FF"))
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 30, trailing: 0))
                }
            }
//            .listStyle(.inset)
            .onAppear {
                getWidgetList()
            }
//            .navigationTitle("")
            .safeAreaInset(edge: .bottom) {
                Button {
                    
                } label: {
                    Text("解锁全部特权")
                        .foregroundColor(.white)
                        .frame(width: 325, height: 50)
                        .background(LinearGradient(colors: ["#91F036FF".color!, "#2CE2EEFF".color!], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(25, corners: .allCorners)
                }
                .padding([.bottom, .top], 20)
            }
            .scrollContentBackground(.hidden)
            .background(Color(hex: "#303234FF"))
//            .bottomSafeAreaColor(color: Color(hex: "000000FF"))
        }
        .background(Color(hex: "#303234FF"))
        .topSafeAreaColor(color: Color(hex: "#303234FF"))
//        .padding(.bottom, 49)
    }
    
    func getWidgetList() {
//        let url = Bundle.main.url(forResource: "widgetList", withExtension: "json")
//        let jsonData = try? Data(contentsOf: url!)
//        widgetLists = try? JSONDecoder().decode(WidgetList.self, from: jsonData!)
        
        let deviceID = TalkingDataSDK.getDeviceId() ?? ""
        if Store.shared.token == nil {
            Task {
                let token = try await API.login(deviceID: deviceID)
                widgetLists = try await API.widgetList(token: token)
            }
        } else {
            Task {
                let refreshed = try await API.refreshToken()
                widgetLists = try await API.widgetList(token: Store.shared.token!)
            }
        }
    }
    
}

struct WidgetsHome_Previews: PreviewProvider {
    static var previews: some View {
        WidgetsHome()
    }
}
