//
//  SavedShow.swift
//  WhatToWatch
//
//  Created by Jay Noonan on 12/4/22.
//

import Foundation
import FirebaseFirestoreSwift

struct SavedShow: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var url: String
    var summary: String
    var onlineRating: Double
    var userRating: Double
    var userTotalRating: Double
    var premiered: String
    var ended: String
    var imageURL: String
    var onlineID: Int
    var totalReviews: Int
//    var genres: [String]
    
    var dictionary: [String: Any] {
        return ["name": name, "url": url, "summary": summary, "onlineRating": onlineRating, "userRating": userRating, "userTotalRating": userTotalRating, "premiered": premiered, "ended": ended, "imageURL": imageURL, "onlineID": onlineID, "totalReviews": totalReviews]
    }
}
