//
//  BootUpViewModel.swift
//  BootUp
//
//  Created by Jacob Kelly on 8/5/25.
//

import Foundation
import SwiftData
import Network

class BootUpViewModel: ObservableObject {
    private let dataService: DataService
    @Published var statusMessage: String = ""

    var devices: [Device] = []

    init(dataService: DataService = .shared) {
        self.dataService = dataService
    }

    func fetchDevices() {
        devices = dataService.retrieveDevices()
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

    func editDevice(device: Device, name: String, macAddress: String, broadcastIP: String) {
        dataService.updateDevice(device: device, name: macAddress, macAddress: macAddress, broadcastIP: broadcastIP)
    }


    func bootDevice(macAddress: String, broadcastIP: String) {
        guard let packet = WakeOnLanService.buildWOLPacket(mac: macAddress) else {
            statusMessage = "Invalid MAC Address format"
            return
        }

        guard let ip = IPv4Address(broadcastIP) else {
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
