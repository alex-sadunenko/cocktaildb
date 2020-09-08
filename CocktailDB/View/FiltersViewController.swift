//
//  FiltersViewController.swift
//  CocktailDB
//
//  Created by Alex on 07.09.2020.
//  Copyright © 2020 Alex Sadunenko. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {

    var categories: CategoryModel!
    var checkEnable = [Bool]()
    var checkCategories = [Int: String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "BackIcon"), landscapeImagePhone: nil, style: .done, target: self, action: #selector(revealBackClicked))
        barButton.tintColor = .black
        navigationItem.leftBarButtonItem = barButton
    }

    @objc func revealBackClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func applyTapped(_ sender: UIButton) {
        var currentlyCheck = 0
        for item in 0..<checkEnable.count {
            if checkEnable[item] {
                checkCategories[currentlyCheck] = categories.drinks[item].strCategory
                currentlyCheck += 1
            }
        }
        performSegue(withIdentifier: "unwindSegueToDrinks", sender: sender)
    }
}

//MARK: - Table View Delegate

extension FiltersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
 
}

//MARK: - Table View Data Source

extension FiltersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.drinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = categories.drinks[indexPath.row].strCategory
        cell.accessoryType = checkEnable[indexPath.row] ? .checkmark : .none
//        if let resultCheck = chekEnable[indexPath.row] {
//            cell.accessoryType = checkEnable ? .checkmark : .none
//        } else {
//            cell.accessoryType = .none
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = !checkEnable[indexPath.row] ? .checkmark : .none
            checkEnable[indexPath.row] = !checkEnable[indexPath.row]
//            if let resultCheck = chekEnable[indexPath.row] {
//                cell.accessoryType = !resultCheck ? .checkmark : .none
//                chekEnable[indexPath.row] = !resultCheck
//            } else {
//                cell.accessoryType = .none
//                chekEnable[indexPath.row] = false
//            }
        }
    }
    
}
