//
//  ListView.swift
//  WhatToWatch
//
//  Created by Jay Noonan on 12/4/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct ListView: View {
    @FirestoreQuery(collectionPath: "shows") var shows: [SavedShow]
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            List(searchResults) { show in
                LazyVStack {
                    NavigationLink {
                        SavedShowView(show: show)
                    } label: {
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
                                .font(.title2)
                            HStack {
                                Text("Rating: \(String(format: "%.1f", show.userRating))")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                
                                Text("Rated by \( show.totalReviews) users")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Reviewed Shows")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color("MyColor"))
                }
            }
            .searchable(text: $searchText)
        }
    }
    
    var searchResults: [SavedShow] {
        if searchText.isEmpty {
            return shows
        } else {
            return shows.filter {$0.name.capitalized.contains(searchText)}
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}

