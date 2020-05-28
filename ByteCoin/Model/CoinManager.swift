//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCurrency(_ coinData: CoinData)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "4FF60054-6104-4704-B4D3-178A6CBFB515"
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String){
        let urlString = "\(baseURL)/\(currency)?apiKey=\(apiKey)"
        
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        
        if let url = URL(string: urlString){
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url){ (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
            }
                
                //let dataAsString = String.init(data: data!, encoding: .utf8)
                //print(dataAsString ?? "No data came as string")
            
            if let safeData = data {
                if let bitCoinData = self.parseJSON(safeData){
                    self.delegate?.didUpdateCurrency(bitCoinData)
                }
            }
                
                
            }
        
        
        task.resume()
        }
        
    }

    
    
    func parseJSON(_ data: Data) -> CoinData? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            let lastCurrency = decodedData.asset_id_quote
            
            
            let coinData = CoinData(rate: lastPrice, asset_id_quote: lastCurrency)
            return coinData
            
        } catch {
            print(error)
            return nil
        }
    }
    
}
