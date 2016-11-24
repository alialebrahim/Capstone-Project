//
//  PublicServiceModel.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 11/11/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import Foundation
class PublicServiceModel {
    var category: String
    var status: String?
    var price: Float
    var title: String
    var description: String
    var id: Int?
    var dueDate: String
    var bids: [Bid]?
    var providerBid: Int?
    init(category:String, price: Float, title: String, description: String, id: Int, due: String, bidding: [Bid]) {
        self.category = category
        self.price = price
        self.title = title
        self.description = description
        self.id = id
        self.dueDate = due
        self.bids = bidding
    }
}