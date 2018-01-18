//
//  ActiveCurrencyPick.swift
//  CurrencyConverter
//
//  Created by Pavel Lahoda on 14/01/2018.
//  Copyright © 2018 Actiwerks. All rights reserved.
//

import Foundation
import UIKit

enum CurrencyPickType {
    case SOURCE
    case TARGET
}

struct ActiveCurrencyPick {
    var currencyPickType:CurrencyPickType
    var currencyButton:UIButton
}
