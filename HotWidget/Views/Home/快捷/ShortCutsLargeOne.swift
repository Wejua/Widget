//
//  ShortCutsLargeOne.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/13.
//

import SwiftUI
import WidgetKit
import SwiftUITools

struct ShortCutsLargeOne: View {
    @ObservedObject var model: WidgetModel
    let backgroundColor = Color.white
    
    var body: some View {
        FitScreen(referencedWidth: 222) { factor in
            ZStack {
                Rectangle()
                    .ifdo(!AppData.activateLink, transform: { view in
                        view.cornerRadius(defaultCornerRadius*factor, corners: .allCorners)
                    })
                    .changeBackgroundColor(model: model, originalColor: backgroundColor)
                    .changeBorder(model: model)
                VStack(spacing: 10*factor) {
                    HStack(spacing: 10*factor) {
                        Image("wechatScanLarge")
                            .resizable()
                            .frame(width: 97*factor, height: 101*factor)
                            .overlay(content: {
                                Text("微信扫一扫")
                                    .padding(.top, 52*factor)
                                    .changeFont(model: model, originalFont: defaultFont, fontSize: 12*factor)
                                    .changeTextColor(model: model, originalColor: .white)
                            })
                            .changeLink(linkUrl: URL(string: "weixin://scanqrcode")!)
                        Image("aliscanLarge")
                            .resizable()
                            .frame(width: 97*factor, height: 101*factor)
                            .overlay(content: {
                                Text("支付宝扫一扫")
                                    .padding(.top, 52*factor)
                                    .changeFont(model: model, originalFont: defaultFont, fontSize: 12*factor)
                                    .changeTextColor(model: model, originalColor: .white)
                            })
                            .changeLink(linkUrl: URL(string: "alipayqr://platformapi/startapp?saId=10000007")!)
                    }
                    HStack(spacing: 10*factor) {
                        Image("alicodeLarge")
                            .resizable()
                            .frame(width: 97*factor, height: 101*factor)
                            .overlay(content: {
                                Text("支付宝付款码")
                                    .padding(.top, 52*factor)
                                    .changeFont(model: model, originalFont: defaultFont, fontSize: 12*factor)
                                    .changeTextColor(model: model, originalColor: .white)
                            })
                            .changeLink(linkUrl: URL(string: "alipay://platformapi/startapp?appId=20000056")!)
                        Image("alicodeLarge")
                            .resizable()
                            .frame(width: 97*factor, height: 101*factor)
                            .overlay(content: {
                                Text("支付宝乘车码")
                                    .padding(.top, 52*factor)
                                    .changeFont(model: model, originalFont: defaultFont, fontSize: 12*factor)
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

struct ShortCutsLargeOne_Previews: PreviewProvider {
    static var previews: some View {
        ShortCutsLargeOne(model: WidgetModel(id: .ShortCutsLargeOne, style: WidgetStyle(backgroud: "228833", border: .border7)))
                    .frame(width: 329, height:345)
//            .previewContext(WidgetPreviewContext(family: .systemLarge))
        //        ShortCutsLargeOne(model: WidgetModel())
        //            .frame(width: 88, height:92)
        //            .environmentObject(WidgetModel())
    }
}
