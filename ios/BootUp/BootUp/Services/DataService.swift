//
//  DataService.swift
//  BootUp
//
//  Created by Jacob Kelly on 8/5/25.
//

import Foundation
import SwiftData

class DataService {
    static let shared = DataService()

    private var container: ModelContainer
    private var context: ModelContext

    private init() {
        do {
            container = try ModelContainer(for: Device.self)
            context = ModelContext(container)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }

    func createDevice(name: String, macAddress: String, broadcastIP: String) -> Device {
        let newDevice = Device(name: name, macAddress: macAddress, broadcastIP: broadcastIP)
        context.insert(newDevice)

        do {
            try context.save()
        } catch {
            print("Failed to save device: \(error)")
        }
        return newDevice
    }

    func retrieveDevices() -> [Device] {
        do {
            let descriptor = FetchDescriptor<Device>(sortBy: [SortDescriptor(\.name)])
            return try context.fetch(descriptor)
        } catch {
            print("Failed to retrieve devices: \(error)")
            return []
        }
    }

    func updateDevice(device: Device, name: String, macAddress: String, broadcastIP: String) {
        device.name = name
        device.macAddress = macAddress
        device.broadcastIP = broadcastIP

        do {
            try context.save()
        } catch {
            print("Failed to update device: \(error)")
        }
    }

    func deleteDevice(device: Device) {
        context.delete(device)
        do {
            try context.save()
        } catch {
            print("Failed to delete device: \(error)")
        }
    }
}
