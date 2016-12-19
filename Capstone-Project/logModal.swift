//
//  logModal.swift
//  Capstone-Project
//
//  Created by Ali Alibrahim on 12/2/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import Foundation

class logModal {
    var title: String
    var status: String
    var created:String?
    var due: String?
    var provider: String
    var seeker: String
    var type: String //offered or public
    var id: Int
    init(title:String, status:String, provider:String, seeker:String, type:String, id:Int) {
        self.title = title
        self.status = status
        self.provider = provider
        self.seeker = seeker
        self.type = type
        self.id = id
    }
}
