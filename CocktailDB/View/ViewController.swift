//
//  ViewController.swift
//  CocktailDB
//
//  Created by Alex on 07.09.2020.
//  Copyright © 2020 Alex Sadunenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var categories: CategoryModel!
    var drinks: DrinksModel!
    var drinkImages = [UIImage]()
    var networking = NetworkServiceManager()

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func filterTapped(_ sender: UIBarButtonItem) {
        tableView.reloadData()
        print(categories.drinks)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataFetch()
            
    }
}
// MARK: - Networking

extension ViewController {
    
    func dataFetch() {
        let queue = DispatchQueue(label: "drinks", attributes: .concurrent)
        let group = DispatchGroup()
        
        group.enter()
        queue.async(group: group) {
            self.networking.dataFetcherCategory(andpoint: "list.php?c=list") { (currentModel) in
                self.categories = currentModel
                group.leave()
            }
        }
        
        group.wait()
        
        group.enter()
        queue.async(group: group) {
            guard let _ = self.categories, let category = self.categories.drinks.first else { return }
            self.getPartDrinks(category: category.strCategory)
            group.leave()
        }

        //group.notify(queue: .main) {
        //    guard let _ = self.categories, let category = self.categories.drinks.first else { return }
        //    self.getPartDrinks(category: category.strCategory)
        //}

    }
    
    func getPartDrinks(category: String) {
        networking.dataFetcherDrinks(andpoint: "filter.php?c=\(category)") { (currentModel) in
            self.drinks = currentModel
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let drinks = self.drinks else { return 0 }
        return drinks.drinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let drinks = self.drinks else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DrinkTableViewCell
        cell.nameLabel.text = drinks.drinks[indexPath.row].strDrink
        networking.dataFetcherImage(urlString: drinks.drinks[indexPath.row].strDrinkThumb, complition: { (image) in
            DispatchQueue.main.async {
                cell.drinkImage.image = image
            }
        })
        //cell.drinkImage.image
            //drinkImages = networking.dataFetcherImage(andpoint: <#T##String#>, complition: <#T##(UIImage) -> Void#>)
        return cell
    }
    
}
