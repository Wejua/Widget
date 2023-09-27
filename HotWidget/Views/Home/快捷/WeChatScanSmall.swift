//
//  WeChatScanSmall.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/16.
//

import SwiftUI
import SwiftUITools

struct WeChatScanSmall: View {
    @ObservedObject var model: WidgetModel
    
    var body: some View {
        FitScreen(referencedWidth: 155) { factor in
            Image("wechatScan")
                .resizable()
                .frame(width: 155*factor, height: 155*smallRatio*factor)
                .changeBorder(model: model)
                .ifdo(!AppData.activateLink, transform: { view in
                    view.cornerRadius(defaultCornerRadius*factor, corners: .allCorners)
                })
                .widgetURL(URL(string: "weixin://scanqrcode")!)
        }
    }
}

struct WeChatScanSmall_Previews: PreviewProvider {
    static var previews: some View {
        WeChatScanSmall(model: WidgetModel(id: .WeChatScanSmall,style: WidgetStyle(border: .border2)))
            .frame(width: 155, height: 155)
    }
}
