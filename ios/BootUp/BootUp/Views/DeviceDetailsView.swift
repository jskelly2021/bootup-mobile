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
    @Environment(\.dismiss) var dismiss

    @State private var isCanceled: Bool = false

    let device: Device
    let onSave: (String, String, String) -> Void
    let onDelete: (Device) -> Void

    @State private var deviceName: String
    @State private var macAddress: String
    @State private var broadcastIP: String

    init(device: Device, onSave: @escaping (String, String, String) -> Void, onDelete: @escaping (Device) -> Void) {
        self.device = device
        self.onSave = onSave
        self.onDelete = onDelete
        self._deviceName = State(initialValue: device.name)
        self._macAddress = State(initialValue: device.macAddress)
        self._broadcastIP = State(initialValue: device.broadcastIP)
    }

    var body: some View {
        VStack {
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

            Button("delete", systemImage: "trash") {
                onDelete(device)
                dismiss()
            }
            .labelStyle(.iconOnly)

        }
        .onChange(of: editMode?.wrappedValue) {
            if editMode?.wrappedValue == .inactive && !isCanceled {
                isCanceled = false
                onSave(deviceName, macAddress, broadcastIP)
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
    DeviceDetailsView(
        device: device,
        onSave: { name, mac, ip in
            print("Saved device: " + name)
        },
        onDelete:{ device in
            print("deleted device: " + device.name)
        }
    )
}
