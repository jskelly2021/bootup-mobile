//
//  BootUpViewModel.swift
//  BootUp
//
//  Created by Jacob Kelly on 8/5/25.
//

import Foundation
import Network

class BootUpViewModel: ObservableObject {
    @Published var statusMessage: String = ""

    func bootDevice(macAddress: String, broadcastIP: String) {
        guard let packet = buildWOLPacket(mac: macAddress) else {
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

        connection.stateUpdateHandler = { state in
            switch state {
            case .ready:
                connection.send(content: packet, completion: .contentProcessed { error in
                    if let error = error {
                        self.statusMessage = "Send failed: \(error.localizedDescription)"
                    } else {
                        self.statusMessage = "WOL packet sent successfully!"
                    }
                    connection.cancel()
                })
            case .failed(let error):
                self.statusMessage = "Connection failed: \(error.localizedDescription)"
                connection.cancel()
            default:
                break
            }
        }

        connection.start(queue: .global())
    }

    
    func logonToDevice() {
        
    }


    func buildWOLPacket(mac: String) -> Data? {
         let cleaned = mac.replacingOccurrences(of: "[:-]", with: "", options: .regularExpression)
         guard cleaned.count == 12 else { return nil }

         var macBytes = [UInt8]()
         for i in stride(from: 0, to: 12, by: 2) {
             let byteStr = cleaned[cleaned.index(cleaned.startIndex, offsetBy: i)..<cleaned.index(cleaned.startIndex, offsetBy: i+2)]
             guard let byte = UInt8(byteStr, radix: 16) else { return nil }
             macBytes.append(byte)
         }

         var packet = [UInt8](repeating: 0xFF, count: 6)
         for _ in 0..<16 {
             packet.append(contentsOf: macBytes)
         }

         return Data(packet)
     }
}
