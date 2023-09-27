//
//  AuthorizationsView.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/5/30.
//

import SwiftUI
import SwiftUITools

struct AuthorizationsView: View {
    typealias Item = (image: String, title: String, detail: String, type: AuthorizationManager.AuthorizationType)
    private var items: [Item] = [
        ("authorization_photos", "照片", "授权访问照片可设置相册照片组件", .photos),
        ("authorization_location", "位置", "授权访问照片可设置相册照片组件", .location),
        ("authorization_bluetooth", "蓝牙", "授权访问照片可设置相册照片组件", .bluetooth),
        ("authorization_health", "运动与健康", "授权访问照片可设置相册照片组件", .health),
        ("authorization_noti", "通知", "授权访问照片可设置相册照片组件", .notification)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            let grids = [GridItem](repeating: GridItem(.flexible(), spacing: 15), count: 2)
            LazyVGrid(columns: grids, spacing: 15) {
                ForEach(items, id: \.title) { item in
                    AuthorizationItemView(item: item)
                }
            }
            .padding([.leading, .trailing], 15)
            
            Spacer()
        }
        .background(primaryColor)
        .customBackView(label: {
            Image("popbackImage")
        })
        .inlineNavigationTitle(title: Text("授权"))
    }
}

struct AuthorizationItemView: View {
    let item: AuthorizationsView.Item
    @State var isAuthorized: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStackLayout(spacing: 5) {
                Image(item.image)
                Text(item.title)
                    .textSett(color: .white, FName: .PingFangSCMedium, Fsize: 16, lineLi: nil)
            }
            .padding(.top, 20)
            
            Text(item.detail)
                .textSett(color: captionColor, FName: .PingFangSCRegular, Fsize: 14, lineLi: nil)
                .multilineTextAlignment(.center)
                .padding([.leading, .trailing], 15)
                .padding(.top, 16)
            
            Text(isAuthorized ? "已授权" : "未授权")
                .textSett(color: isAuthorized ? .white : "#FF1010".color!, FName: .PingFangSCRegular, Fsize: 14, lineLi: nil)
                .padding(.top, 20)
            
            Link(destination: AuthorizationManager.url(type: item.type)) {
                Text("去设置")
                    .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 14, lineLi: nil)
                    .frame(width: 115, height: 32)
                    .cornerRadius(16)
                    .ifdo(isAuthorized) { view in
                        view.foregroundLinearGradient(colors: buttonColors, startPoint: .leading, endPoint: .trailing)
                            .overlay {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.linearGradient(colors: buttonColors, startPoint: .leading, endPoint: .trailing), style: .init(lineWidth: 1))
                            }
                    }
                    .ifdo(!isAuthorized) { view in
                        view.background {
                            Capsule()
                                .fill(LinearGradient(colors: buttonColors, startPoint: .leading, endPoint: .trailing))
                                .frame(width: 115, height: 32)
                        }
                    }
                    .padding([.top, .bottom], 20)
            }
        }
        .background(secondaryColor)
        .cornerRadius(10)
        .task {
            isAuthorized = await AuthorizationManager().isAuthorized(type: item.type)
        }
    }
}

struct AuthorizationsView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizationsView()
    }
}
