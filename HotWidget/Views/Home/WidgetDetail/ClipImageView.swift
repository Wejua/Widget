//
//  ClipImageView.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/27.
//

import SwiftUI
import SwiftUITools

extension ClipImageView {
    struct ContentSizeKey: PreferenceKey {
        static var defaultValue: CGSize = .zero
        
        static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        }
    }
    
    struct ImageFrameKey: PreferenceKey {
        static var defaultValue: CGRect = .zero
        static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        }
    }
    
    struct WidgetFrameKey: PreferenceKey {
        static var defaultValue: CGRect = .zero
        static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        }
    }
}

struct ClipImageView: View {
    var image: UIImage
    var model: WidgetModel
    var isBorder: Bool
    @Environment(\.dismiss) var dismiss
    @State private var clippedImage: UIImage?
    
    @State var location: CGPoint = CGPoint(x: 150, y: 150)
    @GestureState var startLocation: CGPoint? = nil
    @GestureState var zoomState: ZoomState = .inactive
    @State var startScale: CGFloat = 1.0
    @State var minScale: CGFloat = 1.0
    @State var widgetFrame: CGRect = .zero
    @State var imageFrame: CGRect = .zero
    @State var contentSize: CGSize = .zero
    @State var rotationDegrees: Double = 0.0
    @State var minImageSize: CGSize = .zero
    @State var originalSize: CGSize = .zero
    
    enum ZoomState {
        case inactive
        case active(scale: CGFloat)
        
        var scale: CGFloat {
            switch self {
            case .inactive: return 1.0
            case .active(let scale): return scale
            }
        }
    }
    
    var scale: CGFloat {
        startScale * zoomState.scale
    }
    
