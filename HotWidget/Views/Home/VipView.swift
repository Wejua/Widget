//
//  VipView.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/5/23.
//

import SwiftUI
import SwiftUITools

let vipGradient = LinearGradient(colors: vipGradientColors, startPoint: .leading, endPoint: .trailing)
let vipGradientColors = ["#FFE0B6".color!, "#E2B57A".color!]
 
struct VipView: View {
    private var widgetModels: [WidgetModel] = [
        WidgetModel(id: .CalendarLargeOne, name: nil, icon: nil, is_free: nil, style: nil),
        WidgetModel(id: .CalendarMediumOne, name: nil, icon: nil, is_free: nil, style: nil),
        WidgetModel(id: .CalendarSmallOne, name: nil, icon: nil, is_free: nil, style: nil),
        WidgetModel(id: .WeiBoReSouLargeOne, name: nil, icon: nil, is_free: nil, style: nil),
        WidgetModel(id: .DashBoardLargeOne, name: nil, icon: nil, is_free: nil, style: nil),
        WidgetModel(id: .DashBoardMediumThree, name: nil, icon: nil, is_free: nil, style: nil),
        WidgetModel(id: .DashBoardSmallOne, name: nil, icon: nil, is_free: nil, style: nil),
    ]
    private var isVip: Bool = false
    @State private var currentPriceIndex: Int = 0
    let caption = """
确认订阅时，费用将从您的iTunes账号扣除，订阅将会自动以订阅时的价格续订，除非在当前订阅期结束至少24小时以前关闭自动续订功能。
您可以前往【设置】>【您的名字】>【iTunes与AppStore】，选择屏幕顶部的Apple ID，来管理您的订阅
"""
    let privacy = """
开通前阅读《用户协议》及《隐私政策》
自动续订，可随时取消
"""
    
    var body: some View {
        VStack(spacing: 0) {
            widgetsScrollView()
            
            let title = isVip ? "开通超级会员" : "会员到期时间：2021-03-04"
            Text(title)
                .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 16, lineLi: nil)
                .padding(.top, 5)
            
            privilegesView()
            
            pricesView()
            
            confirmButton()
            
            Text(caption)
                .textSett(color: captionColor, FName: .PingFangSCRegular, Fsize: 12, lineLi: nil)
                .padding([.leading, .trailing], 15)
                .padding(.top, 10)
            
            Text("恢复购买记录")
                .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 14, lineLi: nil)
                .underline(pattern: .solid)
                .padding(.top, 20)
            
            Text(privacy)
                .textSett(color: captionColor, FName: .PingFangSCRegular, Fsize: 12, lineLi: nil)
                .multilineTextAlignment(.center)
                .padding(.top, 25)
            
            Spacer(minLength: 0)
        }
        .background(primaryColor)
        .customBackView {
            Image("popbackImage")
                .inlineNavigationTitle(title: Text("开通会员"))
        }
    }
    
    @ViewBuilder private func confirmButton() -> some View {
        Capsule()
            .fill(vipGradient)
            .frame(height: 50)
            .overlay {
                Text(isVip ? "立即续期" : "立即订阅")
                    .textSett(color: primaryColor, FName: .PingFangSCMedium, Fsize: 16, lineLi: nil)
            }
            .padding([.leading, .trailing], 25)
            .padding(.top, 15)
    }
    
    @ViewBuilder private func pricesView() -> some View {
        let contents: [(title: String, price: Int, detail: String)] = [
            ("月会员", 48, "尝鲜体验价"),
            ("季会员", 98, "50%用户选择"),
            ("月会员", 198, "超值性价比"),
        ]
        let spacing = 15.0
        HStack(spacing: spacing) {
            let screenW = UIScreen.main.bounds.width
            let width = (screenW - spacing*4.0)/3.0
            let height = width/105.0*114.0
            ForEach(0..<3, id: \.self) { index in
                VStack(spacing: 0) {
                    Text(contents[index].title)
                        .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 14, lineLi: nil)
                        .ifdo(currentPriceIndex == index) { view in
                            view
                                .bold()
                                .foregroundLinearGradient(colors: vipGradientColors, startPoint: .leading, endPoint: .trailing)
                        }
                    HStack(alignment:.firstTextBaseline, spacing: 0) {
                        Text("￥")
                            .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 14, lineLi: nil)
                        Text("\(contents[index].price)")
                            .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 26, lineLi: nil)
                    }
                    .ifdo(currentPriceIndex == index) { view in
                        view
                            .bold()
                            .foregroundLinearGradient(colors: vipGradientColors, startPoint: .leading, endPoint: .trailing)
                    }
                    Text(contents[index].detail)
                        .textSett(color: captionColor, FName: .PingFangSCRegular, Fsize: 12, lineLi: nil)
                }
                .frame(width: width, height: height)
                .overlay {
                    RoundedRectangle(cornerRadius: 10, style: .circular)
                        .stroke(captionColor, style: StrokeStyle(lineWidth: 1))
                        .ifdo(currentPriceIndex == index, transform: { view in
                            view.foregroundStyle(vipGradient)
                        })
                }
            }
        }
        .padding(.top, 20)
    }
    
    @ViewBuilder private func privilegesView() -> some View {
        HStack(spacing: 0) {
            Spacer()
            VStack(spacing: 10) {
                Image("vipView_wuxian")
                Text("组件无限使用")
                    .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 14, lineLi: nil)
            }
            Spacer()
            VStack(spacing: 10) {
                Image("vipView_suixinhuan")
                Text("图标随心换")
                    .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 14, lineLi: nil)
            }
            Spacer()
            VStack(spacing: 10) {
                Image("vipView_wuguanggao")
                Text("纯净无广告")
                    .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 14, lineLi: nil)
            }
            Spacer()
        }
        .padding(.top, 15)
    }
    
    @ViewBuilder private func widgetsScrollView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 15) {
                ForEach(widgetModels, id: \.id) { model in
                    let size = sizeWithFamily(family: model.family)
                    widgetViewWithModel(model: model)
                        .frame(width: size.width, height: size.height)
                }
            }
            .frame(height: 155)
            .padding(15)
        }
    }
    
    private func sizeWithFamily(family: Family) -> CGSize {
        switch family {
        case .large: return CGSize(width: 155*largeRatio, height: 155)
        case .medium, .small: return family.defaultSize()
        }
    }
}

struct VipView_Previews: PreviewProvider {
    static var previews: some View {
        VipView()
    }
}
