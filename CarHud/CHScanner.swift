//
//  CHScanner.swift
//  CarHud
//
//  Created by Thorsten Kober on 17.08.15.
//  Copyright (c) 2015 Thorsten Kober. All rights reserved.
//

import Foundation


class CHScanner: NSObject {
    
    
    // MARK: - Internal
    // MARK: | Look Ahead
    
    
    internal var lookAhead: CHLookAhead? {
        get {
            if self.isValidRange(self.currentRange) {
                return self.data?.subdataWithRange(self.currentRange)
            }
            return nil
        }
    }
    
    
    internal func nextToken(size: UInt8 = 1) -> Bool {
        self.currentRange = NSMakeRange(self.currentRange.location + self.currentRange.length, Int(size))
        return self.isValidRange(self.currentRange)
    }
    
    
    // MARK: | Initializer
    
    
    init(data: NSData) {
        self.data = data
    }
    
    
    // MARK: - Private
    // MARK: | Data
    
    
    private weak var data: NSData?
    
    
    // MARK: | Current Range
    
    
    private var currentRange: NSRange = NSMakeRange(0, 0)
    
    
    private func isValidRange(range: NSRange) -> Bool {
        return range.location >= 0 && range.location + range.length <= self.data?.length
    }
    
}