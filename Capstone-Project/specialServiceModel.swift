

import Foundation

class specialServiceModel {
    
    var status: String?
    var price: Float
    var title: String
    var description: String
    var id: Int?
    var dueDate: String?
    var created: String?
    var providerBid: Int?
    var seeker: String?
    var provider: String?
    init(price: Float, title: String, description: String, id: Int, due: String?) {
        self.price = price
        self.title = title
        self.description = description
        self.id = id
        self.dueDate = due
    }
}
