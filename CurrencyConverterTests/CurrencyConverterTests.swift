//
//  CurrencyConverterTests.swift
//  CurrencyConverterTests
//
//  Created by Pavel Lahoda on 15/01/2018.
//  Copyright © 2018 Actiwerks. All rights reserved.
//

import XCTest
@testable import CurrencyConverter

class CurrencyConverterTests: XCTestCase {
    
    
    func testConversions() {
        
        let dataString:NSString = "{\"base\":\"EUR\",\"date\":\"2018-01-11\",\"rates\":{\"AUD\":1.5281,\"BGN\":1.9558,\"BRL\":3.8858,\"CAD\":1.5093,\"CHF\":1.1736,\"CNY\":7.8127,\"CZK\":25.547,\"DKK\":7.4474,\"GBP\":0.89075,\"HKD\":9.4002,\"HRK\":7.4538,\"HUF\":309.43,\"IDR\":16102.0,\"ILS\":4.1134,\"INR\":76.534,\"JPY\":134.19,\"KRW\":1282.3,\"MXN\":23.305,\"MYR\":4.7905,\"NOK\":9.6735,\"NZD\":1.6653,\"PHP\":60.589,\"PLN\":4.1785,\"RON\":4.6413,\"RUB\":68.465,\"SEK\":9.8203,\"SGD\":1.6006,\"THB\":38.46,\"TRY\":4.5648,\"USD\":1.2017,\"ZAR\":14.974}}"
        
        let data = dataString.data(using: String.Encoding.utf8.rawValue)!
        let conversion = Conversion(data: data)
        XCTAssert(conversion != nil)
        
        let value1 = conversion?.convert(value: 1, from: "EUR", to: "EUR")
        XCTAssert(value1 == 1.0)
        
        let value2 = conversion?.convert(value: 123.5, from: "CZK", to: "USD")
        XCTAssert(value2 == 5.8092907190668175)
        
        let value3 = conversion?.convert(value: 666.33, from: "NZD", to: "EUR")
        XCTAssert(value3 == 400.12610340479193)
    }
    
}
