//
//  Comment.swift
//  WhatToWatch
//
//  Created by Jay Noonan on 12/5/22.
//

import Foundation
import FirebaseFirestoreSwift

struct Comment: Codable, Identifiable {
    
    @DocumentID var id: String?
    var data: String
    var showID: Int
    var rating: Double
    var date: Date
    
    var dictionary: [String: Any] {
        return ["data": data, "showID": showID, "rating": rating, "date": date]
    }
}
