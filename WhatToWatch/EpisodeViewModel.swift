//
//  EpisodeViewModel.swift
//  WhatToWatch
//
//  Created by Jay Noonan on 12/5/22.
//

import Foundation
import FirebaseFirestore

@MainActor
class EpisodeViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var episode: EpisodeDetails = EpisodeDetails(id: 0, name: "", season: 0, rating: Rating(average: 0.0), image: Picture(medium: ""))
    
    func getData(episodeID: Int) async {
        let urlString = "https://api.tvmaze.com/episodes/\(episodeID)"
        print("We are accessing the URL \(urlString)")
        isLoading = true
        
        guard let url = URL(string: urlString) else {
            print("ERROR: could not create URL from \(urlString)")
            isLoading = false
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let returned = try? JSONDecoder().decode(EpisodeDetails.self, from: data) else {
                print("JSON ERROR: could not decode returned JSON data")
                isLoading = false
                return
            }
            self.episode = returned
            isLoading = false
        } catch {
            isLoading = false
            print("ERROR: could not load user URL at \(urlString) to get data and response")
        }
    }
}
