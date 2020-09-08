//
//  NetworkServiceManager.swift
//  CocktailDB
//
//  Created by Alex on 07.09.2020.
//  Copyright © 2020 Alex Sadunenko. All rights reserved.
//

import Foundation
import UIKit

class NetworkServiceManager {
    
    let baseURL = "https://www.thecocktaildb.com/api/json/v1/1/"
    
    func dataFetcherCategory(andpoint: String, complition: @escaping (CategoryModel) -> Void) {
        request(urlString: baseURL + andpoint) { (data, error) -> (Void) in
            let decoder = JSONDecoder()
            guard let data = data else { return }
            let response = try? decoder.decode(CategoryModel.self, from: data)
            complition(response!)
        }
    }
    
    func dataFetcherDrinks(andpoint: String, complition: @escaping (DrinksModel) -> Void) {
        var clearAndpoint = andpoint.replacingOccurrences(of: " ", with: "_")
        clearAndpoint = String(clearAndpoint.filter { !" \n\t\r".contains($0) })
        //clearAndpoint = andpoint.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        request(urlString: baseURL + clearAndpoint) { (data, error) -> (Void) in
            let decoder = JSONDecoder()
            guard let data = data, data.count != 0 else { return }
            let response = try? decoder.decode(DrinksModel.self, from: data)
            complition(response!)
        }
    }
   
    func dataFetcherImage(urlString: String, complition: @escaping (UIImage) -> Void) {
        var clearUrlString = urlString.replacingOccurrences(of: " ", with: "_")
        clearUrlString = String(clearUrlString.filter { !" \n\t\r".contains($0) })
        request(urlString: clearUrlString) { (data, error) -> (Void) in
            if let data = data, let someImage = UIImage(data: data) {
                complition(someImage)
            }
        }
    }
    
    func request(urlString: String, complition: @escaping (Data?, Error?) -> (Void)) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //DispatchQueue.main.async {
                complition(data, error)
            //}
        }
        task.resume()
    }
}
