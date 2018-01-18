//
//  ViewController.swift
//  Currency Converter
//
//  Created by Pavel Lahoda on 12/01/2018.
//  Copyright © 2018 Actiwerks. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, CurrencyChangedDelegate, DateActionsDelegate {
    
    var latestConversion:Conversion?
    var dateConversion:Conversion?
    var sourceCurrency:String?
    var targetCurrency:String?
    
    @IBOutlet weak var convertedValueText:UITextView!
    @IBOutlet weak var amountField:UITextField!
    @IBOutlet weak var currencyPicker:UIPickerView!
    
    @IBOutlet weak var sourceButton:UIButton!
    @IBOutlet weak var targetButton:UIButton!
    
    @IBOutlet weak var dateButton:UIButton!
    @IBOutlet weak var datePicker:UIDatePicker!
    
    var dateButtonBlurView:UIView?
    
    var activeCurrencyPick:ActiveCurrencyPick?
    
    var currencyPickerDataSource = CurrencyPickerDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        amountField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        currencyPicker.delegate = currencyPickerDataSource
        currencyPicker.dataSource = currencyPickerDataSource
        currencyPickerDataSource.delegate = self
        if let keys = latestConversion?.getKeys() {
            currencyPickerDataSource.data = keys
            if keys.count > 1 {
                sourceCurrency = keys[0]
                targetCurrency = keys[1]
                sourceButton.setTitle(sourceCurrency, for: [])
                targetButton.setTitle(targetCurrency, for: [])
            }
        }
        datePicker.maximumDate = Date()
        setFormatedDate(Date())
        convertedValueText.textContainer.maximumNumberOfLines = 1
        convertedValueText.textContainer.lineBreakMode = .byTruncatingTail
        performConversion()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if dateButtonBlurView != nil {
            dateButtonBlurView!.frame = dateButton.bounds
        }
    }

    @IBAction func backgroundTouch() {
        if amountField.isFirstResponder {
            amountField.resignFirstResponder()
        }
        currencyPicker.isHidden = true
        datePicker.isHidden = true
        convertedValueText.selectedTextRange = nil
        activeCurrencyPick = nil
    }
    
    @IBAction func showSourceCurrencyPicker() {
        showPickerFor(button: sourceButton, pickType: CurrencyPickType.SOURCE)
    }
    
    @IBAction func showTargetCurrencyPicker() {
        showPickerFor(button: targetButton, pickType: CurrencyPickType.TARGET)
    }
    
    func showPickerFor(button:UIButton, pickType:CurrencyPickType) {
        if amountField.isFirstResponder {
            amountField.resignFirstResponder()
        }
        datePicker.isHidden = true
        currencyPicker.isHidden = false
        if let selectedIndex = currencyPickerDataSource.index(value: button.titleLabel!.text!) {
            currencyPicker.selectRow(selectedIndex, inComponent: 0, animated: true)
        }
        activeCurrencyPick = ActiveCurrencyPick(currencyPickType: pickType, currencyButton: button)
    }
    
    @IBAction func showDatePicker() {
        if amountField.isFirstResponder {
            amountField.resignFirstResponder()
        }
        currencyPicker.isHidden = true
        datePicker.isHidden = false
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        NetworkInteractor.fetchRatesForDate(date: sender.date, dateActionsDelegate: self)
    }
    
    func setFormatedDate(_ date:Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateButton.setTitle(dateFormatter.string(from: date), for: [])
        performConversion()
    }
    
    func notifyDateNotCorrect() {
        if dateButtonBlurView != nil {
            return
        }
        let blurEffect = UIBlurEffect(style: .regular)
        dateButtonBlurView = UIVisualEffectView(effect: blurEffect)
        dateButtonBlurView!.isUserInteractionEnabled = false
        dateButtonBlurView!.frame = dateButton.bounds
        dateButton.insertSubview(dateButtonBlurView!, at:0)
        dateButton.bringSubview(toFront: dateButtonBlurView!)
        dateButton.alpha = 0.5
    }
    
    func clearDateNotCorrect() {
        dateButtonBlurView?.removeFromSuperview()
        dateButton.alpha = 1.0
    }
    
    func performConversion() {
        if amountField.text!.isEmpty {
            convertedValueText.text = "\(String(format: "%.2f", 0.0))"
            return
        }
        guard let fromCurrency = sourceCurrency else {
            return
        }
        guard let toCurrency = targetCurrency else {
            return
        }
        if let fromValue = Double(amountField.text!) {
            if dateConversion != nil {
                if let convertedValue = dateConversion!.convert(value: fromValue, from: fromCurrency, to: toCurrency) {
                    convertedValueText.text = "\(String(format: "%.2f", convertedValue))"
                }
            } else {
                if let convertedValue = latestConversion?.convert(value: fromValue, from: fromCurrency, to: toCurrency) {
                    convertedValueText.text = "\(String(format: "%.2f", convertedValue))"
                }
            }
        } else {
            // delete input that can't be parsed
            amountField.text = ""
            performConversion()
        }
    }
    
    // MARK: -- DateActionsDelegate
    
    func dateRatesSuccess(date:Date, conversion:Conversion) {
        dateConversion = conversion
        DispatchQueue.main.async {
            self.setFormatedDate(date)
            self.clearDateNotCorrect()
        }
        
    }
    
    func dateRatesFailure(date:Date) {
        dateConversion = nil
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if latestConversion != nil { // sanity check, we should always have stored latest
            DispatchQueue.main.async {
                if let latestDate:Date = dateFormatter.date(from: self.latestConversion!.getDate()) {
                    self.setFormatedDate(date)
                    if Calendar.current.isDate(latestDate, inSameDayAs:date) {
                        self.clearDateNotCorrect()
                    } else {
                        self.notifyDateNotCorrect()
                    }
                } else {
                    self.notifyDateNotCorrect()
                }
            }
        }
    }
    
    // MARK: -- UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty { return true }
        let currentText = textField.text ?? ""
        let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return replacementText.isValidDouble(maxDecimalPlaces: 2)
    }
    
    @IBAction @objc func textFieldDidChange(_ textField: UITextField) {
        performConversion()
    }
    

    // MARK: -- CurrencyChangedDelegate
    
    func currencyChanged(_ pickerView: UIPickerView, title:String) {
        guard let activeCurrencyPick = activeCurrencyPick else {
            return
        }
        if activeCurrencyPick.currencyPickType == CurrencyPickType.SOURCE {
            sourceCurrency = title
        } else {
            targetCurrency = title
        }
        activeCurrencyPick.currencyButton.setTitle(title, for: [])
        performConversion()
    }
    

}

