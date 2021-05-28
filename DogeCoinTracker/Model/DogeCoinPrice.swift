//
//  DogeCoinPrice.swift
//  DogeCoinTracker
//
//  Created by Abraham Estrada on 5/11/21.
//

import Foundation

struct DogeCoinPrice: Decodable {
    var data: Data
}

struct Data: Decodable {
    var coin: Coin
}

struct Coin: Decodable {
    var price: String
}
