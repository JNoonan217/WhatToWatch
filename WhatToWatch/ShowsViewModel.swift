//
//  ShowsViewModel.swift
//  WhatToWatch
//
//  Created by Jay Noonan on 12/4/22.
//

import Foundation

@MainActor
class ShowsViewModel: ObservableObject {
    private struct Returned: Codable {
        var show: Show
    }
    
    @Published var isLoading = false
    @Published var shows: [Show] = []
    
    func getData(showName: String) async {
        let urlString = "https://api.tvmaze.com/search/shows?q=\(showName)"
        self.shows = []
        print("We are accessing the URL \(urlString)")
        isLoading = true
        
        guard let url = URL(string: urlString) else {
            print("ERROR: could not create URL from \(urlString)")
            isLoading = false
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let returned = try? JSONDecoder().decode([Returned].self, from: data) else {
                print("JSON ERROR: could not decode returned JSON data")
                isLoading = false
                return
            }
            returned.forEach{self.shows.append($0.show)}
            isLoading = false
        } catch {
            isLoading = false
            print("ERROR: could not load user URL at \(urlString) to get data and response")
        }
    }
}
