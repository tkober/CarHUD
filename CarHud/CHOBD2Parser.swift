//
//  CHOBD2Parser.swift
//  CarHud
//
//  Created by Thorsten Kober on 17.08.15.
//  Copyright (c) 2015 Thorsten Kober. All rights reserved.
//

import Foundation


public let CHOBD2ParserErrorDomain = "BKDataParserErrorDomain"
private let CH_OBD2_PARSER_ERROR_NO_RULE_TO_APPLY_FOR_TOKEN_USER_INFO = [NSLocalizedDescriptionKey: "No parser rule was found for the scanned token."]


internal typealias CHOBD2ParserResult = (values: [CHOBD2ParserRuleResult], error: NSError?)


public enum CHOBD2ParserError: Int {
    case NoRuleToApplyForToken = 1
}


let CHDefaultOBD2ParserRules: [CHOBD2ParserRule] = [
    CHOBD2ParserRule(value: OBD_VALUE_SPEED),
    CHOBD2ParserRule(value: OBD_VALUE_RPM),
    CHOBD2ParserRule(value: OBD_VALUE_THROTTLE),
    CHOBD2ParserRule(value: OBD_VALUE_ENGINE_LOAD),
    CHOBD2ParserRule(value: OBD_VALUE_COOLANT_TEMP),
    CHOBD2ParserRule(value: OBD_VALUE_FUEL_PRESSURE),
    CHOBD2ParserRule(value: OBD_VALUE_RUNTIME),
    CHOBD2ParserRule(value: OBD_VALUE_FUEL_LEVEL),
    CHOBD2ParserRule(value: OBD_VALUE_DISTANCE),
    CHOBD2ParserRule(value: OBD_VALUE_CONTROL_MODULE_VOLTAGE),
    CHOBD2ParserRule(value: OBD_VALUE_AMBIENT_TEMP),
    CHOBD2ParserRule(value: OBD_VALUE_ENGINE_OIL_TEMP),
    CHOBD2ParserRule(value: OBD_VALUE_ENGINE_FUEL_RATE),
]


class CHOBD2Parser: NSObject {
    
    // MARK: - Internal
    // MARK: | Convinience Methods
    
    
    internal class func parseData(data: NSData) -> CHOBD2ParserResult {
        let parser = CHOBD2Parser(data: data)
        return parser.start()
    }
    
    
    // MARK: | Initializer
    
    
    internal init(data: NSData, rules: [CHOBD2ParserRule] = CHDefaultOBD2ParserRules) {
        self.data = data
        self.rules = rules
    }
    
    
    // MARK: | Parsing
    
    
    internal func start() -> CHOBD2ParserResult {
        var result: CHOBD2ParserResult = ([], nil)
        while (self.scanner.nextToken()) {
            if let rule = self.ruleForLookAhead(self.scanner.lookAhead!) {
                let ruleResult: CHOBD2ParserRuleResult = rule.apply(self.scanner)
                if let error = ruleResult.error {
                    result.error = error
                    break
                } else {
                    result.values.append(ruleResult)
                }
            } else {
                result.error = NSError(domain: CHOBD2ParserErrorDomain, code: CHOBD2ParserError.NoRuleToApplyForToken.rawValue, userInfo: CH_OBD2_PARSER_ERROR_NO_RULE_TO_APPLY_FOR_TOKEN_USER_INFO)
                break
            }
        }
        return result
    }
    
    
    
    // MARK: - Private
    // MARK: | Rules
    
    
    private var rules: [CHOBD2ParserRule]
    
    
    private func ruleForLookAhead(lookAhead: CHLookAhead) -> CHOBD2ParserRule? {
        for rule in self.rules {
            if rule.pid == lookAhead.asUInt8 {
                return rule
            }
        }
        return nil
    }
    
    
    // MARK: | Scanner
    
    
    private var data: NSData
    
    
    private lazy var scanner: CHScanner = CHScanner(data: self.data)
}