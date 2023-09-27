//
//  ThemePicturesView.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/5/23.
//

import SwiftUI

struct ThemePicturesView: View {
    private let strings: [String] = ["themePic1", "themePic2", "themePic3", "themePic4", "themePic5", "themePic6"]
    private var images: [UIImage] {
        strings.map{UIImage(named: $0)!}.sorted { image1, image2 in
            image1.size.height/image1.size.width < image2.size.height/image2.size.width
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                mediumImagesView()
                smallAndLargeImagesView()
            }
        }
        .inlineNavigationTitle(title: Text("主题图片"))
        .customBackView {
            Image("popbackImage")
        }
        .background(primaryColor)
        .safeAreaInset(edge: .bottom) {
            Capsule(style: .circular)
                .fill(.linearGradient(colors: buttonColors, startPoint: .leading, endPoint: .trailing))
                .frame(height: 44)
                .overlay(content: {
                    Text("下载主题图片")
                        .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 16, lineLi: nil)
                })
                .padding([.leading, .trailing], 25)
        }
    }
    
    @ViewBuilder private func mediumImagesView() -> some View {
        let spacing = 15.0
        let minWidth = (UIScreen.main.bounds.width - spacing * 2.0)
        let grids = [GridItem](repeating: GridItem(.fixed(minWidth), spacing: spacing), count: 1)
        let images = images.filter({ image in
            let ratio = image.size.height/image.size.width
            return ratio < 0.9
        })
        LazyVGrid(columns: grids,spacing: spacing) {
            ForEach(images, id: \.self) { image in
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
        }
        .padding([.top, .leading, .trailing], 15)
    }
    
    @ViewBuilder private func smallAndLargeImagesView() -> some View {
        let spacing = 15.0
        let minWidth = (UIScreen.main.bounds.width - spacing * 3.0)/2
        let grids = [GridItem](repeating: GridItem(.adaptive(minimum: minWidth), spacing: spacing), count: 1)
        let images = images.filter({ image in
            let ratio = image.size.height/image.size.width
            return ratio > 0.9
        })
        LazyVGrid(columns: grids,spacing: spacing) {
            ForEach(images, id: \.self) { image in
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
        }
        .padding(spacing)
    }
}

struct ThemePicturesView_Previews: PreviewProvider {
    static var previews: some View {
        ThemePicturesView()
    }
}
