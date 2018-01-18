//
//  CurrencyPickerDataSource.swift
//  Curency Converter
//
//  Created by Pavel Lahoda on 12/01/2018.
//  Copyright © 2018 Actiwerks. All rights reserved.
//

import UIKit

protocol CurrencyChangedDelegate {
    func currencyChanged(_ pickerView: UIPickerView, title:String)
}

class CurrencyPickerDataSource : NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var delegate:CurrencyChangedDelegate?

    var data = ["USD", "EUR", "GBP"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        // Return a string from the array for this row.
        return data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.currencyChanged(pickerView, title: self.pickerView(pickerView, titleForRow: row, forComponent: 0)!)
    }
    
    func index(value:String) -> Int? {
        return data.index(of: value)
    }
}
