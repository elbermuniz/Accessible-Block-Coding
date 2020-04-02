import Foundation
import CoreBluetooth

protocol CommandType {
    var answer: Bool { get }
    var resetTimeout: Bool { get }
    var deviceID: UInt8 { get }
    var commandID: UInt8 { get }
    var payload: Data? { get }
}

extension CommandType {
    var answer: Bool {
        return true
    }
    
    var resetTimeout: Bool {
        return true
    }
    
    var sop2: UInt8 {
        var value: UInt8 = 0b11111100
        if answer {
            value |= 1 << 1
        }
        if resetTimeout {
            value |= 1 << 0
        }
        
        return value
    }
    
    func dataForPacket(sequenceNumber: UInt8 = 0) -> Data {
        let payloadLength = payload?.count ?? 0
        var zero: UInt8 = 0
        var data = Data(bytes: &zero, count: 6)
        
        data[0] = 0b11111111
        data[1] = sop2
        data[2] = deviceID
        data[3] = commandID
        data[4] = sequenceNumber
        data[5] = UInt8(payloadLength + 1)
        
        if let payload = payload {
            data.append(payload)
        }
        
        let checksumTarget = data[2 ..< data.count]
        
        var checksum: UInt8 = 0
        for byte in checksumTarget {
            checksum = checksum &+ byte
        }
        checksum = ~checksum
        
        data.append(Data(_: [checksum]))
        
        return data
    }
}

protocol CoreCommandType: CommandType {
    
}

extension CoreCommandType {
    var deviceID: UInt8 {
        return 0x00
    }
}

protocol SpheroCommandType: CommandType {
    
}

extension SpheroCommandType {
    var deviceID: UInt8 {
        return 0x02
    }
}

struct PingCommand: CoreCommandType {
    let commandID: UInt8 = 0x01
    let payload: Data? = nil
}

struct UpdateHeadingCommand: SpheroCommandType {
    let commandID: UInt8 = 0x01
    
    var heading: UInt16
    init(heading: UInt16) {
        self.heading = heading
    }
    
    var payload: Data? {
        let clampedHeading = (heading % 360)
        let headingLeft = UInt8((clampedHeading >> 8) & 0xff)
        let headingRight = UInt8(clampedHeading & 0xff)
        
        return Data(_: [headingLeft, headingRight])
    }
}

struct SetLedColor: SpheroCommandType {
    let commandID:UInt8 = 0x20
    
    var red: UInt8
    var green: UInt8
    var blue: UInt8
    var save: Bool
    
    init(red: UInt8, green: UInt8, blue: UInt8, save: Bool = false) {
        self.red = red
        self.green = green
        self.blue = blue
        self.save = save
    }
    
    var payload: Data? {
        let data = Data(_: [red, green, blue, save ? 1 : 0])
        return data
    }
}

struct SetBackLEDBrightness: SpheroCommandType {
    let commandID: UInt8 = 0x21
    
    var brightness: UInt8
    
    init(brightness: UInt8) {
        self.brightness = brightness
    }
    
    var payload: Data? {
        let data = Data(_: [brightness])
        return data
    }
}

struct RollCommand: SpheroCommandType {
    let commandID: UInt8 = 0x30
    
    var speed: UInt8
    var heading: UInt16
    var state: UInt8
    
    init(speed: UInt8, heading: UInt16, state: UInt8 = 1) {
        self.speed = speed
        self.heading = heading
        self.state = state
    }
    
    var payload: Data? {
        let clampedHeading = (heading % 360)
        let headingLeft = UInt8((clampedHeading >> 8) & 0xff)
        let headingRight = UInt8(clampedHeading & 0xff)
        
        return Data(_: [speed, headingLeft, headingRight, state])
    }
}

