//
//  AreaSelectView.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/6/1.
//

import SwiftUI
import SwiftUITools

struct AreaSelectView: View {
    @State private var text: String = ""
    @FocusState private var focus: Bool
    @State private var showCloseView: Bool = false
    @State private var currentCityN: String = ""
    private let defaultCities = AdministrativeDivisions.provinces.map { province in
        let cityN = province.cities[0].cityName
        if cityN == "市辖区" {
            return province.provinceName
        } else {
            return cityN
        }
    }
    let color = "#F1F7FF".color!.opacity(0.26)
    
    var body: some View {
        VStack(spacing: 0) {
            TextField("搜索", text: $text, prompt: nil, axis: .horizontal)
                .TextFieldSett(textC: .white, cursorC: .white, fontN: .PingFangSCRegular, fontS: 14)
                .frame(height: 44)
                .padding(.leading, 15)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(color, style: .init(lineWidth: 1))
                })
                .ifdo(showCloseView, transform: { view in
                    view
                        .overlay(alignment: .trailing, content: {
                            Image("AreaSelect_searchClose")
                                .padding(.trailing, 8)
                                .onTapGesture {
                                    text = ""
                                }
                        })
                })
                .focused($focus)
                .onSubmit {
                    showCloseView = text.count > 0 ? true : false
                }
                .onAppear {
                    focus = true
                }
                .padding([.leading, .trailing], 15)
                .padding([.top, .bottom], 6)
        
            ZStack {
                SearchResultsView(text: $text, currentCityN: $currentCityN)
                if text.count == 0 {
                    defaultAreasView()
                }
            }
            
            Spacer()
        }
        .background(primaryColor)
        .customBackView {
            Image("popbackImage")
        }
        .inlineNavigationTitle(title: Text("选择地区"))
    }
    
    @ViewBuilder func defaultAreasView() -> some View {
        let grids = [GridItem](repeating: GridItem(.flexible(), spacing: 15), count: 3)
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: grids, spacing: 15) {
                defaultAreaItem(cityN: "我的位置")
                    .onTapGesture {
//                        currentCityN =
                    }
                ForEach(defaultCities, id:\.self) { cityN in
                    defaultAreaItem(cityN: cityN)
                        .onTapGesture {
                            currentCityN = cityN
                        }
                }
            }
            .padding([.top, .leading, .trailing], 15)
        }
    }
    
    @ViewBuilder func defaultAreaItem(cityN: String) -> some View {
        Text(cityN)
            .textSett(color: .white, FName: .PingFangSCRegular, Fsize: 14, lineLi: nil)
            .frame(maxWidth: .infinity, minHeight: 32)
            .background(color)
            .cornerRadius(5)
    }
}

struct SearchResultsView: View {
    @Binding var text: String
    @Binding var currentCityN: String
    let color = "#F1F7FF".color!.opacity(0.26)
    
    var body: some View {
        searchResultsView()
    }
    
    init(text: Binding<String>, currentCityN: Binding<String>) {
        self._text = text
        self._currentCityN = currentCityN
    }
    
    @ViewBuilder func searchResultsView() -> some View {
        let areas = findAreas()
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0) {
                if let areas = areas {
                    ForEach(areas, id:(\.id)) { area in
                        resultItem(province: area.province, city: area.city, district: area.district)
                    }
                }
            }
        }
        .overlay(content: {
            if text.count > 0 && areas.count == 0 {
                Text("没有搜到这个地方")
                    .textSett(color: captionColor, FName: .PingFangSCRegular, Fsize: 14, lineLi: nil)
            }
        })
        .padding([.top, .leading, .trailing], 15)
    }
    
    @ViewBuilder func resultItem(province: String, city: String, district: String) -> some View {
        HStack(spacing: 10) {
            Text(province)
            Text(city)
            Text(district)
        }
        .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
        .overlay(alignment: .bottom) {
            Rectangle().fill(color)
                .frame(height: 1)
        }
        .onTapGesture {
            currentCityN = district
        }
    }
    
    func findAreas() -> [(province: String, city: String, district: String, id: String)] {
        var strings = [String]()
        let spacer = " "
        AdministrativeDivisions.provinces.forEach { province in
            province.cities.forEach { city in
                city.districts.forEach { district in
                    strings.append(province.provinceName + spacer + city.cityName + spacer + district.districtName)
                }
            }
        }
        return strings.filter { string in
            string.trimmingCharacters(in: .whitespaces).contains(text)
        }.map { string in
            let arr = string.split(separator: spacer)
            return (String(arr[0]), String(arr[1]), String(arr[2]), String(arr[0]+arr[1]+arr[2]))
        }
    }
}

struct AreaSelectView_Previews: PreviewProvider {
    static var previews: some View {
        AreaSelectView()
    }
}
