//
//  MoreView.swift
//  HotWidget
//
//  Created by 周位杰 on 2022/12/28.
//

import SwiftUI

struct MoreView: View {
    let buttons: [(title:String, destination:String)] = [("常见问题", "QuestionsView"),
                                                         ("小组件限制说明", "QuestionsView"),
                                                         ("授权", "AuthorizationsView"),
                                                         ("用户协议", "QuestionsView"),
                                                         ("隐私政策", "QuestionsView"),
                                                         ("版本号v1.0.0", "QuestionsView")]
    
    var body: some View {
        VStack(alignment:.center, spacing: 15) {
            ForEach(buttons, id: \.title) { button in
                NavigationLink {
                    AreaSelectView()
                } label: {
                    Text(button.title)
                        .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 18, lineLi: nil)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                }
                .background(Color(red: 17/255.0, green: 20/255.0, blue: 25/255.0))
                .cornerRadius(10)
                .padding([.leading, .trailing], 15)
            }
            
            Spacer()
        }
        .padding(.top, 20)
        .background(Color(red: 48/255.0, green: 50/255.0, blue: 52/255.0))
        .navigationTitle("更多")
    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
    }
}