public class SpheroController: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    public var rearLedBrightness: UInt8 = 0 {
        didSet {
            let brightnessCommand = SetBackLEDBrightness(brightness: rearLedBrightness)
            sphero.availablePeripheral?.writeValue(brightnessCommand.dataForPacket(), for: commandsCharacteristic, type: .withResponse)
        }
    }
    
    public func roll(velocity: UInt8, heading: UInt16) {
        let rollCommand = RollCommand(speed: velocity, heading: heading)
        sphero.availablePeripheral?.writeValue(rollCommand.dataForPacket(), for:
            commandsCharacteristic, type: .withResponse)
    }
    
    public func turnLeft(heading: UInt16) {
        let clampedHeading = 360 - (heading % 360)
        let rollCommand = RollCommand(speed: 0, heading: clampedHeading)
        sphero.availablePeripheral?.writeValue(rollCommand.dataForPacket(), for:
            commandsCharacteristic, type: .withResponse)
    }
    
    public func turnRight(heading: UInt16) {
        let clampedHeading = heading % 360
        let rollCommand = RollCommand(speed: 0, heading: clampedHeading)
        sphero.availablePeripheral?.writeValue(rollCommand.dataForPacket(), for:
            commandsCharacteristic, type: .withResponse)
    }
    
    public func updateHeading(heading: UInt16) {
        let updateHeading = UpdateHeadingCommand(heading: heading)
        sphero.availablePeripheral?.writeValue(updateHeading.dataForPacket(), for: commandsCharacteristic, type: .withResponse)
    }
    
    private enum Peripheral {
        case none
        case attached(CBPeripheral)
        case available(CBPeripheral)
        
        var availablePeripheral: CBPeripheral? {
            get {
                if case let .available(sphero) = self {
                    return sphero
                } else {
                    return nil
                }
            }
        }
    }
    
    private enum Service {
        static let BLE = CBUUID(string: "22bb746f-2bb0-7554-2d6f-726568705327")
        static let RobotControl = CBUUID(string: "22bb746f-2ba0-7554-2d6f-726568705327")
    }
    
    private enum Characteristic {
        // BLE service
        static let Wake = CBUUID(string: "22bb746f-2bbf-7554-2d6f-726568705327")
        static let TXPower = CBUUID(string: "22bb746f-2bb2-7554-2d6f-726568705327")
        static let AntiDoS = CBUUID(string: "22bb746f-2bbd-7554-2d6f-726568705327")
        
        // RobotControl service
        static let Commands = CBUUID(string: "22bb746f-2ba1-7554-2d6f-726568705327")
        static let Response = CBUUID(string: "22bb746f-2ba6-7554-2d6f-726568705327")
    }
    
    lazy var central: CBCentralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    
    public func connectToSpheroIfAvailable() {
        _ = central
        print("Trying to connect")
    }
    
    private var sphero: Peripheral = .none
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            central.scanForPeripherals(withServices: [Service.RobotControl], options: nil)
            print("Central Manager On")
        case .poweredOff:
            central.stopScan()
            print("Central Manager Off")
        case .resetting:
            break
        case .unauthorized:
            break
        case .unknown:
            break
        case .unsupported:
           break
        default:
            break
        }
    }
    
    var peripherals: [CBPeripheral: Int] = [:]
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        peripherals[peripheral] = RSSI.intValue
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(5)) {
            if case .none = self.sphero {
                let peripheral: CBPeripheral
                let sortedKeys = Array(self.peripherals.keys).sorted { left, right in
                    return self.peripherals[left]! > self.peripherals[right]!
                }
                peripheral = sortedKeys.first!
                self.sphero = .attached(peripheral)
                central.connect(peripheral, options: nil)
                central.stopScan()
            }
        }
        
        print("Discovered")
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected")
        peripheral.delegate = self
        peripheral.discoverServices([Service.BLE, Service.RobotControl])
    }
       
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
           peripheral.delegate = nil
           sphero = .none
    }
       
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
		print("Failed: \(String(describing: error))")
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            return
        }
        
        services.forEach { service in
            switch service.uuid {
            case let uuid where uuid == Service.BLE:
                peripheral.discoverCharacteristics([Characteristic.Wake, Characteristic.TXPower, Characteristic.AntiDoS], for: service)
            case let uuid where uuid == Service.RobotControl:
                peripheral.discoverCharacteristics([Characteristic.Commands, Characteristic.Response], for: service)
            default:
                fatalError("We should only find either the BLE or RobotControl service!")
            }
        }
    }
    
    var wakeCharacteristic: CBCharacteristic!
    var txPowerCharacteristic: CBCharacteristic!
    var antiDoSCharacteristic: CBCharacteristic!
    var commandsCharacteristic: CBCharacteristic!
    var responseCharacteristic: CBCharacteristic!
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }
        
        characteristics.forEach { characteristic in
            switch characteristic.uuid {
            case let uuid where uuid == Characteristic.Wake:
                wakeCharacteristic = characteristic
            case let uuid where uuid == Characteristic.TXPower:
                txPowerCharacteristic = characteristic
            case let uuid where uuid == Characteristic.AntiDoS:
                antiDoSCharacteristic = characteristic
            case let uuid where uuid == Characteristic.Commands:
                commandsCharacteristic = characteristic
            case let uuid where uuid == Characteristic.Response:
                responseCharacteristic = characteristic
            default:
                fatalError("Unknown characteristic")
            }
            
            if wakeCharacteristic != nil &&
                txPowerCharacteristic != nil &&
                antiDoSCharacteristic != nil &&
                commandsCharacteristic != nil &&
                responseCharacteristic != nil {
                peripheral.writeValue("011i3".data(using: String.Encoding.ascii)!, for: antiDoSCharacteristic, type: .withResponse)
            }
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic === responseCharacteristic {
            sphero = .available(peripheral)
            rearLedBrightness = 128
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic === antiDoSCharacteristic {
            peripheral.writeValue(Data(_: [7]), for: txPowerCharacteristic, type: .withResponse)
        }
        else if characteristic === txPowerCharacteristic {
            peripheral.writeValue(Data(_: [1]), for: wakeCharacteristic, type: .withResponse)
        }
        else if characteristic === wakeCharacteristic {
            peripheral.setNotifyValue(true, for: responseCharacteristic)
        }
        else if characteristic === commandsCharacteristic {
        }
    }
    
    public func disconnect() {
        if let sphero = sphero.availablePeripheral {
            central.cancelPeripheralConnection(sphero)
            print("Disconnected")
        }
    }
}
