//
//  Show.swift
//  WhatToWatch
//
//  Created by Jay Noonan on 12/4/22.
//

import Foundation
import FirebaseFirestoreSwift

struct Show: Codable, Identifiable {
    var id: Int?
    var url: String?
    var name: String?
//    var summary = ""
//    var image = Picture(medium: "")
//    var rating = Rating(average: 0.0)
}
