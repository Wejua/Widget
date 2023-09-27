//
//  ProfileHome.swift
//  HotWidget
//
//  Created by 周位杰 on 2022/12/10.
//

import SwiftUI

struct ProfileHome: View {
    var isVip = false
    
    var body: some View {
        VStack(spacing: 15) {
            Spacer()
            
            Image("logo3")
                .resizable()
                .cornerRadius(10)
                .frame(width: 80, height: 80)
                .padding(.bottom, 30)
            
            if (isVip) {
                Image("svip_enable")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding([.leading, .trailing], 15)
            } else {
                Image("svip")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding([.leading, .trailing], 15)
            }
            
            MyWigetsButton()
            
            MoreButton()
            
            Spacer()
            
        }
        .background(Color(hex: "#303234FF"))
        .edgesIgnoringSafeArea(.top)
    }
}

struct MyWigetsButton: View {
    var body: some View {
        NavigationLink {
            MyWidgetsView()
        } label: {
            HStack {
                Spacer()
                Text("我的小组件")
                    .foregroundColor(.white)
                Spacer()
            }
        }
        .frame(height: 55)
        .background(Color(hex: "#111419FF"))
        .cornerRadius(10)
        .padding([.leading, .trailing], 15)
    }
}

struct MoreButton: View {
    var body: some View {
        NavigationLink {
            MoreView()
        } label: {
            HStack {
                Spacer()
                Text("更多")
                    .foregroundColor(.white)
                Spacer()
            }
        }
        .frame(height: 55)
        .background(Color(hex: "#111419FF"))
        .cornerRadius(10)
        .padding([.leading, .trailing], 15)
    }
}

struct ProfileHome_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHome()
    }
}
