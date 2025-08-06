//
//  wolPacketService.swift
//  BootUp
//
//  Created by Jacob Kelly on 8/5/25.
//

import Foundation

struct WakeOnLanService {
    static func buildWOLPacket(mac: String) -> Data? {
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
