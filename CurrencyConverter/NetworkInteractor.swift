//
//  NetworkInteractor.swift
//  CurrencyConverter
//
//  Created by Pavel Lahoda on 15/01/2018.
//  Copyright © 2018 Actiwerks. All rights reserved.
//

import Foundation
import Alamofire

protocol StartActionsDelegate {
    func useStoredLatestRates()
    func showMainController(latestRates:Conversion)
}

protocol DateActionsDelegate {
    func dateRatesSuccess(date:Date, conversion:Conversion)
    func dateRatesFailure(date:Date)
}

class NetworkInteractor {
    
    class func fetchLatestRates(startActionsDelegate:StartActionsDelegate) {
        Alamofire.request(Constants.CURRENT_CONVERSION_API.latestRatesURL()).responseJSON { response in
            if let json = response.data {
                if let latestConversion = Constants.CURRENT_CONVERSION_API.conversionFrom(data: json) {
                    UserDefaults.standard.set(json, forKey: Constants.DEFAULTS_LATEST_KEY)
                    UserDefaults.standard.synchronize()
                    startActionsDelegate.showMainController(latestRates: latestConversion)
                } else {
                    startActionsDelegate.useStoredLatestRates()
                }
            } else {
                startActionsDelegate.useStoredLatestRates()
            }
        }
    }
    
    class func fetchRatesForDate(date:Date, dateActionsDelegate: DateActionsDelegate) {
        Alamofire.SessionManager.default.session.getAllTasks { tasks in
            tasks.forEach { $0.cancel() }
        }
        Alamofire.request(Constants.CURRENT_CONVERSION_API.ratesForDate(date: date)).responseJSON { response in
            if let json = response.data {
                if let dateConversionRates = Constants.CURRENT_CONVERSION_API.conversionFrom(data: json) {
                    dateActionsDelegate.dateRatesSuccess(date: date, conversion: dateConversionRates)
                } else {
                    dateActionsDelegate.dateRatesFailure(date: date)
                }
            } else {
                dateActionsDelegate.dateRatesFailure(date: date)
            }
        }
    }
}
