//
//  CHLookAhead.swift
//  CarHud
//
//  Created by Thorsten Kober on 17.08.15.
//  Copyright (c) 2015 Thorsten Kober. All rights reserved.
//

import Foundation


typealias CHLookAhead = NSData


extension CHLookAhead {
    
    
    // MARK: - Internal
    // MARK: | 64 Bit
    
    
    var asInt64: Int64 {
        get {
            return Int64(bitPattern: self.asUInt64)
        }
    }
    
    
    var asUInt64: UInt64 {
        get {
            var value: UInt64 = 0
            self.getBytes(&value, length: min(sizeof(UInt64), self.length))
            return value
        }
    }
    
    
    // MARK: | 32 Bit
    
    
    var asInt32: Int32 {
        get {
            return Int32(bitPattern: self.asUInt32)
        }
    }
    
    
    var asUInt32: UInt32 {
        get {
            var value: UInt32 = 0
            self.getBytes(&value, length: min(sizeof(UInt32), self.length))
            return value
        }
    }
    
    
    // MARK: | 16 Bit
    
    
    var asInt16: Int16 {
        get {
            return Int16(bitPattern: self.asUInt16)
        }
    }
    
    
    var asUInt16: UInt16 {
        get {
            var value: UInt16 = 0
            self.getBytes(&value, length: min(sizeof(UInt16), self.length))
            return value
        }
    }
    
    
    // MARK: | 8 Bit
    
    
    var asInt8: Int8 {
        get {
            return Int8(bitPattern: self.asUInt8)
        }
    }
    
    
    var asUInt8: UInt8 {
        get {
            var value: UInt8 = 0
            self.getBytes(&value, length: min(sizeof(UInt8), self.length))
            return value
        }
    }
}