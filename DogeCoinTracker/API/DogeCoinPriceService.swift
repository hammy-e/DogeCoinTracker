//
//  DogeCoinPriceService.swift
//  DogeCoinTracker
//
//  Created by Abraham Estrada on 5/11/21.
//

import Foundation

protocol DogeCoinPriceServiceDelegate: AnyObject {
    func didFetchPrice(price: Double)
}

struct DogeCoinPriceService {
    let apiURL = "https://api.coinranking.com/v2/coin/"
    let dogeCoinUID = "a91GCGd_u96cF"
    
    var delegate: DogeCoinPriceServiceDelegate?
    
    func fetchPrice() {
        guard let url = URL(string: "\(apiURL)\(dogeCoinUID)") else {return}
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, _, _ in
            guard let data = data else {return}
            let decoder = JSONDecoder()
            do {
                let dogeCoinPriceData = try decoder.decode(DogeCoinPrice.self, from: data)
                delegate?.didFetchPrice(price: Double(dogeCoinPriceData.data.coin.price)!)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
