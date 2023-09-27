//
//  DefaultWidgetLarge.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/16.
//

import SwiftUI

struct DefaultWidgetLarge: View {
    var body: some View {
        GeometryReader { geo in
            let factor = geo.size.width/329.0
            ZStack {
                Color(hex: "#303234")
                    .cornerRadius(14*factor)
                
                VStack(spacing: 15*factor) {
                    VStack(spacing: 10*factor) {
                        Color(hex: "#D8D8D8")
                            .frame(width: 50*factor, height: 50*factor)
                            .cornerRadius(5*factor)
                        
                        Text("APP名字")
                            .font(.system(size: 18*factor))
                            .foregroundColor(.white)
                            .minimumScaleFactor(0.5)
                    }
                    
                    VStack(alignment: .leading, spacing: 8*factor) {
                        Text("1.长按进入编辑模式")
                            .foregroundColor(.white)
                            .font(.system(size: 16*factor))
                            .minimumScaleFactor(0.5)
                        Text("2.点击编辑小组件")
                            .foregroundColor(.white)
                            .font(.system(size: 16*factor))
                            .minimumScaleFactor(0.5)
                        Text("3.选择所需小组件类型")
                            .foregroundColor(.white)
                            .font(.system(size: 16*factor))
                            .minimumScaleFactor(0.5)
                    }
                }
            }
        }
        
    }
}

struct DefaultWidgetLarge_Previews: PreviewProvider {
    static var previews: some View {
        DefaultWidgetLarge()
    }
}
