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

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack {
                    HStack {
                        Button("Start PC", systemImage: "power") {
                            viewModel.bootDevice()
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
            }
            .navigationTitle(viewModel.selectedDevice?.name ?? "No device selected")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    deviceDetailsButton()
                }
            }
            .padding()
        }
    }
    
    private func deviceDetailsButton() -> some View {
        Button("Device Details", systemImage: "ellipsis") {
            print("device details")
        }
        .labelStyle(.iconOnly)
    }
    
}

#Preview {
    ContentView()
}
