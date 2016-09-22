//
//  CHOBD2ParserRule.swift
//  CarHud
//
//  Created by Thorsten Kober on 17.08.15.
//  Copyright (c) 2015 Thorsten Kober. All rights reserved.
//

import Foundation


typealias CHOBD2ParserRuleResult = (pid: CHOBD2_PID, value: NSNumber?, error: NSError?)


let CHOBD2ParserRuleErrorDomain = "CHOBD2ParserRuleErrorDomain"

let CH_OBD2_PARSING_RULE_ERROR_INSUFFICIENT_DATA_USER_INFO = [NSLocalizedDescriptionKey: "The remaining data are are not long enough for the applied rule."]
let CH_OBD2_PARSING_RULE_ERROR_UNDEFINED_VALUE_USER_INFO = [NSLocalizedDescriptionKey: "The parsed value is not defined for the applied rule."]


enum CHOBD2ParserRuleError: Int {
    case insufficientData   = 1
    case undefinedValue    = 2
}


enum CHOBD2ParserRuleValueSize: UInt8 {
    case u_INT_8      = 1
    case u_INT_16     = 2
    case u_INT_32     = 4
}


class CHOBD2ParserRule: NSObject {
    
    
    // MARK: - Internal
    // MARK: | Initializer
    
    
    convenience init(value: OBDValue) {
        self.init(pid: value.pid, valueSize: CHOBD2ParserRuleValueSize(rawValue: value.size)!)
    }
    
    
    init(pid: CHOBD2_PID, valueSize: CHOBD2ParserRuleValueSize = CHOBD2ParserRuleValueSize.u_INT_8) {
        self._pid = pid
        self.valueSize = valueSize
    }
    
    
    // MARK: | Identifier
    
    
    var pid: CHOBD2_PID {
        get {
            return self._pid
        }
    }
    
    
    // MARK: | Applying Rule
    
    
    func apply(_ scanner: CHScanner) -> CHOBD2ParserRuleResult {
        var result: CHOBD2ParserRuleResult = (self.pid, nil, nil)
        if !scanner.nextToken(self.valueSize.rawValue) {
            result.error = NSError(domain: CHOBD2ParserRuleErrorDomain, code: CHOBD2ParserRuleError.insufficientData.rawValue, userInfo: CH_OBD2_PARSING_RULE_ERROR_INSUFFICIENT_DATA_USER_INFO)
            return result
        }
        result.value = self.transformValue(scanner.lookAhead!, withSize: self.valueSize)
        return result
    }
    
    
    // MARK: - Private
    // MARK: | PID
    
    
    fileprivate var _pid: CHOBD2_PID
    fileprivate var valueSize: CHOBD2ParserRuleValueSize
    
    
    // MARK: | Value Transformation
    
    
    fileprivate func transformValue(_ value: CHLookAhead, withSize size: CHOBD2ParserRuleValueSize) -> NSNumber {
        switch size {

        case .u_INT_8:
            return NSNumber(value: value.asUInt8 as UInt8)
            
        case .u_INT_16:
            return NSNumber(value: value.asUInt16 as UInt16)
            
        case .u_INT_32:
            return NSNumber(value: value.asUInt32 as UInt32)
        }
    }
}
