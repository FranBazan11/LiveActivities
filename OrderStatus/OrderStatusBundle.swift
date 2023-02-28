//
//  OrderStatusBundle.swift
//  OrderStatus
//
//  Created by Juan Bazan Carrizo on 16/02/2023.
//

import WidgetKit
import SwiftUI

@main
struct OrderStatusBundle: WidgetBundle {
    var body: some Widget {
        OrderStatus()
        OrderStatusLiveActivity()
    }
}
