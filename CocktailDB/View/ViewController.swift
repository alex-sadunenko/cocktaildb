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
    var checkEnable = [Bool]()
    var checkCategories = [Int: String]()
    var sectionData = [String: DrinksModel]()
    var networking = NetworkServiceManager()

    //MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    //MARK: - IBActions
    
    @IBAction func filterTapped(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let source = segue.source as? FiltersViewController else { return }
        checkEnable = source.checkEnable
        checkCategories = source.checkCategories
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator.isHidden = false
        indicator.startAnimating()
        dataFetch()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
            
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
                for item in 0..<self.categories.drinks.count {
                    self.checkCategories[item] = self.categories.drinks[item].strCategory
                }
                self.checkEnable = Array(repeating: true, count: self.categories.drinks.count)
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

    }
    
    func getPartDrinks(category: String) {
        DispatchQueue.main.async {
            self.indicator.isHidden = false
            self.indicator.startAnimating()
        }
        networking.dataFetcherDrinks(andpoint: "filter.php?c=\(category)") { (currentModel) in
            if self.drinks == nil {
                self.drinks = currentModel
            } else {
                self.drinks.drinks += currentModel.drinks
            }
            self.sectionData[category] = currentModel
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.indicator.isHidden = true
                self.indicator.stopAnimating()
            }
        }
    }
    
}

//MARK: - Table View Data Source

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var countSections = 0
        for item in 0..<checkEnable.count {
            countSections += checkEnable[item] ? 1 : 0
        }
        return countSections
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return checkCategories[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                
        let key = checkCategories[section]!
        if let value = sectionData[key] {
            return value.drinks.count
        } else if section == 0 {
            getPartDrinks(category: key)
        }
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let _ = self.drinks else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DrinkTableViewCell
        
        let key = checkCategories[indexPath.section]!
        if let value = self.sectionData[key] {
            
            cell.nameLabel.text = value.drinks[indexPath.row].strDrink
            DispatchQueue.main.async {
                self.indicator.isHidden = false
                self.indicator.startAnimating()
            }
            networking.dataFetcherImage(urlString: value.drinks[indexPath.row].strDrinkThumb, complition: { (image) in
                DispatchQueue.main.async {
                    cell.drinkImage.image = image
                    
                    self.indicator.isHidden = true
                    self.indicator.stopAnimating()
                }
            })
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let key = checkCategories[indexPath.section]!
        if let value = sectionData[key] {
            if indexPath.row == value.drinks.count - 1 {
                if checkCategories.count > indexPath.section + 1 {
                    
                    let key = checkCategories[indexPath.section + 1]!
                    if let _ = sectionData[key] {
                    } else {
                        getPartDrinks(category: key)
                    }
                    
                } else {
                    
                    let alertController = UIAlertController(title: "Вы достигли конца списка", message: nil, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    
                    present(alertController, animated: true)
                    
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

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
            destination.checkEnable = checkEnable
            destination.checkCategories = checkCategories
        }
    }
}

