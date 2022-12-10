//
//  CommentView.swift
//  WhatToWatch
//
//  Created by Jay Noonan on 12/5/22.
//

import SwiftUI

struct CommentView: View {
    @State var comment: Comment
    @State var show: SavedShow
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    VStack {
                        Text("Rating: ")
                            .bold()
                            .font(.title)
                        Text("Average Rating: ")
                            .bold()
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    VStack {
                        Text("\(String(format: "%.1f", comment.rating))")
                            .font(.title)
                        Text("\(String(format: "%.1f", show.userRating))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.bottom)
                .padding(.top)
                
                VStack(alignment: .leading) {
                    Text("Comment: ")
                        .bold()
                    ScrollView {
                        Text(comment.data)
                    }
                }
                Spacer()
            }
            .frame(width: 380, height: 600)
            .navigationBarBackButtonHidden()
            .navigationTitle("\(show.name.capitalized) Review")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .status) {
                    VStack {
                        HStack {
                            Text("Date Created: ")
                                .font(.caption)
                                .bold()
                            Text(comment.date, format: .dateTime.hour().minute().day().month().year())
                                .font(.caption)
                        }
                        HStack {
                            Text("Current Date: ")
                                .font(.caption)
                                .bold()
                            Text(Date(), format: .dateTime.hour().minute().day().month().year())
                                .font(.caption)
                        }
                    }
                }
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
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(comment: Comment(data: "", showID: 0, rating: 0.0, date: Date()), show: SavedShow(name: "", url: "", summary: "", onlineRating: 0.0, userRating: 0.0, userTotalRating: 0.0, premiered: "", ended: "", imageURL: "", onlineID: 0, totalReviews: 0))
    }
}
