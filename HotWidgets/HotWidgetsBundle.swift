//
//  HotWidgetsBundle.swift
//  HotWidgets
//
//  Created by 周位杰 on 2023/2/23.
//

import WidgetKit
import SwiftUI

@main
struct HotWidgetsBundle: WidgetBundle {
    var body: some Widget {
        SmallWidget()
        MediumWidget()
        LargeWidget()
    }
}
