//
//  ShowViewModel.swift
//  WhatToWatch
//
//  Created by Jay Noonan on 12/4/22.
//

import Foundation
import FirebaseFirestore
import SwiftUI

@MainActor
class ShowViewModel: ObservableObject {
    private struct Returned: Codable {
        var name: String?
        var rating: Rating?
        var image: Picture?
        var summary: String?
        var premiered: String?
        var ended: String?
        var genres: [String]
        var id: Int
    }
    
    struct Picture: Codable {
        var medium: String?
    }
    
    struct Rating: Codable {
        var average: Double?
    }
    
    @Published var isLoading = false
    @Published var imageURL = ""
    @Published var name = ""
    @Published var onlineRating = 0.0
    @Published var summary = ""
    @Published var premiered = ""
    @Published var ended = ""
    @Published var genres = []
    @Published var url = ""
    @Published var onlineID = -1
    
    func getData(id: Int) async {
        let urlString = "https://api.tvmaze.com/shows/\(id)"
        print("We are accessing the URL \(urlString)")
        isLoading = true
        
        guard let url = URL(string: urlString) else {
            print("ERROR: could not create URL from \(urlString)")
            isLoading = false
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("JSON ERROR: could not decode returned JSON data")
                isLoading = false
                return
            }
            self.imageURL = (returned.image ?? Picture(medium: nil)).medium ?? "N/A"
            self.name = returned.name ?? ""
            self.onlineRating = (returned.rating ?? Rating(average: nil)).average ?? 0.0
            self.summary = returned.summary ?? ""
            self.premiered = returned.premiered ?? ""
            self.ended = returned.ended ?? "More to come!"
            self.genres = returned.genres
            self.url = urlString
            self.onlineID = returned.id
            isLoading = false
        } catch {
            isLoading = false
            print("ERROR: could not load user URL at \(urlString) to get data and response")
        }
    }
    
    func saveShow(show: SavedShow) async -> Bool {
        let db = Firestore.firestore()
        
        if let id = show.id {
            do {
                try await db.collection("shows").document(id).setData(show.dictionary)
                print("😎 Data Updated successfully")
                return true
            } catch {
                print("😡 ERROR: Could not update data in 'spots' \(error.localizedDescription)")
                return false
            }
        } else {
            do {
                _ = try await db.collection("shows").addDocument(data: show.dictionary)
                print("😎 Data Added successfully")
                return true
            } catch {
                print("😡 ERROR: Could not create a new spot in 'spots' \(error.localizedDescription)")
                return false
            }

        }
    }
    
    func saveComment(comment: Comment) async -> Bool {
        let db = Firestore.firestore()
        
        if let id = comment.id {
            do {
                try await db.collection("comments").document(id).setData(comment.dictionary)
                print("😎 Data Updated successfully")
                return true
            } catch {
                print("😡 ERROR: Could not update data in 'spots' \(error.localizedDescription)")
                return false
            }
        } else {
            do {
                _ = try await db.collection("comments").addDocument(data: comment.dictionary)
                print("😎 Data Added successfully")
                return true
            } catch {
                print("😡 ERROR: Could not create a new spot in 'spots' \(error.localizedDescription)")
                return false
            }

        }
    }
    
    func formatSummary(summary: String) -> String {
        var final = summary
        var repWith = ""
        enum ParaInserts: String, CaseIterable {
            case p = "<p>"
            case b = "<b>"
            case bs = "</b>"
            case ps = "</p>"
            case i = "<i>"
            case isl = "</i>"
        }
        ParaInserts.allCases.forEach { insert in
            repWith = ""
            if insert.rawValue == "</p>" {
                repWith = " "
            }
            final = final.replacingOccurrences(of: insert.rawValue, with: repWith)
        }
        return final
    }
    
    func formatDate(date: String) -> String {
        var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        var temp = date
        var split = temp.components(separatedBy: "-")
        var final = "\(months[Int(split[1])!])\(split[2]), \(split[0])"
        return final
    }
}

