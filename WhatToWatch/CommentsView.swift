//
//  CommentsView.swift
//  WhatToWatch
//
//  Created by Jay Noonan on 12/5/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct CommentsView: View {
    @FirestoreQuery(collectionPath: "comments") var comments: [Comment]
    @Environment(\.dismiss) private var dismiss
    @State var show: SavedShow
    var body: some View {
        NavigationStack {
            List(showComments) { comment in
                LazyVStack {
                    NavigationLink {
                        CommentView(comment: comment, show: show)
                    } label: {
                        VStack(alignment: .leading) {
                            Text("\(String(format: "%.1f", comment.rating))")
                                .font(.title2)
                            Text(comment.data)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }
                    }
                    
                }
            }
            .listStyle(.plain)
            .navigationTitle("Reviews for '\(show.name.capitalized)'")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .foregroundColor(Color("MyColor"))
                }
            }
        }
    }
    
    var showComments: [Comment] {
        var showComms = comments.filter {$0.showID == show.onlineID}
        showComms = showComms.sorted {$0.date > $1.date}
        return showComms
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsView(show: SavedShow(name: "", url: "", summary: "", onlineRating: 0.0, userRating: 0.0, userTotalRating: 0.0, premiered: "", ended: "", imageURL: "", onlineID: 0, totalReviews: 0))
    }
}
