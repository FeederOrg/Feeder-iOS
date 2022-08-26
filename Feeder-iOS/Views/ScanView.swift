//
//  ScanView.swift
//  Feeder-iOS
//
//  Created by Joe Diragi on 8/25/22.
//

import SwiftUI

struct ScanView: View {
    var bluetooth: BluetoothController
    @Binding var presented: Bool
    @Binding var list: [BluetoothController.Device]
    @Binding var isConnected: Bool

    var body: some View {
        HStack {
            Spacer()
            if isConnected {
                Text("Connected to \(bluetooth.current?.name ?? "")")
            }
            Spacer()
            Button(action: { presented.toggle() }, label: {
                Color(UIColor.secondarySystemBackground).overlay(
                    Image(systemName: "multiply").foregroundColor(Color(UIColor.systemGray))
                ).frame(width: 30, height: 30).cornerRadius(15)
            }).padding([.horizontal, .top]).padding(.bottom, 8)
        }
        List(list) { peripheral in
            Button(action: { bluetooth.connect(peripheral.peripheral) }, label: {
                HStack {
                    Text(peripheral.peripheral.name ?? "Unknown")
                    Spacer()
                }
                HStack {
                    Text(peripheral.uuid).font(.system(size: 10)).foregroundColor(.gray)
                    Spacer()
                }
            })
        }.listStyle(InsetGroupedListStyle()).onAppear {
            bluetooth.startScanning()
        }.onDisappear {
            bluetooth.stopScanning()
        }.padding(.vertical, 0)
    }
}
