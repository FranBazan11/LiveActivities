//
//  OrderStatusLiveActivity.swift
//  OrderStatus
//
//  Created by Juan Bazan Carrizo on 16/02/2023.
//

import ActivityKit
import WidgetKit
import SwiftUI

public struct OrderStatusAttributes: ActivityAttributes {
    
    public typealias OrderStatusDelivery = ContentState
    
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var status: Status = .received
    }

    var orderNumber: Int
    var OrderItems: String
}

enum Status: String, CaseIterable, Codable, Equatable {
    case received = "shippingbox.fill"
    case progress = "person.bust"
    case ready = "takeoutbag.and.cup.and.straw.fill"
}

struct OrderStatusLiveActivity: Widget {
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: OrderStatusAttributes.self) { context in
            
            // Lock screen/banner UI goes here
            LockScreenLiveActivityView(context: context)
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom")
                    // more content
                }
            } compactLeading: {
                Text(messageDynamicIslandd(status: context.state.status))
                    .font(.body)
                    .fontWeight(.black)
                    .padding(.leading, 5)
            } compactTrailing: {
                Image(systemName: context.state.status.rawValue)
                    .padding(.trailing, 5)
            } minimal: {
                Text("Min")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(.purple)
        }
    }
    
    func messageDynamicIslandd(status: Status) -> String {
        switch status {
        case .received:
            return "Received"
        case .progress:
            return "Progress"
        case .ready:
            return "Ready"
        }
    }
    
    @ViewBuilder
    func BottomArrow(status: Status, type: Status) -> some View {
        Image(systemName: "arrowtriangle.down.fill")
            .font(.system(size: 15))
            .scaleEffect(x: 1.5)
            .offset(y: 6)
            .opacity(status == type ? 1 : 0)
    }
}
// MARK: - LockScreenLiveActivityView

struct LockScreenLiveActivityView: View {
    let context: ActivityViewContext<OrderStatusAttributes>
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color("Green").gradient)
            
            VStack(spacing: 10) {
                HStack {
                    Image("Starbucks")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50, alignment: .leading)
                    
                    Text("In store pick up")
                        .foregroundColor(.white.opacity(0.6))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: -2) {
                        ForEach(["cup.and.saucer.fill", "takeoutbag.and.cup.and.straw.fill"], id: \.self) { image in
                            Image(systemName: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30, alignment: .center)
                                .padding(5)
                                .background {
                                    Circle()
                                        .fill(Color("Green"))
                                        .padding(-2)
                                }
                                .background {
                                    Circle()
                                        .stroke(.white, lineWidth: 1.5)
                                        .padding(-2)
                                }
                        }
                    }
                }
                
                HStack(alignment: .bottom, spacing: 0) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(message(status: context.state.status))
                            .font(.title3)
                            .foregroundColor(.white)
                        Text(subMessage(status: context.state.status))
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    HStack(alignment: .bottom ,spacing: 10) {
                        ForEach(Status.allCases, id: \.self) { type in
                            if (type == context.state.status) {
                                Image(systemName: type.rawValue)
                                    .font(.title2)
                                    .foregroundColor(Color("Green"))
                                    .frame(width: 45,
                                           height: 45, alignment: .center)
                                    .background {
                                        Circle()
                                            .fill(.white)
                                    }
                                    .background(alignment: .bottom, content: {
                                        Image(systemName: "arrowtriangle.down.fill")
                                            .font(.system(size: 15))
                                            .scaleEffect(x: 1.5)
                                            .offset(y: 6)
                                            .opacity(1)
                                            .foregroundColor(.white)
                                            .overlay(alignment: .bottom) {
                                                Circle()
                                                    .fill(.white)
                                                    .frame(width: 5, height: 5, alignment: .center)
                                                    .offset(y: 13)
                                            }
                                    })
                            } else {
                                Image(systemName: type.rawValue)
                                    .font(.body)
                                    .foregroundColor(.white.opacity(0.7))
                                    .frame(width: 32,
                                           height: 32, alignment: .center)
                                    .background {
                                        Circle()
                                            .fill(.green.opacity(0.5))
                                    }
                                    .background(alignment: .bottom, content: {
                                        Image(systemName: "arrowtriangle.down.fill")
                                            .font(.system(size: 15))
                                            .scaleEffect(x: 1.5)
                                            .offset(y: 6)
                                            .opacity(0)
                                            .foregroundColor(.white)
                                            .overlay(alignment: .bottom) {
                                                Circle()
                                                    .fill(.white)
                                                    .frame(width: 5, height: 5, alignment: .center)
                                                    .offset(y: 13)
                                            }
                                    })
                            }
                        }
                    }
                    .padding(.bottom)
//                    .padding(.leading, 15)
//                    .padding(.trailing, -10)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .padding()
        }
    }
    
    func message(status: Status) -> String {
        switch status {
        case .received:
            return "Order received"
        case .progress:
            return "Order in progress"
        case .ready:
            return "Order ready"
        }
    }
    
    func subMessage(status: Status) -> String {
        switch status {
        case .received:
            return "We just received your order"
        case .progress:
            return "We are handcafting your order"
        case .ready:
            return "We creafted your order"
        }
    }
    
    
}

