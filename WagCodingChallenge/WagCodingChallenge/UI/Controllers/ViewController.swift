//
//  ViewController.swift
//  WagCodingChallenge
//
//  Created by James Ajhar on 10/4/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    lazy var userPager: UserPager = {
        return UserPager()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup TableView
        let nib = UINib(nibName: UserCell.NibName(), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: UserCell.CellIdentifier())
        
        userPager.reloadWithCompletion { [weak self] (users, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                print("\(#function) - ERROR: \(error)")
                return
            }
            
            strongSelf.tableView.reloadData()
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPager.elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.CellIdentifier(), for: indexPath) as! UserCell
        let user = userPager.elements[indexPath.row] as? User
        cell.user = user
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
        
    
}

