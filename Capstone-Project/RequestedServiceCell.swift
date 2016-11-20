//
//  RequestedServiceCell.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 8/13/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit

protocol RequestServiceCellDelegate: class {
    func acceptButtonTapped(_ cell: RequestedServiceCell)
    func declineButtonTapped(_ cell: RequestedServiceCell)
}

class RequestedServiceCell: UICollectionViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dueToLabel: UILabel!
    @IBOutlet weak var requestDateLabel: UILabel!
    @IBOutlet weak var serviceTitleLabel: UILabel!
    @IBOutlet weak var requestNumberLabel: UILabel!
    
    //MARK: Variables
    weak var delegate: RequestServiceCellDelegate?
    
    //MARK: IBActions
    @IBAction func acceptButtonPressed(_ sender: AnyObject) {
        self.delegate?.acceptButtonTapped(self)
    }
    @IBAction func declineButtonPressed(_ sender: AnyObject) {
        self.delegate?.declineButtonTapped(self)
    }
    
    //Functions
    override func awakeFromNib() {
        self.layer.borderColor = UIColor(hex: 0xa85783).cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }

    
}
