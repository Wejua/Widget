//
//  ThemeHome.swift
//  HotWidget
//
//  Created by 周位杰 on 2022/12/10.
//

import SwiftUI

struct ThemeHome: View {
    private var images: [UIImage?] = [UIImage(named: "jpg1.jpg"), UIImage(named: "jpg2.jpg"), UIImage(named: "jpg3.jpg"), UIImage(named: "jpg4.jpg")]
    
    var body: some View {
//        NavigationView {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 15) {
                    ForEach(images, id: \.self) { image in
                        if let image = image {
                            NavigationLink {
                                ThemeDetailView()
                            } label: {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(defaultCornerRadius)
                            }
                        }
                    }
                }
                .padding([.leading, .trailing], 15)
            }
            .background(primaryColor)
            .topSafeAreaColor(color: .black)
            .bottomSafeAreaColor(color: .black)
            .inlineNavigationTitle(title: Text("主题"))
//        }
    }
}

struct ThemeHome_Previews: PreviewProvider {
    static var previews: some View {
        ThemeHome()
    }
}
