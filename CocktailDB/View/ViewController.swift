//
//  ViewController.swift
//  CocktailDB
//
//  Created by Alex on 07.09.2020.
//  Copyright © 2020 Alex Sadunenko. All rights reserved.
//

import UIKit

var categories: CategoryModel!
var drinks: DrinksModel!
var networking = NetworkServiceManager()

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func filterTapped(_ sender: UIBarButtonItem) {
        print(categories.drinks)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networking.dataFetcherCategory(andpoint: "list.php?c=list") { (currentModel) in
            categories = currentModel
            guard let category = categories.drinks.first else { return }
            self.getPartDrinks(category: category.strCategory)
        }
        
//        let queue = DispatchQueue.global(qos: .utility)
//        queue.async {
//            networking.dataFetcherCategory(andpoint: "list.php?c=list") { (currentModel) in
//                categories = currentModel
//                guard let category = categories.drinks.first else { return }
//                DispatchQueue.main.async {
//                    self.getPartDrinks(category: category.strCategory)
//                }
//                //self.getPartDrinks(category: category.strCategory)
//            }
//            //categories = currentModel
//        }
        
//        delay(1) {
//            guard let category = categories.drinks.first else { return }
//            networking.dataFetcherDrinks(andpoint: "filter.php?c=\(category.strCategory)") { (currentModel) in
//                drinks = currentModel
//            }
//        }
//
//        delay(1) {
//            self.tableView.reloadData()
//        }

    }
    
}

extension ViewController {
    
    func getPartDrinks(category: String) {
        networking.dataFetcherDrinks(andpoint: "filter.php?c=\(category)") { (currentModel) in
            drinks = currentModel
        }
    }
    
    func delay(_ delay: Int, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            closure()
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let drinks = drinks else { return 0 }
        return drinks.drinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let drinks = drinks else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkTableViewCell", for: indexPath) as! DrinkTableViewCell
        cell.nameLabel.text = drinks.drinks[indexPath.row].strDrink
        return cell
    }
    
    
}
