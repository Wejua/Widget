//
//  ViewExtensions.swift
//  HotWidget
//
//  Created by 周位杰 on 2022/12/31.
//

import Foundation
import SwiftUI


extension View {
    public func foregroundLinearGradient(colors: [Color], startPoint: UnitPoint, endPoint: UnitPoint) -> some View {
        self.overlay {
            LinearGradient(
                colors: colors,
                startPoint: startPoint,
                endPoint: endPoint
            )
            .mask(
                self
            )
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners, cornerRadii: CGSize(width:
                                                                                    radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    
    func topSafeAreaColor(color: Color?) -> some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                self
                
                color
                    .frame(height: geo.safeAreaInsets.top)
                    .ignoresSafeArea()
            }
        }
    }
    
    func bottomSafeAreaColor(color: Color?) -> some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                self
                
                color
                    .frame(height: geo.safeAreaInsets.bottom)
                    .offset(y: geo.safeAreaInsets.bottom)
                    .ignoresSafeArea()
            }
        }
    }
}

extension View {
    @ViewBuilder func ifdo<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content, elsedo: ((Self) -> Content)? = nil) -> some View {
        if condition() {
            transform(self)
        } else {
            if (elsedo != nil) {
                elsedo!(self)
            } else {
                self
            }
        }
    }
}
