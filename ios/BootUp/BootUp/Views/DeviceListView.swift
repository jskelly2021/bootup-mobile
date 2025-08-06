//
//  DeviceListView.swift
//  BootUp
//
//  Created by Jacob Kelly on 8/6/25.
//

import Foundation
import SwiftUI

struct DeviceListView: View {
    @Environment(\.dismiss) var dismiss

    let devices: [Device]
    let onSelect: (Device) -> Void

    init(devices: [Device], onSelect: @escaping (Device) -> Void) {
        self.devices = devices
        self.onSelect = onSelect
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(devices, id: \.id) { device in
                    VStack {
                        Button {
                            onSelect(device)
                        } label: {
                            DeviceListItemView(device: device)
                        }
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
        .padding(.horizontal)
    }

    private func newDeviceButton() -> some View {
        Button("New Device", systemImage: "plus.circle") {
            print("New Device")
        }
        .labelStyle(.iconOnly)
    }
}

#Preview {
    let devices = [
        Device(name: "j2pc", macAddress: "AA:AA:AA:AA:AA:AA", broadcastIP: "192.168.1.255"),
        Device(name: "Macbook", macAddress: "AA:AA:AA:AA:AA:AA", broadcastIP: "192.168.1.255"),
        Device(name: "j3pc", macAddress: "AA:AA:AA:AA:AA:AA", broadcastIP: "192.168.1.255")
    ]

    DeviceListView(
        devices: devices,
        onSelect: { device in
            print("Selected: " + device.name)
        })
}
