//
//  UserCell.swift
//  WagCodingChallenge
//
//  Created by James Ajhar on 10/5/16.
//  Copyright © 2016 James Ajhar. All rights reserved.
//

import UIKit

class UserCell: TableViewCell {

    // MARK: Outlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Properties
    var user: User? {
        didSet {
            updateUI()
        }
    }
    
    override class func CellIdentifier() -> String {
        return "UserTableViewCell"
    }
    
    override class func NibName() -> String {
        return "UserCell"
    }
    
    override func commonInit() {
        super.commonInit()
        
    }
    
    func fetchAvatar() {
        guard let url = user?.getUserAvatarURL() else {
            activityIndicator.isHidden = true
            return
        }
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        url.fetchImage { [weak self] (success, image) in
            guard let strongSelf = self else { return }
            if !success { return }
            guard let image = image else { return }
            
            strongSelf.avatarImageView.image = image
            strongSelf.activityIndicator.stopAnimating()
            strongSelf.activityIndicator.isHidden = true
        }
    }

    func updateUI() {
        guard let user = user else { return }
        fetchAvatar()
        let username = user.username != nil ? user.username! : ""
        infoLabel.text = "\(username)\nBronze: \(user.bronzeBadgeCount)\nSilver: \(user.silverBadgeCount)\nGold: \(user.goldBadgeCount)"
    }
}
