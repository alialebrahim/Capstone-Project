//
//  offeredServiceModel.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 10/30/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import Foundation
/*
 {
 "category" : "test category",
 "id" : 35,
 "service" : {
 "status" : "pending",
 "providerpk" : null,
 "id" : 44,
 "price" : 500,
 "title" : "Title",
 "due_date" : null,
 "created" : "2016-09-23T08:40:27Z",
 "seekerpk" : null,
 "description" : "Shared self feel headless wehef",
 "is_special" : false
 },
 "serviceimage_set" : [
 
 ]
 }
 */
class OfferedServiceModel {
    //TODO: add id's
    var category: String
    var status: String?
    var price: Float
    var created: String?
    var title: String
    var description: String
    var images: [UIImage]?
    var id: Int?
    var idd: Int?
    var from: String?
    var to: String?
    var seeker: String?
    var provider: String?
    init(category:String, price: Float, title: String, description: String, id: Int) {
        self.category = category
        self.price = price
        self.title = title
        self.description = description
        self.id = id
    }
    
}
