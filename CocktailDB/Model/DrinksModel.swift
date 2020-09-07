//
//  DrinksModel.swift
//  CocktailDB
//
//  Created by Alex on 07.09.2020.
//  Copyright © 2020 Alex Sadunenko. All rights reserved.
//

import Foundation

struct DrinksModel: Decodable {
    var drinks: [Drinks]
}

struct Drinks: Decodable {
    var strDrink: String
    var strDrinkThumb: String
    var idDrink: String
}
