//
//  WidgetDetailTextFonts.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/2.
//

import SwiftUI
import SwiftUITools

struct WidgetDetailTextFonts: View {
    
//    private var fonts: [String] { UIFont.familyNames }
    let fonts = ["Academy Engraved LET", "Apple SD Gothic Neo", "Arial", "Arial Rounded MT Bold", "Avenir Next", "Avenir Next Condensed",
    "Baskerville Bold", "Bodoni 72", "Bodoni 72 Oldstyle", "Bradley Hand", "Chalkboard SE", "Charter", "Cochin",
    "Copperplate", "Devanagari Sangam MN", "Didot", "DIN Alternate", "Gill Sans", "Hiragino Mincho ProN",
    "Impact", "Kefa", "Marker Felt", "PingFang HK", "PingFang SC", "Snell Roundhand", "Party LET", "Savoye LET"]
    
    @EnvironmentObject var model: WidgetModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("字体")
                .font(.system(size: 14))
                .padding(.leading, 20)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
//                    noneButton
                    ForEach(fonts, id: \.hashValue) { fontN in
                        Button {
                            model.style.textFont = fontN
                        } label: {
                            let text = Text("font")
                                .font(Font(UIFont(name: fontN, size: 18) ?? .systemFont(ofSize: 18)))
                                .foregroundColor(Color.white)
                                .frame(width: 45, height: 30, alignment: .center)
                            if (fontN == model.style.textFont) {
                                text
                                    .foregroundLinearGradient(colors: [Color(hex: "#2CE2EE")!, Color(hex: "#91F036")!], startPoint: .trailing, endPoint: .leading)
                            } else {
                                text
                            }
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

struct WidgetDetailTextFonts_Previews: PreviewProvider {
    @StateObject static var model: WidgetModel = WidgetModel(id: .CalendarLargeOne, name: "name", icon: nil, is_free: nil, style: nil)
    
    static var previews: some View {
        WidgetDetailTextFonts()
            .environmentObject(model)
    }
}
