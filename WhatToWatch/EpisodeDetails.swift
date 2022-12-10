//
//  EpisodeDetails.swift
//  WhatToWatch
//
//  Created by Jay Noonan on 12/5/22.
//

import Foundation

struct EpisodeDetails: Codable, Identifiable {
    var id: Int?
    var name: String?
    var season: Int?
    var summary: String?
    var airdate: String?
    var runtime: Int?
    var rating: Rating?
    var image: Picture?
}

struct Picture: Codable {
    var medium: String?
}

struct Rating: Codable {
    var average: Double?
}
