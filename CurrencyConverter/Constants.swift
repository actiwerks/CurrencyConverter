//
//  Constants.swift
//  Curency Converter
//
//  Created by Pavel Lahoda on 12/01/2018.
//  Copyright © 2018 Actiwerks. All rights reserved.
//

import Foundation

class Constants {
    
    static let CONVERSION_API_BASE_URL:String = "https://api.fixer.io/"
    
    static let CONVERSION_API_LATEST_URL:String = "\(CONVERSION_API_BASE_URL)/latest"
    
    static let DEFAULTS_LATEST_KEY:String = "defaults.latest_key"
    
    static let CURRENT_CONVERSION_API:ConversionAPI = FixerConversionAPI()
    
}
