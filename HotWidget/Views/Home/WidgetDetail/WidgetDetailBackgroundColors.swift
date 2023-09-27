//
//  WidgetDetailBackgroundColors.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/2.
//

import SwiftUI
import SwiftUITools

struct WidgetDetailBackgroundColors: View {
    
    private var colors: [String] {
        [
            "#FFE0F6FF",
            "#FFABA9FF",
            "#FFD3AAFF",
            "#FDF1D3FF",
            "#DBF5D6FF",
            "#CDF7EBFF",
            "#CEE3FDFF",
            "#BFBCFBFF",
            "#E4B9F2FF",
            "#EBEBEBFF",
        ]
    }
    
    @EnvironmentObject var model: WidgetModel
    @State var albumBackgroundImage: UIImage?
    @State var showPhotoLibrary: Bool = false
    @State var showImageClipView: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("背景")
                .font(.system(size: 14))
                .padding(.leading, 20)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    noneButton
                    albumButton
                    ForEach(colors, id: \.hashValue) { color in
                        Button {
                            model.style.background = color
                        } label: {
                            Circle()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color(hex: color))
                                .overlay(alignment: .center, content: {
                                    if color == model.style.background {
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
        .fullScreenCover(isPresented: $showPhotoLibrary) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $albumBackgroundImage)
        }
        .fullScreenCover(isPresented: $showImageClipView, content: {
            if let image = albumBackgroundImage {
                let _ = model.style.background = "clear"
                ClipImageView(image: image, model: model, isBorder: false)
            }
        })
        .onChange(of: albumBackgroundImage, perform: { value in
            if value != nil {
                showImageClipView = true
            }
        })
    }
    
    private var albumButton: some View {
        Button {
            showPhotoLibrary.toggle()
        } label: {
            Color(hex: "#303234")
                .frame(width: 70, height: 30)
                .cornerRadius(8, corners: .allCorners)
                .overlay {
                    HStack(spacing: 5) {
                        Image("getimagefromsystemlibrary")
                            .frame(width: 14, height: 14)
                            .cornerRadius(7, corners: .allCorners)
                        Text("相册")
                            .foregroundColor(Color(hex: "#FFFFFF"))
                            .font(.system(size: 12))
                    }
                }
        }
    }
    
    private var noneButton: some View {
        Button {
            model.style.background = nil
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

struct WidgetDetailBackgroundColors_Previews: PreviewProvider {
    @StateObject static var model: WidgetModel = WidgetModel(id: .CalendarLargeOne, name: "name", icon: nil, is_free: nil, style: nil)
    
    static var previews: some View {
        WidgetDetailBackgroundColors()
            .environmentObject(model)
    }
}
