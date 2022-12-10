//
//  Episode.swift
//  WhatToWatch
//
//  Created by Jay Noonan on 12/5/22.
//

import Foundation
import FirebaseFirestoreSwift

struct Episode: Codable, Identifiable {
    var id: Int?
    var name: String?
    var season: Int?
    
    enum CodingKeys: CodingKey {
        case id, name, season
    }
}
