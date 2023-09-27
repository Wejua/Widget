//
//  CategoryRow.swift
//  HotWidget
//
//  Created by 周位杰 on 2022/12/10.
//

import SwiftUI

struct CategoryRow: View {
    
    var category: WidgetList.WidgetListCategories
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
//                Color(red: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0)
                Image("logo3")
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .leading)
                    .cornerRadius(4)
                Text(category.name)
                    .font(.headline)
            }
            .padding(.leading, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                let width = 124.0
                HStack(spacing: 8) {
                    ForEach(category.list, id: \.id) { item in
                        NavigationLink {
                            WidgetDetailView(model: WidgetModel(id: item.id))
                        } label: {
                            let model = WidgetModel(id: item.id, name: item.name, icon: item.icon)
                            if (model.family == .medium) {
                                widgetViewWithModel(model: model)
                                    .frame(width: width*mediumRatio, height: width)
                            }
                            else if (model.family == .large) {
                                widgetViewWithModel(model: model)
                                    .frame(width: width*largeRatio, height: width)
                            }
                            else {
                                widgetViewWithModel(model: model)
                                    .frame(width: width*smallRatio, height: width)
                            }
                        }
                    }
                }
                .padding(.leading, 20)
            }
            
//            Spacer()
            
        }
    }
    
}



//struct CategoryRow_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryRow(category: WidgetCategory())
//    }
//}
