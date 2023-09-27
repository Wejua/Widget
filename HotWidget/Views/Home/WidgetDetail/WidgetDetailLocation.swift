//
//  WidgetDetailLocation.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/7/14.
//

import SwiftUI
import SwiftUITools

struct WidgetDetailLocation: View {
    @State var locationStr = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("位置")
                    .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 14, lineLi: 1)
                Spacer()
                NavigationLink {
                    AreaSelectView()
                } label: {
                    
                    HStack(spacing: 5) {
                        Text(locationStr)
                            .textSett(color: "#AAAAAA".color!, FName: .PingFangSCRegular, Fsize: 12, lineLi: 1)
                        Image("widgetDetailLocationArrow")
                    }
                }
//                .onTapGesture {
//                    Store.shared.navPath.append(areaSelectViewTag)
//                }
            }
            .padding([.leading, .trailing], 20)
            .padding([.bottom], 26)
            Rectangle().fill(primaryColor)
                .frame(height: 10)
        }
        .onAppear{
            Task {
                if let location = try await AppData.shared.getAdcCode() {
                    locationStr = "\(location.city) \(location.district)"
                }
            }
        }
    }
}

struct WidgetDetailLocation_Previews: PreviewProvider {
    static var previews: some View {
        WidgetDetailLocation()
    }
}