    var widgetSize: CGSize {
        let screenSize = UIScreen.main.bounds.size
        let widgetSize = iosWidgetSize(screenSize: screenSize, family: model.family.familyValue())
        return widgetSize
    }
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 10)
            .updating($startLocation, body: { value, startLocation, transaction in
                startLocation = startLocation ?? location
            })
            .onChanged { value in
                let translation = value.translation
                var newLocation = startLocation ?? location
                newLocation.x += translation.width
                newLocation.y += translation.height
                self.location = newLocation
            }
            .onEnded { value in
                ajustLocation(imageSize: imageFrame.size)
            }
    }
    
    var magnificationGesture: some Gesture {
        MagnificationGesture()
            .updating($zoomState) { value, state, transaction in
                state = .active(scale: value)
            }
            .onEnded { value in
                startScale *= value
                ajustScale(imageSize: imageFrame.size)
            }
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(.black)
            
            ZStack {
                imageAndWidgetView()
                
                buttonsView()
            }
            .onChange(of: clippedImage) { image in
                if image != nil {
                    if isBorder {
                        AppData.shared.saveBorderImages(borders: ["\(model.id.rawValue)": image!])
                    } else {
                        AppData.shared.saveBackgroundImages(backgrounds: [String(model.id.rawValue): image!])
                    }
                }
            }
        }
    }
    
    private func ajustScale(imageSize: CGSize) {
        if scale < minScale {
            withAnimation {
                startScale = minScale
                ajustLocation(imageSize: minImageSize)
            }
        } else {
            ajustLocation(imageSize: imageSize)
        }
    }
    
    private func ajustLocation(imageSize: CGSize) {
        var newLocation = self.location
        let width = imageSize.width/2.0
        let height = imageSize.height/2.0
        
        let maxLocationX = widgetFrame.minX + width
        let minLocationX = widgetFrame.maxX - width
        if location.x > maxLocationX {newLocation.x = maxLocationX}
        if location.x < minLocationX {newLocation.x = minLocationX}
        
        let maxY = widgetFrame.minY + height
        let minY = widgetFrame.maxY - height
        if location.y > maxY {newLocation.y = maxY}
        if location.y < minY {newLocation.y = minY}
        
        withAnimation {
            location = newLocation
        }
    }
    
    @ViewBuilder private func imageAndWidgetView() -> some View {
        ZStack {
            
            imageAndMarsk(cornerRadius: defaultCornerRadius, widgetSize: widgetSize)

            widgetViewWithModel(model: model)
                .frame(width: widgetSize.width, height: widgetSize.height)
                .allowsHitTesting(false)
                .ifdo(isBorder == true, transform: { view in
                    view
                        .fixedSize()
                        .frame(width: widgetSize.width-defaultBorderWidth*2, height: widgetSize.height-defaultBorderWidth*2)
                        .cornerRadius(defaultCornerRadius)
                        .clipped()
                })
        }
        .coordinateSpace(name: "ZStack")
        .background {
            GeometryReader { geo in
                Color.clear
                    .preference(key: ContentSizeKey.self, value: geo.size)
                    .onPreferenceChange(ContentSizeKey.self) { size in
                        contentSize = size
                        location = CGPoint(x: size.width/2.0, y: size.height/2.0)
                    }
            }
        }
        .gesture(ExclusiveGesture(dragGesture, magnificationGesture))
        .onAppear {
            originalSize = imageFrame.size
            setupMinSize(rotated: false)
        }

    }
    
    private func setupMinSize(rotated: Bool) {
        var minScale = 0.0
        var rotatedOriginalSize: CGSize? = nil
        if abs(Int(rotationDegrees) / 90) % 2 != 0 {
            rotatedOriginalSize = CGSize(width: originalSize.height, height: originalSize.width)
        }
        let originalSize = rotatedOriginalSize == nil ? originalSize : rotatedOriginalSize!
        if originalSize.width < widgetSize.width {
            minScale = widgetSize.width / originalSize.width
        }
        if originalSize.height < widgetSize.height {
            minScale = widgetSize.height / originalSize.height
        }
        if originalSize.height > widgetSize.height && originalSize.width > widgetSize.width {
            let widthIsMin = originalSize.width / widgetSize.width < originalSize.height / widgetSize.height
            if widthIsMin {
                minScale = widgetSize.width / originalSize.width
            } else {
                minScale = widgetSize.height / originalSize.height
            }
        }
        if minScale != 0.0 {
            minImageSize = CGSize(width: originalSize.width*minScale, height: originalSize.height*minScale)
            self.minScale = minScale
        }
        
        if rotated {
            ajustScale(imageSize: CGSize(width: imageFrame.height, height: imageFrame.width))
        } else {
            ajustScale(imageSize: imageFrame.size)
        }
    }
    
    @ViewBuilder private func imageAndMarsk(cornerRadius: CGFloat, widgetSize: CGSize) -> some View {
        let image = Image(uiImage: image).resizable().aspectRatio(contentMode: .fit)
            .background {
                GeometryReader { geo in
                    Color.clear.preference(key: ImageFrameKey.self, value: geo.frame(in: .named("ZStack")))
                        .onPreferenceChange(ImageFrameKey.self) { rect in
                            imageFrame = rect
                        }
                }
            }
            .rotationEffect(Angle(degrees: rotationDegrees))
            .scaleEffect(scale)
            .position(location)
        ZStack {
            image
                .overlay {
                    Color.black.opacity(0.5)
                }
                .mask(image)
            
            image
                .mask {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .frame(width: widgetSize.width, height: widgetSize.height)
                        .background {
                            GeometryReader { geo in
                                Color.clear
                                    .preference(key: WidgetFrameKey.self, value:geo.frame(in: .named("ZStack")))
                                    .onPreferenceChange(WidgetFrameKey.self) { rect in
                                        widgetFrame = rect
                                    }
                            }
                        }
                }
        }
    }
    
    private func buttonsView() -> some View {
        Rectangle()
            .fill(.clear)
            .safeAreaInset(edge: .top) {
                HStack(spacing: 0) {
                    Button {
                        dismiss()
                    } label: {
                        Text("返回")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                    }
                    .padding(20)
                    Spacer()
                    Button {
                        Task {
                            clippedImage = await ImageRenderer(content: imageAndMarsk(cornerRadius: 0, widgetSize: widgetSize).frame(width: contentSize.width, height: contentSize.height).fixedSize().frame(width: widgetSize.width, height: widgetSize.height)).uiImage
                        }
                    } label: {
                        Text("确定")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                    }
                    .padding(20)
                }
                .background(.black)
            }
            .safeAreaInset(edge: .bottom) {
                HStack(spacing: 20) {
                    Image("rotateLeft")
                        .onTapGesture {
                            withAnimation(.linear(duration: 0.3)) {
                                rotationDegrees -= 90
                                setupMinSize(rotated: true)
                            }
                        }
                    Text("还原")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .onTapGesture {
//                            rotationDegrees = Double(Int(rotationDegrees) % 360)
                            let rotated = abs(Int(rotationDegrees) / 90) % 2 != 0
                            withAnimation(.linear(duration: 0.3)) {
                                self.rotationDegrees = 0
                                setupMinSize(rotated: rotated)
                            }
                        }
                        .padding(20)
                    Image("rotateRight")
                        .onTapGesture {
                            withAnimation(.linear(duration: 0.3)) {
                                rotationDegrees += 90
                                setupMinSize(rotated: true)
                            }
                        }
                }
                .frame(maxWidth: .infinity)
                .background(.black)
            }
    }
}

struct ClipImageView_Previews: PreviewProvider {
    static var model: WidgetModel = WidgetModel(id: .CalendarMediumOne, name: nil, icon: nil, is_free: nil)
    
    static var previews: some View {
        ClipImageView(image: UIImage(named: "svip_enable")!, model: model, isBorder: false)
    }
}
