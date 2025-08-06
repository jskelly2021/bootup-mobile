//
//  BootUpViewModel.swift
//  BootUp
//
//  Created by Jacob Kelly on 8/5/25.
//

import Foundation
import SwiftData
import Network
import SwiftUI

class BootUpViewModel: ObservableObject {
    private let dataService: DataService
    @Published var statusMessage: String = ""
    @Published var selectedDevice: Device?
    private let selectedDeviceKey = "SelectedDeviceID"

    @Published var devices: [Device] = []

    init(dataService: DataService = .shared) {
        self.dataService = dataService
        fetchDevices()
    }

    func fetchDevices() {
        devices = dataService.retrieveDevices()

        if let savedID = UserDefaults.standard.string(forKey: selectedDeviceKey),
           let restoredDevice = devices.first(where: { $0.id.uuidString == savedID }) {
            selectedDevice = restoredDevice
        }
    }

    func addDevice(name: String, macAddress: String, broadcastIP: String) {
        dataService.createDevice(name: name, macAddress: macAddress, broadcastIP: broadcastIP)
        fetchDevices()
    }

    func deleteDevice(at offsets: IndexSet) {
        for index in offsets {
            let device = devices[index]
            dataService.deleteDevice(device: device)
        }
        fetchDevices()
    }

    func editDevice(name: String, macAddress: String, broadcastIP: String) {
        guard let device = selectedDevice else {
            print("No device selected")
            return
        }
        dataService.updateDevice(device: device, name: name, macAddress: macAddress, broadcastIP: broadcastIP)
        fetchDevices()
    }

    func selectDevice(_ device: Device?) {
        selectedDevice = device
        if let id = device?.id.uuidString {
            UserDefaults.standard.set(id, forKey: selectedDeviceKey)
        } else {
            UserDefaults.standard.removeObject(forKey: selectedDeviceKey)
        }
    }

    func bootDevice() {
        guard let device = selectedDevice else {
            statusMessage = "No device selected"
            return
        }
        
        guard let packet = WakeOnLanService.buildWOLPacket(mac: device.macAddress) else {
            statusMessage = "Invalid MAC Address format"
            return
        }

        guard let ip = IPv4Address(device.broadcastIP) else {
            statusMessage = "Invalid IP address"
            return
        }

        let endpoint = NWEndpoint.Host.ipv4(ip)
        let port: NWEndpoint.Port = 9
        let connection = NWConnection(host: endpoint, port: port, using: .udp)

        connection.stateUpdateHandler = { [weak self] state in
            switch state {
            case .ready:
                connection.send(content: packet, completion: .contentProcessed { error in
                    if let error = error {
                        self?.statusMessage = "Send failed: \(error.localizedDescription)"
                    } else {
                        self?.statusMessage = "WOL packet sent successfully!"
                    }
                    connection.cancel()
                })
            case .failed(let error):
                self?.statusMessage = "Connection failed: \(error.localizedDescription)"
                connection.cancel()
            default:
                break
            }
        }

        connection.start(queue: .global())
    }

    
    func logonToDevice() {
        
    }
}
