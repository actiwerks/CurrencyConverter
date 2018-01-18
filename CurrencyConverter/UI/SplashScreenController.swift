//
//  SplashScreenController.swift
//  CurrencyConverter
//
//  Created by Pavel Lahoda on 14/01/2018.
//  Copyright © 2018 Actiwerks. All rights reserved.
//

import UIKit

class SplashScreenController:UIViewController, StartActionsDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkInteractor.fetchLatestRates(startActionsDelegate: self)
    }
    
    func useStoredLatestRates() {
        if let storedLatest = getStoredLatestRates() {
            showMainController(latestRates: storedLatest)
        } else {
            showSadFace()
        }
    }
    
    func getStoredLatestRates() -> Conversion? {
        if let latestData = UserDefaults.standard.data(forKey: Constants.DEFAULTS_LATEST_KEY) {
            return Constants.CURRENT_CONVERSION_API.conversionFrom(data: latestData)
        }
        return nil
    }
    
    func showMainController(latestRates:Conversion) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainController = storyboard.instantiateViewController(withIdentifier: "MAIN_VIEW_ID") as? ViewController
        mainController?.latestConversion = latestRates
        UIApplication.shared.keyWindow?.rootViewController = mainController
    }
    
    func showSadFace() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sadFace = storyboard.instantiateViewController(withIdentifier: "SAD_FACE_ID")
        UIApplication.shared.keyWindow?.rootViewController = sadFace
    }
    
}
