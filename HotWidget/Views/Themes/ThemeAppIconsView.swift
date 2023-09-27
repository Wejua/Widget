//
//  ThemeAppIconsView.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/5/23.
//

import SwiftUI

struct ThemeAppIconsView: View {
    @State private var isSelectedAll: Bool = true
    
    var body: some View {
        ScrollView(showsIndicators: true) {
            let grids = [GridItem](repeating: GridItem(.flexible(), spacing: 0), count: 4)
            LazyVGrid(columns: grids, spacing: 16) {
                ForEach(0..<78, id: \.self) { _ in
                    ItemView(isSelectedAll: $isSelectedAll)
                }
            }
        }
        .inlineNavigationTitle(title: Text("主题图标"))
        .customBackView {
            Image("popbackImage")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                let title = isSelectedAll ? "取消全选" : "全选"
                Text(title)
                    .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 16, lineLi: nil)
                    .onTapGesture {
                        isSelectedAll.toggle()
                    }
            }
        }
        .safeAreaInset(edge: .bottom) {
            Capsule(style: .circular)
                .fill(.linearGradient(colors: buttonColors, startPoint: .leading, endPoint: .trailing))
                .frame(height: 44)
                .padding([.leading, .trailing], 25)
                .overlay {
                    Text("立即安装(20)")
                }
        }
    }
}

struct ItemView: View {
    @Binding var isSelectedAll: Bool
    @State private var isSelected: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 13)
                .fill("#C3C2AB".color!.opacity(0.7))
                .frame(width: 60, height: 60)
                .overlay(alignment:.topTrailing) {
                    let imageN = isSelected ? "appIconCheck" : "appIconUnCheck"
                    Image(imageN)
                        .padding([.top, .trailing], 5)
                }
                .onTapGesture {
                    isSelected.toggle()
                }
                .onChange(of: isSelectedAll) { newValue in
                    isSelected = newValue
                }
            Text("widget")
                .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 12, lineLi: nil)
        }
    }
}

struct ThemeAppIconsView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeAppIconsView()
    }
}
