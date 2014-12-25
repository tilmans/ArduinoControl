//
//  PortManager.swift
//  ArduinoConnect
//
//  Created by Tilman on 25/12/14.
//  Copyright (c) 2014 Tilman. All rights reserved.
//

import Foundation

class PortManager: NSObject, ORSSerialPortDelegate, NSUserNotificationCenterDelegate {

    let device = "/dev/tty.usbmodem621"
    let baud = 9600
    let serialPortManager = ORSSerialPortManager.sharedSerialPortManager()
    let availableBaudRates = [300, 1200, 2400, 4800, 9600, 14400, 19200, 28800, 38400, 57600, 115200, 230400]
    
    var serialPort: ORSSerialPort? {
        didSet {
            oldValue?.close()
            oldValue?.delegate = nil
            serialPort?.delegate = self
        }
    }
    
    func openPort() {
        let port = ORSSerialPort(path: device)
        port.baudRate = baud
        port.open()
        self.serialPort = port
    }
    
    //MARK: Delegate
    func serialPortWasOpened(serialPort: ORSSerialPort!) {
        print("Port was opened")
    }
    
    func serialPortWasClosed(serialPort: ORSSerialPort!) {
        print("Port was closed")
    }
    
    func serialPort(serialPort: ORSSerialPort!, didReceiveData data: NSData!) {
        if let dataString = NSString(data:data, encoding:NSUTF8StringEncoding) {
            print(dataString)
        }
    }
    
    func serialPortWasRemovedFromSystem(serialPort: ORSSerialPort!) {
        print("Port removed")
    }
    
    func serialPort(serialPort: ORSSerialPort!, didEncounterError error: NSError!) {
        print("Error on port")
    }
}