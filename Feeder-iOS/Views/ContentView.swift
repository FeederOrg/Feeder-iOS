//
//  ContentView.swift
//  Feeder-iOS
//
//  Created by Joe Diragi on 8/22/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var bluetooth = BluetoothController.shared
    @State var presented: Bool = false
    @State var list = [BluetoothController.Device]()
    @State var isConnected: Bool = BluetoothController.shared.current != nil {
            didSet {
                if isConnected { presented.toggle()
            }
        }
    }

    @State var response = Data() { didSet {
        if !response.isEmpty {
            connectedToWifi = true
        } else {
            connectedToWifi = false
        }}}
    @State var connectedToWifi: Bool = false
    @State var string: String = ""
    @State var value: Float = 0

    @State var editing = false

    var body: some View {
        VStack {
            HStack {
                Button("Scan") {
                    presented.toggle()
                }.buttonStyle(AppButton()).padding()
                Spacer()
                if isConnected {
                    Button("Disconnect") {
                        bluetooth.disconnect()
                    }.buttonStyle(AppButton()).padding()
                }
            }
            if isConnected {
                TextField("Send text...", text: $string, onEditingChanged: { editing = $0 })
                    .padding(.horizontal, 50)
                Button("Send") {
                    bluetooth.send(Array(string.utf8))
                }.buttonStyle(AppButton()).padding()
                Text("Got response: \(String(data: response, encoding: .utf8) ?? "")")
                if connectedToWifi {
                    Button("Run Servo") {
                        let url = URL(string: "http://\(String(data: response, encoding: .utf8)!)/run")!
                        let task = URLSession.shared.dataTask(with: url) {(data, _, _) in
                            guard let data = data else { return }
                            print(String(data: data, encoding: .utf8)!)
                        }
                        task.resume()
                    }
                }
            }
            Spacer()
        }.sheet(isPresented: $presented) {
            ScanView(bluetooth: bluetooth, presented: $presented, list: $list, isConnected: $isConnected)
        }.onAppear { bluetooth.delegate = self }
    }
}

extension ContentView: BluetoothProtocol {
    func state(state: BluetoothController.State) {
        switch state {
        case .unknown: print("◦ .unknown")
        case .resetting: print("◦ .resetting")
        case .unsupported: print("◦ .unsupported")
        case .unauthorized: print("◦ .unauthorized")
        case .poweredOff: print("◦ .poweredOff")
        case .poweredOn: print("◦ .poweredOn")
        case .error: print("• error")
        case .connected:
            print("◦ connected to \(bluetooth.current?.name ?? "")")
            isConnected = true
        case .disconnected:
            print("◦ disconnected")
            isConnected = false
        }
    }

    func list(list: [BluetoothController.Device]) {
        self.list = list
    }

    func value(data: Data) {
        response = data
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
