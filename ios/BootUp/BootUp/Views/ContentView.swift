//
//  ContentView.swift
//  BootUp
//
//  Created by Jacob Kelly on 8/5/25.
//


import SwiftUI
import Foundation

struct ContentView: View {
    @StateObject private var viewModel = BootUpViewModel()

    @State private var deviceName: String = ""
    @State private var macAddress: String = ""
    @State private var broadcastIP: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                
                Text("BootUp")
                    .font(.largeTitle)
                
                TextField("Device Name", text: $deviceName)
                    .textInputAutocapitalization(.characters)
                    .disableAutocorrection(true)
                    .border(.tertiary)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Enter MAC address", text: $macAddress)
                    .textInputAutocapitalization(.characters)
                    .disableAutocorrection(true)
                    .border(.tertiary)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Enter broadcast IP", text: $broadcastIP)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .border(.tertiary)
                    .textFieldStyle(.roundedBorder)

                Button("Add Device") {
                    viewModel.addDevice(name: deviceName, macAddress: macAddress, broadcastIP: broadcastIP)
                }

                Picker("Select Device", selection: $viewModel.selectedDevice) {
                    ForEach(viewModel.devices, id: \.id) { device in
                        VStack(alignment: .leading) {
                            Text(device.name).tag(device as Device?)
                        }
                    }
                    
                }
                .pickerStyle(.menu)

                HStack {
                    Button("Start PC", systemImage: "power") {
                        viewModel.bootDevice(macAddress: macAddress, broadcastIP: broadcastIP)
                    }
                    .labelStyle(.iconOnly)
                    .padding()
                    
                    Button("Login", systemImage: "play", action: viewModel.logonToDevice)
                        .labelStyle(.iconOnly)
                        .padding()
                }

                Text(viewModel.statusMessage)
                    .foregroundColor(.gray)
                    .padding()
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
