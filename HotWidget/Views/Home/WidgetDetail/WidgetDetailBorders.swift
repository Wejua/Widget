//
//  WidgetDetailBorders.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/2.
//

import SwiftUI
import SwiftUITools

func noneStyleButton(action: @escaping () -> Void) -> some View  {
    Button {
        action()
    } label: {
        Color(hex: "#303234")
            .frame(width: 70, height: 30)
            .cornerRadius(8, corners: .allCorners)
            .overlay {
                HStack(spacing: 5) {
                    Image("clearstyle")
                    Text("无")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
                .padding(5)
            }
    }
}

func albumButton(action: @escaping () -> Void) -> some View {
    Button {
        action()
    } label: {
        Color(hex: "#303234")
            .frame(width: 70, height: 30)
            .cornerRadius(8, corners: .allCorners)
            .overlay {
                HStack(spacing: 5) {
                    Image("getimagefromsystemlibrary")
                    Text("相册")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
                .padding(5)
            }
    }

}

struct WidgetDetailBorders: View {
    
    @EnvironmentObject var model: WidgetModel
    @State var albumBorderImage: UIImage?
    @State var showPhotoLibrary: Bool = false
    @State var showImageClipView: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("边框")
                .font(.system(size: 14))
                .padding(.leading, 20)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 16) {
                    ForEach(BorderType.allCases, id: \.self) { type in
                        if type == .none {
                            noneStyleButton {model.style.border = type}
                        } else if type == .album {
                            albumButton {
                                model.style.border = type
                                showPhotoLibrary.toggle()
                            }
                        } else {
                            borderButton(type: type)
                        }
                    }
                }
                .padding(.leading, 20)
            }
        }
        .fullScreenCover(isPresented: $showPhotoLibrary) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $albumBorderImage)
        }
        .onChange(of: albumBorderImage, perform: { value in
            if value != nil {
                showImageClipView = true
            }
        })
        .fullScreenCover(isPresented: $showImageClipView, content: {
            if let image = albumBorderImage {
                ClipImageView(image: image, model: model, isBorder: true)
            }
        })
    }
    
    private func borderButton(type: BorderType) -> some View {
        Button {
            model.style.border = type
        } label: {
            image(borderType: type, family: .small)!
                .resizable()
                .frame(width: 30, height: 30)
                .padding([.top, .bottom, .leading, .trailing], 3)
                .ifdo(type == model.style.border) { view in
                    view.overlay {
                        RoundedRectangle(cornerRadius: 6, style: .circular)
                            .inset(by: 1)
                            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
                            .foregroundLinearGradient(colors: ["#91F036FF".color!, "#2CE2EEFF".color!], startPoint: .leading, endPoint: .trailing)
                    }
                }
        }
    }
}

struct WidgetDetailBorders_Previews: PreviewProvider {
    @StateObject static var model: WidgetModel = WidgetModel(id: .CalendarLargeOne, name: "name", icon: nil, is_free: nil, style: nil)
    
    static var previews: some View {
        WidgetDetailBorders()
            .environmentObject(model)
    }
}
