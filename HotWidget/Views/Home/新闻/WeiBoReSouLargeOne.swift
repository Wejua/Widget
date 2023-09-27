//
//  WeiBoReSouLargeOne.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/16.
//

import SwiftUI
import SwiftUITools

struct WeiBoReSouLargeOne: View {
    @ObservedObject var model: WidgetModel
    let originalBackground: Color = .white
    let titleColor: Color = Color(hex: "#444444FF")!
    let textColor = Color(hex: "#171717FF")!
    let timeColor = Color(hex: "#767676FF")!
    let time: String = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }()
    
    var body: some View {
        FitScreen(referencedWidth: 329) { factor in
            ZStack {
                Rectangle()
                    .changeBorder(model: model)
                    .ifdo(!AppData.activateLink, transform: { view in
                        view.cornerRadius(defaultCornerRadius*factor, corners: .allCorners)
                    })
                    .changeBackgroundColor(model: model, originalColor: originalBackground)
                VStack(spacing: 0) {
                    HStack(spacing: 5*factor) {
                        Image("weiboresousmall")
                            .resizable()
                            .frame(width: 18*factor, height: 15*factor)
                            .padding(.leading, 20*factor)
                        Text("微博热搜")
                            .minimumScaleFactor(0.2)
                            .lineLimit(1)
                            .changeFont(model: model, originalFont: defaultFont, fontSize: 14*factor)
                            .changeTextColor(model: model, originalColor: titleColor)
                        Spacer()
                        Text(time)
                            .lineLimit(1)
                            .minimumScaleFactor(0.2)
                            .padding(.trailing, 20*factor)
                            .changeFont(model: model, originalFont: defaultFont, fontSize: 12*factor)
                            .changeTextColor(model: model, originalColor: timeColor)
                    }
                    VStack(alignment: .leading, spacing: 14.0*factor) {
                        if let resouS = AppData.shared.reSouModel?.data {
                            ForEach(0...9, id:\.self) {i in
                                let resou: ReSouItemModel = resouS[i]
                                HStack(spacing: 0) {
                                    Text("\(i+1) \(resou.keyword)")
                                    //                                    .minimumScaleFactor(0.2)
                                        .lineLimit(1)
                                        .changeFont(model: model, originalFont: defaultFont, fontSize: 12*factor)
                                        .changeTextColor(model: model, originalColor: textColor)
                                        .changeLink(linkUrl: URL(string: resou.url)!)
                                    Spacer()
                                    if resou.isNew {
                                        Image("resouxin")
                                            .resizable()
                                            .frame(width: 9*factor, height: 9*factor)
                                    } else if resou.isHot {
                                        Image("resoure")
                                            .resizable()
                                            .frame(width: 9*factor, height: 9*factor)
                                    } else if resou.isBoil  {
                                        Image("resoubao")
                                            .resizable()
                                            .frame(width: 9*factor, height: 9*factor)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top, 20*factor)
                    .padding([.leading, .trailing], 20*factor)
                }
            }
            .clickToDetailView(model: model)
        }
    }
}

struct WeiBoReSouLargeOne_Previews: PreviewProvider {
    static var previews: some View {
        WeiBoReSouLargeOne(model: WidgetModel(id:.WeiBoReSouLargeOne, style: WidgetStyle(backgroud: "ffffff", border: .border5)))
            .frame(width: 329, height: 345)
    }
}
