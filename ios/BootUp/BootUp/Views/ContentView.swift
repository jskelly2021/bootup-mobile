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
    @State private var path = NavigationPath()

    @State private var deviceName: String = ""
    @State private var macAddress: String = ""
    @State private var broadcastIP: String = ""
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                TextField("Device Name", text: $deviceName)
                    .textInputAutocapitalization(.never)
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
                
                DeviceListView()

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
            .navigationTitle("BootUp")
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
