//
//  AddShowReviewView.swift
//  WhatToWatch
//
//  Created by Jay Noonan on 12/5/22.
//

import SwiftUI

struct AddShowReviewView: View {
    @Environment(\.dismiss) private var dismiss
    @State var show: SavedShow
    @StateObject var showVM = ShowViewModel()
    @State private var rating = ""
    @State private var comment = ""
    @State private var newShow = SavedShow(name: "", url: "", summary: "", onlineRating: 0.0, userRating: 0.0, userTotalRating: 0.0, premiered: "", ended: "", imageURL: "", onlineID: 0, totalReviews: 0)
    @FocusState private var focusField: Field?
    enum Field {
        case rating, comment
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Group {
                    Text("Rating")
                    TextField("Rating", text: $rating)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray.opacity(0.5), lineWidth: 2)
                        }
                        .keyboardType(.decimalPad)
                        .onAppear {
                            focusField = .rating
                        }
                        .focused($focusField, equals: .rating)
                        .onSubmit {
                            focusField = .comment
                        }
                    
                    
                    Text("Comment")
                    TextField("Comment", text: $comment, axis: .vertical)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray.opacity(0.5), lineWidth: 2)
                        }
                        .focused($focusField, equals: .comment)
                        .onSubmit {
                            focusField = nil
                        }
                }
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationBarTitle(Text(show.name))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color("MyColor"))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        guard let rate = Double(rating) else {
                            print("Rating could not be converted to double: Data not saved")
                            return
                        }
                        if rate > 10 {
                            rating = "10"
                        } else if rate < 0 {
                            rating = "0"
                        }
                        newShow = show
                        newShow.totalReviews += 1
                        newShow.userTotalRating += Double(rating)!
                        newShow.userRating = newShow.userTotalRating / Double(newShow.totalReviews)
                        Task {
                            await showVM.saveShow(show: newShow)
                            
                            await showVM.saveComment(comment: Comment(data: comment, showID: show.onlineID, rating: Double(rating)!, date: Date()))
                        }
                        dismiss()
                    }
                    .bold()
                    .foregroundColor(Color("MyColor"))
                }
            }
        }
    }
}

struct AddShowReviewView_Previews: PreviewProvider {
    static var previews: some View {
        AddShowReviewView(show: SavedShow(name: "", url: "", summary: "", onlineRating: 0.0, userRating: 0.0, userTotalRating: 0.0, premiered: "", ended: "", imageURL: "", onlineID: 0, totalReviews: 0))
    }
}
