//
//  WeiBoReSouMediumTwo.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/16.
//

import SwiftUI
import SwiftUITools

struct WeiBoReSouMediumTwo: View {
    @ObservedObject var model: WidgetModel
    let originalBackground: Color = .white
    let titleColor: Color = Color(hex: "#444444FF")!
    let textColor = Color(hex: "#171717FF")!
    let timeColor = Color(hex: "#767676FF")!
    let hour = Calendar.current.component(.hour, from: Date())
    let minute = Calendar.current.component(.minute, from: Date())
    let time: String = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }()
    
    var body: some View {
        FitScreen(referencedWidth: 329) { factor in
            ZStack {
                Rectangle()
                    .ifdo(!AppData.activateLink, transform: { view in
                        view.cornerRadius(defaultCornerRadius*factor, corners: .allCorners)
                    })
                    .changeBackgroundColor(model: model, originalColor: originalBackground)
                    .changeBorder(model: model)
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
                            .changeFont(model: model, originalFont: defaultFont, fontSize: 10*factor)
                            .changeTextColor(model: model, originalColor: timeColor)
                    }
                    if let resouS = AppData.shared.reSouModel?.data {
                        let resouS1  = resouS.filter {$0.rank <= 5}
                        let resouS2  = resouS.filter {$0.rank > 5 && $0.rank < 10}
                        HStack(spacing: 14.0*factor) {
                            reSouItems(reSouItems: resouS1, factor: factor, more: false)
                            reSouItems(reSouItems: resouS2, factor: factor, more: true)
                        }
                        .padding(.top, 10*factor)
                        .padding([.leading, .trailing], 20*factor)
                    }
                }
            }
            .clickToDetailView(model: model)
        }
    }
    
    func reSouItems(reSouItems: [ReSouItemModel], factor: CGFloat, more: Bool) -> some View {
        VStack(alignment: .leading, spacing: 10.0*factor) {
            ForEach(reSouItems, id: \.rank) { resou in
                HStack(spacing: 0) {
                    Text("\(resou.rank)" + "  " + resou.keyword)
                        .lineLimit(1)
                        .changeFont(model: model, originalFont: defaultFont, fontSize: 10*factor)
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
            if more {
                Text("更多热搜 >>")
                    .foregroundColor(Color(hex: "#FE8201FF"))
                    .changeFont(model: model, originalFont: defaultFont, fontSize: 10*factor)
                    .changeLink(linkUrl: URL(string: weiBoReSouHomeURL)!)
            }
        }
    }
}

struct WeiBoReSouMediumTwo_Previews: PreviewProvider {
    static var previews: some View {
        WeiBoReSouMediumTwo(model: WidgetModel(id: .WeiBoReSouMediumTwo, style: WidgetStyle(backgroud: "ffffff", border: .border4)))
            .frame(width: 329, height: 155)
            .frame(width: 66, height: 33)
    }
}
