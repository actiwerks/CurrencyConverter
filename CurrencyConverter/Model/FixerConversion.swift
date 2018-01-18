//
//  FixerConversion.swift
//  CurrencyConverter
//
//  Created by Pavel Lahoda on 15/01/2018.
//  Copyright © 2018 Actiwerks. All rights reserved.
//

import Foundation

class FixerConversion : Conversion {
    
    let base:String
    let date:String
    let rates:[String:Double]
    
    init?(data:Data) {
        var workingRates:[String:Double] = [:]
        do {
            if let parsedData = try JSONSerialization.jsonObject(with: data) as? [String:Any] {
                base = parsedData["base"] as! String
                date = parsedData["date"] as! String
                let parsedRates = parsedData["rates"] as! [String:Any]
                for rate in parsedRates {
                    if let parsedValue = rate.value as? Double {
                        workingRates[rate.key] = parsedValue
                    }
                }
                if workingRates.count < 2 { // We need at least two currencies for set to work
                    return nil
                }
                rates = workingRates
            } else {
                return nil
            }
        } catch _ as NSError {
            return nil
        }
    }
    
    func getDate() -> String {
        return date
    }
    
    func getKeys() -> [String] {
        var keys:[String] = []
        keys.append(base)
        for key:String in rates.keys {
            keys.append(key)
        }
        return keys
    }
    
    func convert(value:Double, from:String, to:String) -> Double? {
        if from == to {
            return value
        }
        if from == base {
            if let rate = rates[to] {
                return rate * value
            } else {
                return nil
            }
        }
        guard let fromRate = rates[from] else {
            return nil
        }
        let toRate:Double
        if to == base {
            toRate = 1.0
        } else {
            guard let rate = rates[to] else {
                return nil
            }
            toRate = rate
        }
        return value / fromRate * toRate
    }
    
}

class FixerConversionAPI : ConversionAPI {
    
    func latestRatesURL() -> String {
        return Constants.CONVERSION_API_LATEST_URL
    }
    
    func ratesForDate(date:Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: date)
        let dateUrl = "\(Constants.CONVERSION_API_BASE_URL)\(components.year!)-\(String(format: "%02d", components.month!))-\(String(format: "%02d", components.day!))"
        return dateUrl
    }
    
    func conversionFrom(data:Data) -> Conversion? {
        return FixerConversion(data: data)
    }
}
