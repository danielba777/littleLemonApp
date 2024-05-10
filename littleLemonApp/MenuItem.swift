//
//  MenuItem.swift
//  littleLemonApp
//
//  Created by Daniel Bauer on 10.05.24.
//

import Foundation

struct MenuItem: Decodable{
    let title: String
    let image: String
    let price: String
    let category: String
    let description: String
}
