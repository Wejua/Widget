//
//  DefaultWidgetSmall.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/2/26.
//

import SwiftUI
import WidgetKit

struct DefaultWidgetSmall: View {
    
    var body: some View {
        GeometryReader { geo in
            let factor = geo.size.width/155.0
            ZStack {
                Color(hex: "#303234")
                    .cornerRadius(20*factor)
                
                VStack(spacing: 10.0*factor) {
                    
                    VStack(spacing: 6.0*factor) {
                        Color(hex: "#D8D8D8")
                            .frame(width: 30.0*factor, height: 30.0*factor)
                            .cornerRadius(5*factor)
                        
                        Text("APP名字")
                            .font(.system(size: 16*factor))
                            .foregroundColor(.white)
                            .minimumScaleFactor(0.5)
                    }
                    
                    VStack(alignment: .leading, spacing: 6*factor) {
                        Text("1.长按进入编辑模式")
                            .foregroundColor(.white)
                            .font(.system(size: 13*factor))
                            .scaledToFit()
                            .minimumScaleFactor(0.5)
                        Text("2.点击编辑小组件")
                            .foregroundColor(.white)
                            .font(.system(size: 13*factor))
                            .scaledToFit()
                            .minimumScaleFactor(0.5)
                        Text("3.选择所需小组件类型")
                            .foregroundColor(.white)
                            .font(.system(size: 13*factor))
                            .minimumScaleFactor(0.5)
                    }
                }
                .padding(15*factor)
            }
        }
    }
    
    
}



struct DefaultWidgetSmall_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DefaultWidgetSmall()
                .previewContext(WidgetPreviewContext(family: .systemSmall))
//                .previewDevice(PreviewDevice(rawValue: "iPhone 5s"))
//            .previewDisplayName("iPhone 5s")
            
//            DefaultWidget()
//                .previewContext(WidgetPreviewContext(family: .systemSmall))
//                .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
//                .previewDisplayName("iPhone 14 Pro Max")
        }
    }
}





