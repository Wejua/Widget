//
//  WeiBoReSouSmallOne.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/16.
//

import SwiftUI
import SwiftUITools

enum WeiBoReSouSmallType {
    case withoutImage
    case withImage
}

struct WeiBoReSouSmallOne: View {
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
                        view.cornerRadius(defaultCornerRadius*factor*0.9, corners: .allCorners)
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
                                Text("\(resou.rank) \(resou.keyword)")
                                    .lineLimit(1)
                                    .changeFont(model: model, originalFont: defaultFont, fontSize: 10*factor)
                                    .changeTextColor(model: model, originalColor: textColor)
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

}

struct WeiBoReSouSmallOne_Previews: PreviewProvider {
    static var previews: some View {
        WeiBoReSouSmallOne(model: WidgetModel(id: .WeiBoReSouSmallOne,style: WidgetStyle(border: .none)))
            .frame(width: 155, height: 155)
    }
}
