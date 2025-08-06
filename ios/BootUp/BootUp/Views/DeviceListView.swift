//
//  DeviceListView.swift
//  BootUp
//
//  Created by Jacob Kelly on 8/6/25.
//

import Foundation
import SwiftUI

struct DeviceListView: View {
    @StateObject private var viewModel = BootUpViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(viewModel.devices, id: \.id) { device in
                        VStack(alignment: .leading) {
                            Text(device.name)
                        }
                    }
                }
            }
            .navigationTitle("Devices")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    newDeviceButton()
                }
            }
        }
    }

    private func newDeviceButton() -> some View {
        Button("New Device", systemImage: "plus.circle") {
            print("New Device")
        }
        .labelStyle(.iconOnly)
    }
}

#Preview {
    DeviceListView()
}
