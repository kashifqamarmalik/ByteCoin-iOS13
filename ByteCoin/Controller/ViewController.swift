//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CoinManagerDelegate {
    
    

    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       let currencySelected =  coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: currencySelected)
        
    }
    
    
    func didUpdateCurrency(_ coinData: CoinData) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = String(format: "%.2f", coinData.rate)
            self.currencyLabel.text = coinData.asset_id_quote
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    

}


