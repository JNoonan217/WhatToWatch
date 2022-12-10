//
//  HomepageView.swift
//  WhatToWatch
//
//  Created by Jay Noonan on 12/4/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct HomepageView: View {
    @FirestoreQuery(collectionPath: "shows") var shows: [SavedShow]
    @State private var searchDataBase = false
    @State private var addNewShow = false
    @State private var top10Show: SavedShow?
    @State private var top10touched = false
    @State private var selectedFilter = Filter.User
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            VStack {
                Text("What to Watch?")
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .fontWeight(.bold)
                
                Text("Top 10 \(selectedFilter.rawValue) Reviewed")
                    .font(.title2)
                    .foregroundColor(.gray)
                    .padding(.bottom, 5)
                    .padding(.top, 10)
                
                List(filteredResults) { show in
                    LazyVStack(alignment: .leading) {
                        HStack {
                            AsyncImage(url: URL(string: show.imageURL)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 35, height: 35)
                                        .shadow(radius: 3, x: 2, y: 2)
                                } else{
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 35, height: 35)
                                        .shadow(radius: 3, x: 2, y: 2)
                                }
                            }
                            
                            VStack(alignment: .leading){
                                Text(show.name.capitalized)
                                    .font(.system(size: 18))
                                    .lineLimit(1)
                                HStack {
                                    Text("Rating: \(String(format: "%.1f", selectRating(show: show)))")
                                    Text(getReviewsDescription(show: show))
                                }
                                .foregroundColor(.gray)
                                .font(.caption)
                            }
                        }
                        .onTapGesture {
                            top10Show = show
                        }
                    }
                }
                .frame(width: 350, height: 450)
                .listStyle(.plain)
                .padding(.trailing)
                
                Picker("", selection: $selectedFilter) {
                    ForEach(Filter.allCases, id: \.self) { filter in
                        Text("\(filter.rawValue)")
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.bottom, 5)
                
                Spacer()
                
                HStack {
                    Button {
                        searchDataBase = true
                    } label: {
                        Text("Search for Show")
                    }
                    .padding(.trailing, 20)
                    
                    Button {
                        addNewShow = true
                    } label: {
                        Text("Add New Show")
                    }
                    .padding(.leading, 20)
                }
                .padding(.bottom, 20)
                .bold()
                .foregroundColor(Color("MyColor"))
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        do {
                            try Auth.auth().signOut()
                            print("🪵➡️ Log out succussful")
                            dismiss()
                        } catch {
                            print("😡ERROR: Could not sign out")
                        }
                    } label: {
                        Text("Sign Out")
                    }
                    .foregroundColor(Color("MyColor"))
                }
            }
            .sheet(isPresented: $addNewShow) {
                NavigationStack {
                    ListAPIView()
                }
            }
            .sheet(isPresented: $searchDataBase) {
                NavigationStack {
                    ListView()
                }
            }
            .sheet(item: $top10Show) { show in
                NavigationStack {
                    SavedShowView(show: show)
                }
            }
        }
    }
    
    func filteredBy(filterName: String) -> [SavedShow] {
        var sorted: [SavedShow] = []
        if filterName == "Online" {
            sorted = shows.sorted {$0.onlineRating > $1.onlineRating}
        } else if filterName == "User" {
            sorted = shows.sorted {$0.userRating > $1.userRating}
        }
        if sorted.count > 10 {
            sorted = Array(sorted[0...9])
        }
        return sorted
    }
    
    enum Filter: String, CaseIterable {
        case User = "User"
        case Online = "Online"
    }
    
    var filteredResults: [SavedShow] {
        var results: [SavedShow] = []
        if selectedFilter.rawValue == "Online" {
            results = shows.sorted {$0.onlineRating > $1.onlineRating}
        } else {
            results = shows.sorted {$0.userRating > $1.userRating}
        }
        if shows.count > 10 {
            results = Array(results[0...9])
        }
        return results
    }
    
    func selectRating(show: SavedShow) -> Double {
        var rating = 0.0
        if selectedFilter.rawValue == "Online" {
            rating = show.onlineRating
        } else {
            rating = show.userRating
        }
        return rating
    }
    
    func getReviewsDescription(show: SavedShow) -> String {
        var desc = "Reviewed from online"
        var user = "user"
        if selectedFilter.rawValue == "User" {
            if show.totalReviews > 1 {
                user = "users"
            }
            desc = "Reviewed by \(show.totalReviews) \(user)"
        }
        return desc
    }
    
}

struct HomepageView_Previews: PreviewProvider {
    static var previews: some View {
        HomepageView()
    }
}
