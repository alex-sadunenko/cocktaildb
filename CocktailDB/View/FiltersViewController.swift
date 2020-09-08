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
    var chekEnable: [Bool]!

    override func viewDidLoad() {
        super.viewDidLoad()

        let barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "BackIcon"), landscapeImagePhone: nil, style: .done, target: self, action: #selector(revealBackClicked))
        navigationItem.leftBarButtonItem = barButton
    }

    @objc func revealBackClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func applyTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindSegueToDrinks", sender: sender)
    }
}

extension FiltersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
 
}

extension FiltersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.drinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = categories.drinks[indexPath.row].strCategory
        //cell.accessoryType = .checkmark
        cell.accessoryType = chekEnable[indexPath.row] ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = !chekEnable[indexPath.row] ? .checkmark : .none
            chekEnable[indexPath.row] = !chekEnable[indexPath.row]
        }
    }
    
}
