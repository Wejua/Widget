//
//  WidgetSettingView.swift
//  HotWidget
//
//  Created by 周位杰 on 2022/12/11.
//

import SwiftUI
import SwiftUITools

struct WidgetDetailView: View {
    enum Style {
        case background
        case textFont
        case textColor
        case border
        case mianBanXiangQing//面板详情
        case adcCode
        case muBiaoBuShu     //目标步数
        case biaoPanYangShi  //表盘样式
    }
    
    @StateObject var model: WidgetModel
    @State var authorizationFail: Bool = false
    @State var showAlert: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(hex: "#303234")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                widget
                    .environmentObject(model)
                
                settingsView
                    .environmentObject(model)
                
                WidgetDetailApplyButton(showAlert: $showAlert)
                    .environmentObject(model)
            }
            .navigationTitle(model.name ?? "")
            .background(Color(hex: "#303234"))
            .edgesIgnoringSafeArea([.bottom])
        }
        .onAppear {
            switch model.id.category {
            case .dashboard, .weather:
                Task {
                    do {
                        let _ = try await AppData.shared.fetchWeather()
                    } catch {
                        if error is LocationAuthorizationError {
                            self.authorizationFail = true
                        }
                    }
                    let distance = try await getWalkingRunningDistance()
                    AppData.shared.runningDistance = distance
                }
            default:
                break
            }
        }
        .toast(message: "您没有授权定位，无法为您提供区域天气数据", isShowing: $authorizationFail, duration: 4)
        .toast(message: "提示添加成功，赶快去我的组建中设置吧！", isShowing: $showAlert, duration: 4)
    }
    
    var widget: some View {
        ZStack(alignment: .center) {
            if (model.family == .large) {
                widgetView()
                    .frame(width: 260, height: 260/largeRatio)
            } else if (model.family == .medium) {
                widgetView()
                    .frame(width: 329, height: 329/mediumRatio)
            } else {
                widgetView()
                    .frame(width: 155, height: 155.0/smallRatio)
            }
        }
        .frame(height: 300)
    }
    
    @ViewBuilder func widgetView() -> some View {
        switch model.id {
        case .DefaultWidgetSmall: DefaultWidgetSmall()
        case .DefaultWidgetMedium: DefaultWidgetMedium()
        case .DefaultWidgetLarge: DefaultWidgetLarge()
        case .CalendarSmallOne: CalendarSmallOne(model: model)
        case .CalendarSmallTwo: CalendarSmallTwo(model: model)
        case .CalendarMediumOne: CalendarMediumOne(model: model)
        case .CalendarMediumTwo: CalendarMediumOne(model: model)
        case .CalendarLargeOne: CalendarLargeOne(model: model)
        case .CalendarLargeTwo: CalendarLargeOne(model: model)
        case .ShortCutsLargeOne: ShortCutsLargeOne(model: model)
        case .WeChatScanSmall: WeChatScanSmall(model: model)
        case .ShortCutsMediumOne: ShortCutsMediumOne(model: model)
        case .WeiBoReSouSmallOne: WeiBoReSouSmallOne(model: model)
        case .WeiBoReSouSmallTwo: WeiBoReSouSmallTwo(model: model)
        case .WeiBoReSouMediumOne: WeiBoReSouMediumOne(model: model)
        case .WeiBoReSouMediumTwo: WeiBoReSouMediumTwo(model: model)
        case .WeiBoReSouLargeOne: WeiBoReSouLargeOne(model: model)
        case .DashBoardSmallOne: DashBoardSmallOne(model: model, date: Date())
        case .DashBoardSmallTwo: DashBoardSmallTwo(model: model, date: Date())
        case .DashBoardSmallThree: DashBoardSmallThree(model: model, date: Date())
        case .DashBoardMediumOne: DashBoardSmallOne(model: model, date: Date())
        case .DashBoardMediumTwo: DashBoardMediumTwo(model: model, date: Date())
        case .DashBoardMediumThree: DashBoardMediumThree(model: model, date: Date())
        case .DashBoardLargeOne: DashBoardSmallOne(model: model, date: Date())
        case .DashBoardLargeTwo: DashBoardLargeTwo(model: model, date: Date())
        case .DashBoardLargeThree: DashBoardLargeThree(model: model, date: Date())
        case .WeatherSmallOne: WeatherSmallOne(model: model)
        case .WeatherMediumOne: WeatherMediumOne(model: model, date: Date())
        case .WeatherLargeOne: WeatherLargeOne(model: model, date: Date())
        case .DigitalClockSmallOne: DigitalClockSmallOne(model: model, date: Date())
        case .DigitalClockMediumOne: DigitalClockMediumOne(model: model, date: Date())
        case .DigitalClockLargeOne: DigitalClockLargeOne(model: model, date: Date())
        case .ClockSmallOne: ClockSmallOne(date: Date(), model: model)
        case .ClockMediumOne: ClockMediumOne(date: Date(), model: model)
        case .ClockLargeOne: ClockLargeOne(date: Date(), model: model)
        case .ControlPanelSmallOne: ControlPanelSmallOne(date: Date(), model: model)
        case .ControlPanelMediumOne: ControlPanelMediumOne(date: Date(), model: model)
        case .ControlPanelLargeOne: ControlPanelLargeOne(date: Date(), model: model)
        }
    }
    
    var settingsView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 26) {
                if model.id != .WeChatScanSmall {
                    if model.id.category == .weather || model.id.category == .dashboard {
                        WidgetDetailLocation()
                    }
                    WidgetDetailBackgroundColors()
                    WidgetDetailTextColors()
                    WidgetDetailTextFonts()
                }
                WidgetDetailBorders()
            }
            .padding([.top], 26)
        }
        .background(Color(hex: "#111419"))
        .cornerRadius(30, corners: [.topLeft, .topRight])
    }
}

struct WidgetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetDetailView(model: WidgetModel(id: .CalendarSmallOne), authorizationFail: true, showAlert: true)
            .previewDevice(.init(rawValue: "iPhone 11 Pro"))
    }
}

