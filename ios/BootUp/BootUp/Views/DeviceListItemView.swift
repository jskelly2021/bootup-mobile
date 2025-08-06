//
//  DeviceListItemView.swift
//  BootUp
//
//  Created by Jacob Kelly on 8/6/25.
//

import Foundation
import SwiftUI

struct DeviceListItemView: View {
    var device: Device
    
    init(device: Device) {
        self.device = device
    }

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .shadow(radius: 2)

            VStack(alignment: .leading) {
                Text(device.name)
                    .font(.headline)
            }
            .multilineTextAlignment(.leading)
            .foregroundColor(.black)
            .lineLimit(2)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}

#Preview {
    let device = Device(name: "j2pc", macAddress: "AA:AA:AA:AA:AA:AA", broadcastIP: "192.168.1.255")

    DeviceListItemView(device: device)
}
