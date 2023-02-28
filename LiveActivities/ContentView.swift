//
//  ContentView.swift
//  LiveActivities
//
//  Created by Juan Bazan Carrizo on 16/02/2023.
//

import SwiftUI
import WidgetKit
import ActivityKit

struct ContentView: View {
    
    // MARK: - Update Live Activities
    @State var currentID: String = ""
    @State var currentSelection: Status = .received
    var body: some View {
        NavigationStack{
            VStack(spacing: 15) {
                Picker(selection: $currentSelection) {
                    Text("Received")
                        .tag(Status.received)
                    Text("Progress")
                        .tag(Status.progress)
                    Text("Ready")
                        .tag(Status.ready)
                } label: {
                    
                }
                .labelsHidden()
                .pickerStyle(.segmented)
                
                Button("Start") {
                    addLiveActivities()
                }
                
                Button("Remove activity") {
                    removeActivity()
                }
            }
            .navigationTitle("Live Activities")
            .padding()
            .onChange(of: currentSelection) { newValue in
                if let safeActivity = Activity.activities.first(where: { (activity: Activity<OrderStatusAttributes>) in
                    activity.id == currentID
                }) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        var updatedState = safeActivity.contentState
                        updatedState.status = currentSelection
                        Task {
                            await safeActivity.update(using: updatedState)
                        }
                    }
                }
            }
        }
    }
    
    func removeActivity() {
        if let safeActivity = Activity.activities.first(where: { (activity: Activity<OrderStatusAttributes>) in
            activity.id == currentID
        }) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                Task{
                    await safeActivity.end(using: safeActivity.contentState, dismissalPolicy: .immediate)
                }
            }
        }
    }
    func addLiveActivities() {
        let orderAttributes = OrderStatusAttributes(orderNumber: 1811, OrderItems: "Panchitos")
        let initialContentState = OrderStatusAttributes.ContentState()
        do {
            let activity = try Activity<OrderStatusAttributes>.request(attributes: orderAttributes, contentState: initialContentState, pushType: nil)
            currentID = activity.id
            print("Activity add succesfully \(activity.id)")
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
