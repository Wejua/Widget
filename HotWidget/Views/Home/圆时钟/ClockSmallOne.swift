//
//  ClockSmallOne.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/6/2.
//

import SwiftUI
import SwiftUITools
import WidgetKit

struct ClockSmallOne: View {
    var date: Date
    @ObservedObject var model: WidgetModel
    
    var body: some View {
        FitScreenMin(reference: 155) { factor, geo in
            ZStack {
                let minuteH = 46*factor
                let hourW = 36*factor
                let hourDegree = 30.0*Double(date.hour)+Double(date.minute)*0.5
                let minuteDegree = 6.0*Double(date.minute)
                Rectangle()
                    .changeBackgroundColor(model: model, image: Image("shizhong_beijing\(model.style.biaoPanYangShi ?? "1")"))
                    .ifdo(!AppData.activateLink, transform: { view in
                        view.cornerRadius(defaultCornerRadius*factor, corners: .allCorners)
                    })
                    .changeBorder(model: model)
                    .overlay {
                        ZStack {
                            Image("shizhong_biaopan\(model.style.biaoPanYangShi ?? "1")").resizable().scaledToFit()
                            Image("shizhong_hour\(model.style.biaoPanYangShi ?? "1")").resizable().scaledToFit()
                                .frame(width: hourW)
                                .offset(x: hourW/2.0)
                                .rotationEffect(.degrees(-90))
                                .rotationEffect(.degrees(hourDegree))
                            Image("shizhong_minute\(model.style.biaoPanYangShi ?? "1")").resizable().scaledToFit()
                                .frame(height: minuteH)
                                .offset(y: -minuteH/2.0)
                                .rotationEffect(.degrees(minuteDegree))
                        }
                        .padding(10*factor)
                    }
            }
            .clickToDetailView(model: model)
        }
    }
}

struct ClockSmallOne_Previews: PreviewProvider {
    static var previews: some View {
        ClockSmallOne(date: Date(), model: WidgetModel(id: .ClockSmallOne))
            .frame(width: 155, height: 155)
            .background(.gray)
    }
}
