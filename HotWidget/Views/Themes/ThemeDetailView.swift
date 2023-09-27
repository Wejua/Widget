//
//  ThemeDetailView.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/5/23.
//

import SwiftUI

struct ThemeDetailView: View {
    var images: [UIImage?] = [UIImage(named: "jpg1.jpg"), UIImage(named: "jpg2.jpg"), UIImage(named: "jpg3.jpg"), UIImage(named: "jpg4.jpg")]
    
    var body: some View {
        VStack(spacing: 0) {
            backgroundsView()
            iconsView()
        }
        .topSafeAreaColor(color: primaryColor)
        .inlineNavigationTitle(title: Text("主题详情"))
        .customBackView {
            Image("popbackImage")
        }
    }
    
    @ViewBuilder private func iconsView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("该图标包含以下78个APP")
                .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 14, lineLi: nil)
                .padding(15)
            let grids = [GridItem](repeating: GridItem(.flexible(minimum: 60)), count: 4)
            ScrollView {
                LazyVGrid(columns: grids) {
                    ForEach(0..<78, id: \.self) { _ in
                        VStack(spacing: 5) {
                            RoundedRectangle(cornerRadius: 13, style: .circular)
                                .fill("#C3C2AB".color!)
                                .frame(width: 60, height: 60)
                            Text("Widget")
                                .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 12, lineLi: nil)
                        }
                    }
                }
            }
            HStack(spacing: 15) {
                NavigationLink {
                    ThemePicturesView()
                } label: {
                    Capsule(style: .circular)
                        .fill(.linearGradient(colors: buttonColors, startPoint: .leading, endPoint: .trailing))
                        .frame(height: 44)
                        .overlay {
                            Text("下载主题图片")
                                .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 16, lineLi: nil)
                        }
                }

                NavigationLink {
                    ThemeAppIconsView()
                } label: {
                    Capsule(style: .circular)
                        .fill(.linearGradient(colors: buttonColors, startPoint: .leading, endPoint: .trailing))
                        .frame(height: 44)
                        .overlay {
                            Text("安装图标")
                                .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 16, lineLi: nil)
                        }
                }
            }
            .padding(15)
        }
    }
    
    @ViewBuilder private func backgroundsView() -> some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 15) {
                ForEach(images, id: \.self) { image in
                    if let image = image {
                        Image(uiImage: image)
                            .resizable().scaledToFit()
                            .cornerRadius(defaultCornerRadius)
                    }
                }
            }
            .padding(15)
        }
        .frame(height: 415)
        .background(primaryColor)
    }
}

struct ThemeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeDetailView()
    }
}
