//
//  WidgetDetailTextColors.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/2.
//

import SwiftUI
import SwiftUITools

struct WidgetDetailTextColors: View {
    
    private var colors: [String] {
        [
            "#8F1E5DFF",
            "#800F0CFF",
            "#57531EFF",
            "#5C3109FF",
            "#135807FF",
            "#076576FF",
            "#002F89FF",
            "#47138AFF",
            "#8106A1FF",
            "#151515FF",
            "#F1F7FFFF"
        ]
    }
    
    @EnvironmentObject var model: WidgetModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("文字颜色")
                .font(.system(size: 14))
                .padding(.leading, 20)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
//                    noneButton
                    ForEach(colors, id: \.hashValue) { color in
                        Button {
                            model.style.textColor = color
                        } label: {
                            Circle()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color(hex: color))
                                .overlay(alignment: .center, content: {
                                    if color == model.style.textColor {
                                        Circle()
                                            .stroke(lineWidth: 3)
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(Color(hex: "#111419"))
                                    }
                                })
                        }
                    }
                }
                .padding(.leading, 20)
            }
        }
    }
    
    private var noneButton: some View {
        Button {
            
        } label: {
            Color(hex: "#303234")
                .frame(width: 70, height: 30)
                .cornerRadius(8, corners: .allCorners)
                .overlay {
                    HStack(spacing: 5) {
                        Image("clearstyle")
                            .frame(width: 14, height: 14)
                            .cornerRadius(7, corners: .allCorners)
                        Text("无")
                            .foregroundColor(Color(hex: "#FFFFFF"))
                            .font(.system(size: 12))
                    }
                }
        }
    }
}

struct WidgetDetailTextColors_Previews: PreviewProvider {
    @StateObject static var model: WidgetModel = WidgetModel(id: .CalendarLargeOne, name: "name", icon: nil, is_free: nil, style: nil)
    
    static var previews: some View {
        WidgetDetailTextColors()
            .environmentObject(model)
    }
}
