//
//  WeiBoReSouSmallTwo.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/16.
//

import SwiftUI
import SwiftUITools

struct WeiBoReSouSmallTwo: View {
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
        FitScreen(referencedWidth: 155) { factor in
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
                        Text("微博热搜")
                            .minimumScaleFactor(0.2)
                            .lineLimit(1)
                            .changeFont(model: model, originalFont: defaultFont, fontSize: 14*factor)
                            .changeTextColor(model: model, originalColor: titleColor)
                        Text(time)
                            .lineLimit(1)
                            .minimumScaleFactor(0.2)
                            .padding(.leading, 20*factor)
                            .changeFont(model: model, originalFont: defaultFont, fontSize: 10*factor)
                            .changeTextColor(model: model, originalColor: timeColor)
                    }
                    if let resouS = AppData.shared.reSouModel?.data.filter{$0.rank < 5} {
                        VStack(alignment: .leading, spacing: 14.0*factor) {
                            ForEach(resouS, id:\.rank) {resou in
                                reSouItem(resou: resou, factor: factor)
                            }
                        }
                        .padding(.top, 15*factor)
                        .padding([.leading, .trailing], 13*factor)
                    }
                }
            }
            .widgetURL(URL(string: weiBoReSouHomeURL))
        }
    }
    
    func reSouItem(resou: ReSouItemModel, factor: CGFloat) -> some View {
        HStack(spacing: 0) {
            Text("\(resou.rank) \(resou.keyword)")
                .lineLimit(1)
                .changeFont(model: model, originalFont: defaultFont, fontSize: 10*factor)
                .changeTextColor(model: model, originalColor: textColor)
            Spacer()
            if resou.isNew {
                Image("resouxin")
                    .resizable()
                    .frame(width: 9*factor, height: 9*factor)
                    .changeLink(linkUrl: URL(string: resou.url)!)
            } else if resou.isHot {
                Image("resoure")
                    .resizable()
                    .frame(width: 9*factor, height: 9*factor)
                    .changeLink(linkUrl: URL(string: resou.url)!)
            } else if resou.isBoil  {
                Image("resoubao")
                    .resizable()
                    .frame(width: 9*factor, height: 9*factor)
                    .changeLink(linkUrl: URL(string: resou.url)!)
            }
        }
    }
}

struct WeiBoReSouSmallTwo_Previews: PreviewProvider {
    static var previews: some View {
        WeiBoReSouSmallTwo(model: WidgetModel(id: .WeiBoReSouSmallTwo))
    }
}
