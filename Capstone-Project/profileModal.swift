//
//  profileModal.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 11/18/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import Foundation

class Profile {
    var username: String
    var about: String?
    var rating: Float?
    var country: String?
    var street: String?
    var area: String?
    var category: String?
    var phoneNumber: String?
    var email: String?
    var id: Int
    init(username:String,about:String?,rating:Float?,country:String?,street:String?,area:String?,category:String?,phoneNumber:String?,email:String?,id:Int) {
        self.username = username
        self.about = about
        self.rating = rating
        self.country = country
        self.street = street
        self.area = area
        self.category = category
        self.phoneNumber = phoneNumber
        self.email = email
        self.id = id
    }
    
}
