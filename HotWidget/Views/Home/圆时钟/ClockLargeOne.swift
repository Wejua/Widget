//
//  ClockLargeOne.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/6/3.
//

import SwiftUI
import SwiftUITools

struct ClockLargeOne: View {
    var date: Date
    @ObservedObject var model: WidgetModel
    
    var body: some View {
        FitScreenMin(reference: 329) { factor, geo in
            ZStack {
                let minuteH = 66*factor
                let hourW = 52*factor
                let hourDegree = 30.0*Double(date.hour)+Double(date.minute)*0.5
                let minuteDegree = 6.0*Double(date.minute)
                Rectangle()
                    .changeBackgroundColor(model: model, image: Image("shizhong_beijing\(model.style.biaoPanYangShi ?? "1")"))
                    .ifdo(!AppData.activateLink, transform: { view in
                        view.cornerRadius(30*factor, corners: .allCorners)
                    })
                    .changeBorder(model: model)
                    .overlay(alignment: .top) {
                        VStack(spacing: 0*factor) {
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
                            .frame(width: 200*factor, height: 200*factor)
                            .padding(.top, 20*factor)
                            
                            Text("\(date.month)月\(date.day)日")
                                .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 30*factor, lineLi: 1)
                                .minimumScaleFactor(0.3)
                                .padding(.top, 25*factor)
                            Text("农历\(date.chineseMonthString)\(date.chineseDayString) 周\(date.chineseWeekString)")
                                .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 14*factor, lineLi: 1)
                                .padding(.top, 10*factor)
                        }
                    }
            }
            .clickToDetailView(model: model)
        }
    }
}

struct ClockLargeOne_Previews: PreviewProvider {
    static var previews: some View {
        ClockLargeOne(date: Date(), model: WidgetModel(id: .ClockLargeOne))
            .frame(width: 329, height: 345)
    }
}
