//
//  CurrencyConverterUITests.swift
//  CurrencyConverterUITests
//
//  Created by Pavel Lahoda on 15/01/2018.
//  Copyright © 2018 Actiwerks. All rights reserved.
//

import XCTest

class CurrencyConverterUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testInteractions() {
        app.otherElements.containing(.textField, identifier:"amount").element.tap()
        XCTAssert(app.pickers.count == 0, "Currency picker still shown")
        app/*@START_MENU_TOKEN@*/.buttons["target"]/*[[".buttons[\"Target\"]",".buttons[\"target\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssert(app.pickers["currencyPicker"].isEnabled, "Currency picker not shown")
        app.pickers["currencyPicker"].pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "EUR")
        let amountTextField = app/*@START_MENU_TOKEN@*/.textFields["amount"]/*[[".textFields[\"0\"]",".textFields[\"amount\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        amountTextField.tap()
        XCTAssert(app.keyboards.count > 0, "The keyboard is not shown")
        amountTextField.typeText("10")
        let valueTextView = app.textViews["value"]
        XCTAssertEqual(valueTextView.value as! String, "10.00", "Value should be 10.00")
        app.otherElements.containing(.textField, identifier:"amount").element.tap()
        XCTAssert(app.keyboards.count == 0, "The keyboard is still shown")
        
    }
    
    func testDatesInteractions() {
        app/*@START_MENU_TOKEN@*/.buttons["date"]/*[[".buttons[\"Date\"]",".buttons[\"date\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.datePickers.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2015")
        sleep(5)
        app.otherElements.containing(.textField, identifier:"amount").element.tap()
        XCTAssert(app.datePickers.count == 0, "Date picker still shown")
        //XCTAssert(app.buttons["date"].title.contains("2015"), "The date not updated") // Title is not set in the test
    }
    
    
}
