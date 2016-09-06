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
    case InsufficientData   = 1
    case UndefinedValue    = 2
}


enum CHOBD2ParserRuleValueSize: UInt8 {
    case U_INT_8      = 1
    case U_INT_16     = 2
    case U_INT_32     = 4
}


class CHOBD2ParserRule: NSObject {
    
    
    // MARK: - Internal
    // MARK: | Initializer
    
    
    convenience init(value: OBDValue) {
        self.init(pid: value.pid, valueSize: CHOBD2ParserRuleValueSize(rawValue: value.size)!)
    }
    
    
    init(pid: CHOBD2_PID, valueSize: CHOBD2ParserRuleValueSize = CHOBD2ParserRuleValueSize.U_INT_8) {
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
    
    
    func apply(scanner: CHScanner) -> CHOBD2ParserRuleResult {
        var result: CHOBD2ParserRuleResult = (self.pid, nil, nil)
        if !scanner.nextToken(self.valueSize.rawValue) {
            result.error = NSError(domain: CHOBD2ParserRuleErrorDomain, code: CHOBD2ParserRuleError.InsufficientData.rawValue, userInfo: CH_OBD2_PARSING_RULE_ERROR_INSUFFICIENT_DATA_USER_INFO)
            return result
        }
        result.value = self.transformValue(scanner.lookAhead!, withSize: self.valueSize)
        return result
    }
    
    
    // MARK: - Private
    // MARK: | PID
    
    
    private var _pid: CHOBD2_PID
    private var valueSize: CHOBD2ParserRuleValueSize
    
    
    // MARK: | Value Transformation
    
    
    private func transformValue(value: CHLookAhead, withSize size: CHOBD2ParserRuleValueSize) -> NSNumber {
        switch size {

        case .U_INT_8:
            return NSNumber(unsignedChar: value.asUInt8)
            
        case .U_INT_16:
            return NSNumber(unsignedShort: UInt16(bigEndian:value.asUInt16))
            
        case .U_INT_32:
            return NSNumber(unsignedInt: UInt32(bigEndian: value.asUInt32))
        }
    }
}