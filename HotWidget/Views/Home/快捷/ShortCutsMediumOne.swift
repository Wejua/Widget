//
//  ShortCutsMediumOne.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/16.
//

import SwiftUI
import SwiftUITools

struct ShortCutsMediumOne: View {
    @ObservedObject var model: WidgetModel
    let backgroundColor: Color = .white
    
    var body: some View {
        FitScreen(referencedWidth: 329) { factor in
            ZStack {
                Rectangle()
                    .ifdo(!AppData.activateLink, transform: { view in
                        view.cornerRadius(defaultCornerRadius*factor, corners: .allCorners)
                    })
                    .changeBackgroundColor(model: model, originalColor: backgroundColor)
                    .changeBorder(model: model)
                VStack(spacing: 10*factor) {
                    HStack(spacing: 10*factor) {
                        Image("wechatScanMedium")
                            .resizable()
                            .frame(width: 150*factor, height: 62*factor)
                            .overlay(content: {
                                Text("微信扫一扫")
                                    .padding(.top, 10*factor)
                                    .changeFont(model: model, originalFont: defaultFont, fontSize: 14*factor)
                                    .changeTextColor(model: model, originalColor: .white)
                            })
                            .changeLink(linkUrl: URL(string: "weixin://scanqrcode")!)
                        Image("aliScanMedium")
                            .resizable()
                            .frame(width: 150*factor, height: 62*factor)
                            .overlay(content: {
                                Text("支付宝扫一扫")
                                    .padding(.top, 10*factor)
                                    .changeFont(model: model, originalFont: defaultFont, fontSize: 14*factor)
                                    .changeTextColor(model: model, originalColor: .white)
                            })
                            .changeLink(linkUrl: URL(string: "alipayqr://platformapi/startapp?saId=10000007")!)
                    }
                    HStack(spacing: 10*factor) {
                        Image("alicodeMedium")
                            .resizable()
                            .frame(width: 150*factor, height: 62*factor)
                            .overlay(content: {
                                Text("支付宝付款码")
                                    .padding(.top, 10*factor)
                                    .changeFont(model: model, originalFont: defaultFont, fontSize: 14*factor)
                                    .changeTextColor(model: model, originalColor: .white)
                            })
                            .changeLink(linkUrl: URL(string: "alipay://platformapi/startapp?appId=20000056")!)
                        Image("alicodeMedium")
                            .resizable()
                            .frame(width: 150*factor, height: 62*factor)
                            .overlay(content: {
                                Text("支付宝乘车码")
                                    .padding(.top, 10*factor)
                                    .changeFont(model: model, originalFont: defaultFont, fontSize: 14*factor)
                                    .changeTextColor(model: model, originalColor: .white)
                            })
                            .changeLink(linkUrl: URL(string: "alipayqr://platformapi/startapp?saId=200011235")!)
                    }
                }
            }
            .clickToDetailView(model: model)
        }
    }
}

struct ShortCutsMediumOne_Previews: PreviewProvider {
    static var previews: some View {
        ShortCutsMediumOne(model: WidgetModel(id: .ShortCutsMediumOne,style: WidgetStyle(border: .border4)))
            .frame(width: 329, height: 155)
    }
}
