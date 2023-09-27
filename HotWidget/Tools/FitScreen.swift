//
//  FitScreen.swift
//  HotWidget
//
//  Created by weijie.zhou on 2023/3/12.
//

import SwiftUI

struct FitScreen<Content: View>: View {
    
    var referencedWidth: CGFloat
    
    var content: (_ factor: CGFloat) -> Content
    
    @ViewBuilder var body: some View {
        GeometryReader { geo in
            content(geo.size.width/referencedWidth)
        }
    }
    
    init(referencedWidth: CGFloat, @ViewBuilder content: @escaping (CGFloat) -> Content) {
        self.referencedWidth = referencedWidth
        self.content = content
    }

}

struct FitScreenMin<Content: View>: View {
    
    var reference: CGFloat
    
    var content: (_ factor: CGFloat) -> Content
    
    @ViewBuilder var body: some View {
        GeometryReader { geo in
            let min = min(geo.size.width, geo.size.height)
            content(min/reference)
        }
    }
    
    init(reference: CGFloat, @ViewBuilder content: @escaping (CGFloat) -> Content) {
        self.reference = reference
        self.content = content
    }

}
