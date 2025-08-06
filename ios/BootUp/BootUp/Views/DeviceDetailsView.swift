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

    @State private var deviceName: String = ""
    @State private var macAddress: String = ""
    @State private var broadcastIP: String = ""
    
    init(device: Device?) {
        deviceName = device?.name ?? ""
        macAddress = device?.macAddress ?? ""
        broadcastIP = device?.broadcastIP ?? ""
    }

    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                if editMode?.wrappedValue == .active {
                    Button("Cancel", role: .cancel) {
                        editMode?.animation().wrappedValue = .inactive
                    }
                }
                Spacer()
                EditButton()
            }

            Form {
                Section(header: Text("Device Info")) {
                    if editMode?.wrappedValue == .active {
                        customTextField(placeHolder: "Enter device name", text: $deviceName)
                        customTextField(placeHolder: "Enter MAC address", text: $macAddress)
                            .textInputAutocapitalization(.characters)
                        customTextField(placeHolder: "Enter broadcast IP", text: $broadcastIP)
                            .keyboardType(.numbersAndPunctuation)
                    }
                    else {
                        deviceDetail(detail: "Device Name", value: deviceName)
                        deviceDetail(detail: "MAC Address", value: macAddress)
                        deviceDetail(detail: "Broadcast IP", value: broadcastIP)
                    }
                }
            }
        }
        .onChange(of: editMode?.wrappedValue) {
            if editMode?.wrappedValue == .inactive {
                print("done editing")
            }
        }
        .padding()
    }

    private func deviceDetail(detail: String, value: String) -> some View {
        HStack {
            Text(detail + ": ")
                .font(.headline)
            Text(value)
        }
    }

    private func customTextField(placeHolder: String, text: Binding<String>) -> some View {
        TextField(placeHolder, text: text)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .border(.tertiary)
            .textFieldStyle(.roundedBorder)
    }
}

#Preview {
    let device = Device(name: "j2pc", macAddress: "AA:AA:AA:AA:AA:AA", broadcastIP: "192.168.1.255")
    DeviceDetailsView(device: device)
}
