//
//  CHScanner.swift
//  CarHud
//
//  Created by Thorsten Kober on 17.08.15.
//  Copyright (c) 2015 Thorsten Kober. All rights reserved.
//

import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}



class CHScanner: NSObject {
    
    
    // MARK: - Internal
    // MARK: | Look Ahead
    
    
    internal var lookAhead: CHLookAhead? {
        get {
            if self.isValidRange(self.currentRange) {
                return self.data?.subdata(in: self.currentRange)
            }
            return nil
        }
    }
    
    
    internal func nextToken(_ size: UInt8 = 1) -> Bool {
        self.currentRange = NSMakeRange(self.currentRange.location + self.currentRange.length, Int(size))
        return self.isValidRange(self.currentRange)
    }
    
    
    // MARK: | Initializer
    
    
    init(data: Data) {
        self.data = data
    }
    
    
    // MARK: - Private
    // MARK: | Data
    
    
    fileprivate weak var data: Data?
    
    
    // MARK: | Current Range
    
    
    fileprivate var currentRange: NSRange = NSMakeRange(0, 0)
    
    
    fileprivate func isValidRange(_ range: NSRange) -> Bool {
        return range.location >= 0 && range.location + range.length <= self.data?.count
    }
    
}
