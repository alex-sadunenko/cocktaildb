//
//  CategoriesModel.swift
//  CocktailDB
//
//  Created by Alex on 07.09.2020.
//  Copyright © 2020 Alex Sadunenko. All rights reserved.
//

import Foundation

struct CategoryModel: Decodable {
    var drinks: [Category]
}

struct Category: Decodable {
    var strCategory: String
}
