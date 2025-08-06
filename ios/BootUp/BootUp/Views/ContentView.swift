//
//  ContentView.swift
//  BootUp
//
//  Created by Jacob Kelly on 8/5/25.
//


import SwiftUI
import Foundation

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @ObservedObject private var viewModel = BootUpViewModel()

    @State private var macAddress: String = ""
    @State private var broadcastIP: String = ""

    var body: some View {
        VStack {

            Text("BootUp")
                .font(.title)

            TextField(" Enter MAC address", text: $macAddress)
                .textInputAutocapitalization(.characters)
                .disableAutocorrection(true)
                .border(.tertiary)
                .textFieldStyle(.roundedBorder)

            TextField(" Enter broadcast IP", text: $broadcastIP)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .border(.tertiary)
                .textFieldStyle(.roundedBorder)

            HStack {
                Button("Start PC", systemImage: "power"){
                    viewModel.bootDevice(macAddress: macAddress, broadcastIP: broadcastIP)
                    print("Hello")
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

#Preview {
    ContentView()
}
