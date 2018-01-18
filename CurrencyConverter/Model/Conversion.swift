//
//  Conversion.swift
//  Curency Converter
//
//  Created by Pavel Lahoda on 12/01/2018.
//  Copyright © 2018 Actiwerks. All rights reserved.
//

import Foundation

protocol Conversion {
    
    func getDate() -> String
    func getKeys() -> [String]
    func convert(value:Double, from:String, to:String) -> Double?
    
}

protocol ConversionAPI {
    
    func latestRatesURL() -> String
    func ratesForDate(date:Date) -> String
    func conversionFrom(data:Data) -> Conversion?
}

