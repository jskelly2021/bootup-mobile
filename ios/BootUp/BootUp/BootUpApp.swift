//
//  BootUpApp.swift
//  BootUp
//
//  Created by Jacob Kelly on 8/5/25.
//

import SwiftUI
import SwiftData

@main
struct BootUpApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Device.self)
    }
}
