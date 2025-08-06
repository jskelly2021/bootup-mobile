//
//  ContentView.swift
//  BootUp
//
//  Created by Jacob Kelly on 8/5/25.
//


import SwiftUI
import Foundation

enum AppRoute: Hashable {
    case deviceDetails
    case deviceList
}

struct ContentView: View {
    @StateObject private var viewModel = BootUpViewModel()
    @State private var path: [AppRoute] = []

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                HStack {
                    Button("Start PC", systemImage: "power", action: viewModel.bootDevice)
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
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                    case .deviceDetails:
                        if let device = viewModel.selectedDevice {
                            DeviceDetailsView(device: device) { name, mac, ip in
                                viewModel.editDevice(name: name, macAddress: mac, broadcastIP: ip)
                            }
                        } else {
                            Text("No device selected")
                        }
                    case .deviceList:
                        DeviceListView(devices: viewModel.devices) { device in
                            viewModel.selectDevice(device)
                        }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button(viewModel.selectedDevice?.name ?? "No device selected") {
                        path.append(AppRoute.deviceList)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    deviceDetailsButton()
                }
            }
            .padding()
        }
    }

    private func deviceDetailsButton() -> some View {
        Button("Device Details", systemImage: "ellipsis") {
            path.append(AppRoute.deviceDetails)
        }
        .labelStyle(.iconOnly)
    }
}

#Preview {
    ContentView()
}
