//
//  Bid.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 11/11/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import Foundation

class Bid {
    var bid: Int?
    var bidder: Int?
    var id: Int?
    var username: String
    var status: String?
    init(bid: Int, bidder: Int, id:Int, username: String) {
        self.bid = bid
        self.bidder = bidder
        self.id = id
        self.username = username
    }
}
