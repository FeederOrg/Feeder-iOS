//
//  BluetoothController.swift
//  Feeder-iOS
//
//  Created by Joe Diragi on 8/25/22.
//

import CoreBluetooth

protocol BluetoothProtocol {
    func state(state: BluetoothController.State)
    func list(list: [BluetoothController.Device])
    func value(data: Data)
}

final class BluetoothController: NSObject {
    static let shared = BluetoothController()
    var delegate: BluetoothProtocol?

    var peripherals = [Device]()
    var current: CBPeripheral?
    var state: State = .unknown { didSet { delegate?.state(state: state) } }

    private var manager: CBCentralManager?
    private var apCharacteristic: CBCharacteristic?

    private override init() {
        super.init()
        manager = CBCentralManager(delegate: self, queue: .none)
        manager?.delegate = self
    }

    func connect(_ peripheral: CBPeripheral) {
        if current != nil {
            guard let current = current else { return }
            manager?.cancelPeripheralConnection(current)
            manager?.connect(peripheral, options: nil)
        } else { manager?.connect(peripheral, options: nil) }
    }

    func disconnect() {
        guard let current = current else { return }
        manager?.cancelPeripheralConnection(current)
    }

    func startScanning() {
        peripherals.removeAll()
        manager?.scanForPeripherals(withServices: nil)
    }

    func stopScanning() {
        peripherals.removeAll()
        manager?.stopScan()
    }

    func send(_ value: [UInt8]) {
        print("Sending...")
        guard let characteristic = apCharacteristic else { return }
        current?.writeValue(Data(value), for: characteristic, type: .withResponse)
    }

    enum State {
        case unknown, resetting, unsupported, unauthorized, poweredOff, poweredOn, error, connected, disconnected
    }

    struct Device: Identifiable {
        let id: Int
        let rssi: Int
        let uuid: String
        let peripheral: CBPeripheral
    }
}

extension BluetoothController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch manager?.state {
        case .unknown: state = .unknown
        case .resetting: state = .resetting
        case .unsupported: state = .unsupported
        case .unauthorized: state = .unauthorized
        case .poweredOff: state = .poweredOff
        case .poweredOn: state = .poweredOn
        default: state = .error
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        let uuid = String(describing: peripheral.identifier)
        let filtered = peripherals.filter { $0.uuid == uuid }
        if filtered.count == 0 {
            guard peripheral.name != nil else { return }
            let new = Device(id: peripherals.count, rssi: RSSI.intValue, uuid: uuid, peripheral: peripheral)
            peripherals.append(new)
            delegate?.list(list: peripherals)
        }
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error!)
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        current = nil
        state = .disconnected
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        current = peripheral
        state = .connected
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
}

extension BluetoothController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics
            where characteristic.uuid == CBUUID(string: Constants.CHARACTERISTICUUID) {
            apCharacteristic = characteristic
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
    }
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {}
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let value = characteristic.value else { return }
        delegate?.value(data: value)
    }
}
