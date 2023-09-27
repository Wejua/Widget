//
//  ClockMediumOne.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/6/3.
//

import SwiftUI
import SwiftUITools

struct ClockMediumOne: View {
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
                    .changeBackgroundColor(model: model, image: Image("shizhong_bjMedium\(model.style.biaoPanYangShi ?? "1")"))
                    .ifdo(!AppData.activateLink, transform: { view in
                        view.cornerRadius(defaultCornerRadius*factor, corners: .allCorners)
                    })
                    .changeBorder(model: model)
                    .overlay(alignment: .leading) {
                        HStack(spacing: 17*factor) {
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
                            .padding(.leading, 5*factor)
                            VStack(alignment: .leading, spacing: 3*factor) {
                                Text("\(date.month)月\(date.day)日")
                                    .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 30*factor, lineLi: 1)
                                    .minimumScaleFactor(0.3)
                                Text("农历\(date.chineseMonthString)\(date.chineseDayString) 周\(date.chineseWeekString)")
                                    .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 14*factor, lineLi: 1)
                            }
                        }
                    }
            }
            .clickToDetailView(model: model)
        }
    }
    
//    func biaoPanYangshiIamge(model: WidgetModel) -> (bg: String, biaoPan: String, hour: String, minute: String)? {
//        switch model.style.biaoPanYangShi {
//        case "1": return ("shizhong_biaopan1", "shizhong_hour1", "shizhong_minute1")
//        case "2": return ("shizhong_biaopan2", "shizhong_hour2", "shizhong_minute2")
//        case "3": return ("shizhong_biaopan3", "shizhong_hour3", "shizhong_minute3")
//        case "4": return ("shizhong_biaopan4", "shizhong_hour4", "shizhong_minute4")
//        default: return nil
//        }
//    }
}

struct ClockMediumOne_Previews: PreviewProvider {
    static var previews: some View {
        ClockMediumOne(date: Date(), model: WidgetModel(id: .ClockMediumOne))
            .frame(width: 329, height: 155)
    }
}
