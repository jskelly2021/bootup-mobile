//
//  DeviceDetailsView.swift
//  BootUp
//
//  Created by Jacob Kelly on 8/6/25.
//

import Foundation
import SwiftUI

struct DeviceDetailsView: View {
    @Environment(\.editMode) var editMode

    @State private var isCanceled: Bool = false

    @Binding var selectedDevice: Device
    @State private var deviceName: String
    @State private var macAddress: String
    @State private var broadcastIP: String

    init(device: Device) {
        device = device
        deviceName = device.name
        macAddress = device.macAddress
        broadcastIP = device.broadcastIP
    }

    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                if editMode?.wrappedValue == .active {
                    Button("Cancel", role: .cancel) {
                        isCanceled = true
                        editMode?.animation().wrappedValue = .inactive
                    }
                }
                Spacer()
                EditButton()
            }
            .padding(.horizontal)

            Form {
                Section(header: Text("Device Info")) {
                    if editMode?.wrappedValue == .active {
                        customTextField(detail: "Device Name", placeHolder: "Enter device name", text: $deviceName)
                        customTextField(detail: "MAC Address", placeHolder: "Enter MAC address", text: $macAddress)
                            .textInputAutocapitalization(.characters)
                        customTextField(detail: "Broadcast IP", placeHolder: "Enter broadcast IP", text: $broadcastIP)
                            .keyboardType(.numbersAndPunctuation)
                    }
                    else {
                        deviceDetail(detail: "Device Name", value: deviceName)
                        deviceDetail(detail: "MAC Address", value: macAddress)
                        deviceDetail(detail: "Broadcast IP", value: broadcastIP)
                    }
                }
            }
            .frame(width: .infinity)
        }
        .onChange(of: editMode?.wrappedValue) {
            if editMode?.wrappedValue == .inactive && !isCanceled {
                isCanceled = false
                
            }
        }
    }

    private func deviceDetail(detail: String, value: String) -> some View {
        HStack {
            Text(detail)
                .font(.headline)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
    }

    private func customTextField(detail: String, placeHolder: String, text: Binding<String>) -> some View {
        HStack {
            Text(detail)
                .font(.headline)
            Spacer()
            TextField(placeHolder, text: text)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    let device = Device(name: "j2pc", macAddress: "AA:AA:AA:AA:AA:AA", broadcastIP: "192.168.1.255")
    DeviceDetailsView(device: device)
}
