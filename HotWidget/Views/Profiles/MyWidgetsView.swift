//
//  MyWidgetsView.swift
//  HotWidget
//
//  Created by 周位杰 on 2022/12/31.
//

import SwiftUI
import SwiftUITools


struct MyWidgetsView: View {
    
    enum WidgetSize: Identifiable, CaseIterable, Codable {
        var id: Self {
            return self
        }
        
        case small
        case medium
        case large
    }
    
    @State private var isSelecting = false
    
    @State var selectedModels:[WidgetModel] = []
    
    @State var showAlert: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                ZStack(alignment: .center) {
                    ScrollView {
                        VStack(spacing: 0) {
                            let _ = AppData.shared.fetchWidgetsFromSharedContainer()
                            ForEach(WidgetSize.allCases) { cas in
                                switch cas {
                                case .small:
                                    MyWidgetsRow(title: "小号", models: AppData.shared.mySmallWidgets, isSelecting: $isSelecting, selectedModels: $selectedModels)
                                case .medium:
                                    MyWidgetsRow(title: "中号", models: AppData.shared.myMediumWidgets, isSelecting: $isSelecting, selectedModels: $selectedModels)
                                case .large:
                                    MyWidgetsRow(title: "大号", models: AppData.shared.myLargeWidgets, isSelecting: $isSelecting, selectedModels: $selectedModels)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 15)
                    .background(Color(hex: "#303234FF"))
                    .edgesIgnoringSafeArea(.bottom)
                    
                    VStack {
                        Color(hex: "#303234FF")
                            .frame(height: geo.safeAreaInsets.top, alignment: .top)
                        
                        Spacer()
                    }
                    .ignoresSafeArea()
                }
                .toolbar(content: {
                    Button {
                        isSelecting.toggle()
                    } label: {
                        if(isSelecting) {
                            Text("取消")
                                .foregroundColor(.white)
                        } else {
                            Text("选择")
                                .foregroundColor(.white)
                        }
                    }
                    
                })
                
                if (isSelecting) {
                    Button {
                        showAlert.toggle()
                    } label: {
                        LinearGradient(colors: [Color(hex: "#91F036FF")!, Color(hex:"#2CE2EEFF")!], startPoint: .leading, endPoint: .trailing)
                            .frame(width: 40, height: 40)
                            .cornerRadius(20)
                            .overlay {
                                Image("delete")
                            }
                    }
                    .alert("删除以后桌面上的组件也会删除确定要删除吗？", isPresented: $showAlert) {
                        Button("取消", role: .cancel) {}
                        Button("确定", role: .destructive) {
                            let appData = AppData.shared
                            selectedModels.forEach({ model in
                                if model.family == .small {
                                    if let index = appData.mySmallWidgets.firstIndex(where: {$0.id==model.id}) {
                                        appData.mySmallWidgets.remove(at: index)
                                    }
                                } else if (model.family == .medium) {
                                    if let index = appData.myMediumWidgets.firstIndex(where: {$0.id==model.id}) {
                                        appData.myMediumWidgets.remove(at: index)
                                    }
                                } else if (model.family == .large) {
                                    if let index = appData.myLargeWidgets.firstIndex(where: {$0.id==model.id}) {
                                        appData.myLargeWidgets.remove(at: index)
                                    }
                                }
                            })
                            appData.storeWidgetsToSharedContainer()
                            isSelecting.toggle()
                        }
                    }
                }

            }
        }
        .navigationTitle("我的小组件")
//        .edgesIgnoringSafeArea(.bottom)
    }
}

struct MyWidgetsRow: View {
    
    var title: String
    
    var models: [WidgetModel]
    
    @Binding var isSelecting: Bool
    
    @Binding var selectedModels:[WidgetModel]
    
    private let gridItemLayout = [GridItem(.adaptive(minimum: 165), spacing: 15), GridItem(.adaptive(minimum: 165), spacing: 15)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.system(size: 18))
                .padding([.top, .bottom], 10)
                .foregroundColor(Color(hex: "#999999FF"))
            
            LazyVGrid(columns: gridItemLayout, spacing: 15) {
                ForEach(models, id: \.id) { model in
                    MyWidgetsItem(isSelecting: $isSelecting, selectedModels:$selectedModels , model:model)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 165)
                        .background(Color(hex: "#111419FF"))
                        .cornerRadius(10)
                }
            }
        }
        .padding([.leading, .trailing], 15)
    }
}

struct MyWidgetsItem: View {
    
    @Binding var isSelecting: Bool
    
    @Binding var selectedModels:[WidgetModel]
    
    @ObservedObject var model: WidgetModel
    
    @State private var isButtonSelected: Bool = false
    
    var body: some View {
            ZStack(alignment: .top) {
                VStack(spacing: 10) {
                    NavigationLink {
                        WidgetDetailView(model: model)
                    } label: {
                        widgetViewWithModel(model: model)
                            .ifdo(model.family == .small) { view in
                                view.frame(width: 69, height: 69/smallRatio)
                            }
                            .ifdo(model.family == .medium) { view in
                                view.frame(width: 145, height: 145/mediumRatio)
                            }
                            .ifdo(model.family == .large) { view in
                                view.frame(width: 145, height: 145/largeRatio)
                            }
                            .cornerRadius(14*69.0/155.0)
                    }

                    
                    Text("Widget")
                    
                    Button {

                    } label: {
                        Text("安装到桌面")
                            .frame(width: 115, height: 32)
                            .foregroundColor(Color(.white))
                            .background(LinearGradient(colors: [Color(hex: "#91F036FF")!, Color(hex:"#2CE2EEFF")!], startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(16)
                    }
                    
                }
                .padding([.top, .bottom], 10)
                
                HStack {
                    Spacer()
                    Button {
                        isButtonSelected.toggle()
                        if (isButtonSelected) {
                            selectedModels.append(model)
                        } else {
                            if let index = selectedModels.firstIndex(where: {$0.id==model.id}) {
                                selectedModels.remove(at: index)
                            }
                        }
                    } label: {
                        if (isSelecting) {
                            if (isButtonSelected) {
                                Image("selected")
                            } else {
                                Image("unselected")
                            }
                        }
                    }
                .padding([.top, .trailing], 5)
                }
            }
    }
}

struct MyWidgetsView_Previews: PreviewProvider {
    static var previews: some View {
        MyWidgetsView()
    }
}
