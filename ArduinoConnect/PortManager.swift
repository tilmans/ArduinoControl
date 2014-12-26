//
//  PortManager.swift
//  ArduinoConnect
//
//  Created by Tilman on 25/12/14.
//  Copyright (c) 2014 Tilman. All rights reserved.
//

import Foundation
import AudioToolbox

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
    var buffer = ""
    
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
            if (dataString.containsString("\n")) {
                let index = dataString.rangeOfString("\n")
                let front = dataString.substringToIndex(index.location)
                let final = buffer + front.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                buffer = dataString.substringFromIndex(index.location + 1)
                println(final)
                let components = final.componentsSeparatedByString(":")
                if (components.count == 2) {
                    if (components[0] == "V") {
                        if let volume = components[1].toInt() {
                            setAudio(volume)
                        }
                    }
                }
            } else {
                buffer += dataString
            }
        }
    }
    
    func serialPortWasRemovedFromSystem(serialPort: ORSSerialPort!) {
        print("Port removed")
    }
    
    func serialPort(serialPort: ORSSerialPort!, didEncounterError error: NSError!) {
        print("Error on port")
    }
    
    func setAudio(volume: Int) {
        var defaultOutputDeviceID = AudioDeviceID(0)
        var defaultOutputDeviceIDSize = UInt32(sizeofValue(defaultOutputDeviceID))
        
        var getDefaultOutputDevicePropertyAddress = AudioObjectPropertyAddress(
            mSelector: AudioObjectPropertySelector(kAudioHardwarePropertyDefaultOutputDevice),
            mScope: AudioObjectPropertyScope(kAudioObjectPropertyScopeGlobal),
            mElement: AudioObjectPropertyElement(kAudioObjectPropertyElementMaster))
        
        let status1 = AudioObjectGetPropertyData(
            AudioObjectID(kAudioObjectSystemObject),
            &getDefaultOutputDevicePropertyAddress,
            0,
            nil,
            &defaultOutputDeviceIDSize,
            &defaultOutputDeviceID)
        
        var volume = volume / 1023 // Float32(0.50) // 0.0 ... 1.0
        println(NSString(format:"Set audio to %f",volume))
        var volumeSize = UInt32(sizeofValue(volume))
        
        var volumePropertyAddress = AudioObjectPropertyAddress(
            mSelector: AudioObjectPropertySelector(kAudioHardwareServiceDeviceProperty_VirtualMasterVolume),
            mScope: AudioObjectPropertyScope(kAudioDevicePropertyScopeOutput),
            mElement: AudioObjectPropertyElement(kAudioObjectPropertyElementMaster))
        
        /*
        let status2 = AudioHardwareServiceSetPropertyData(
            defaultOutputDeviceID,
            &volumePropertyAddress,
            0,
            nil,
            volumeSize,
            &volume) */
    }
}