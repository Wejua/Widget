//
//  WidgetDetailApplyButton.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/2.
//

import SwiftUI
import SwiftUITools

struct WidgetDetailApplyButton: View {
    @EnvironmentObject var model: WidgetModel
    @Binding var showAlert: Bool
    
    var body: some View {
        ZStack {
            Color(hex: "#303234")
                .frame(height: 100)
                .cornerRadius(30, corners: [.topLeft, .topRight])
            
            Button {
                let appData = AppData.shared
                appData.fetchWidgetsFromSharedContainer()
                if model.family == .small {
                    if let index = appData.mySmallWidgets.firstIndex(where: {$0.id==model.id}) {
                        appData.mySmallWidgets.replaceSubrange(index...index, with: [model])
                    } else {
                        appData.mySmallWidgets.append(model)
                    }
                    
                } else if model.family == .medium {
                    if let index = AppData.shared.myMediumWidgets.firstIndex(where: {$0.id==model.id}) {
                        appData.myMediumWidgets.replaceSubrange(index...index, with: [model])
                    } else {
                        appData.myMediumWidgets.append(model)
                    }
                    
                } else if model.family == .large {
                    if let index = AppData.shared.myLargeWidgets.firstIndex(where: {$0.id==model.id}) {
                        AppData.shared.myLargeWidgets.replaceSubrange(index...index, with: [model])
                    } else {
                        AppData.shared.myLargeWidgets.append(model)
                    }
                    
                }
                appData.storeWidgetsToSharedContainer()
                showAlert.toggle()
            } label: {
                Text("应用")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
                    .frame(width: 325, height: 50)
                    .background(LinearGradient(colors: [Color(hex: "#2CE2EE")!, Color(hex: "#91F036")!], startPoint: .trailing, endPoint: .leading))
                    .cornerRadius(25, corners: .allCorners)
            }
//            .alert("组件已添加，快去我的小组件页面查看吧！", isPresented: $showAlert) {
//                Button("确定", role: .cancel) {}
//            }
        }

    }
}

struct ApplyButton_Previews: PreviewProvider {
    @StateObject static var model = WidgetModel(id: .DashBoardLargeThree)
    static var previews: some View {
        WidgetDetailApplyButton(showAlert: .constant(true))
            .environmentObject(model)
    }
}
