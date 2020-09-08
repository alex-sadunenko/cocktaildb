//
//  ViewController.swift
//  CocktailDB
//
//  Created by Alex on 07.09.2020.
//  Copyright © 2020 Alex Sadunenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    
    var categories: CategoryModel!
    var drinks: DrinksModel!
    var drinkImages = [UIImage]()
    var chekEnable: [Bool]!
    var sectionData = [String: DrinksModel]()
    var networking = NetworkServiceManager()

    //MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - IBActions
    
    @IBAction func filterTapped(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let source = segue.source as? FiltersViewController else { return }
        chekEnable = source.chekEnable
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
                self.chekEnable = Array(repeating: true, count: self.categories.drinks.count)
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
            if self.drinks == nil {
                self.drinks = currentModel
            } else {
                self.drinks.drinks += currentModel.drinks
            }
            self.sectionData[category] = currentModel
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}

//MARK: - Table View Data Source

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let categories = self.categories else { return 0 }
        return categories.drinks.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let categories = self.categories else { return "" }
        return categories.drinks[section].strCategory
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //guard let drinks = self.drinks else { return 0 }
        //return drinks.drinks.count
        
        let key = categories.drinks[section].strCategory
        if let value = sectionData[key] {
            return value.drinks.count
        }
        
        return 0
        
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
        
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        print(section)
        let key = categories.drinks[section].strCategory
        if let value = sectionData[key] {
            //print(value)
        } else {
            //getPartDrinks(category: key)
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let key = categories.drinks[indexPath.section].strCategory
        if let value = sectionData[key] {
            if indexPath.row == value.drinks.count - 1 {
                print(indexPath.row)
                print(indexPath.section)
                if categories.drinks.count > indexPath.section + 1 {
                    let key = categories.drinks[indexPath.section + 1].strCategory
                    if let value = sectionData[key] {
                        //print(value)
                    } else {
                        getPartDrinks(category: key)
                    }
                }
            }
        }
    }
    
}

//MARK: - Table View Delegate

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

//MARK: - Segue

extension ViewController {
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToFilters" {
            guard let destination = segue.destination as? FiltersViewController else { return }
            destination.categories = self.categories
            destination.chekEnable = chekEnable
        }
    }
}

