//
//  main.swift
//  ArduinoConnect
//
//  Created by Tilman on 25/12/14.
//  Copyright (c) 2014 Tilman. All rights reserved.
//

import Foundation

let connect = PortManager()
connect.openPort()
CFRunLoopRun()
