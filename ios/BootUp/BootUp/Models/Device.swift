//
//  Device.swift
//  BootUp
//
//  Created by Jacob Kelly on 8/5/25.
//

import Foundation
import SwiftData

@Model
class Device: Identifiable {
    var id: UUID
    var name: String
    var macAddress: String
    var broadcastIP: String

    init(id: UUID = UUID(), name: String, macAddress: String, broadcastIP: String) {
        self.id = id
        self.name = name
        self.macAddress = macAddress
        self.broadcastIP = broadcastIP
    }
}
