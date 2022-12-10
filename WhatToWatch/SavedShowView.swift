//
//  SavedShowView.swift
//  WhatToWatch
//
//  Created by Jay Noonan on 12/5/22.
//

import SwiftUI

struct SavedShowView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var showVM = ShowViewModel()
    @State var show: SavedShow
    @State private var newReview = false
    @State private var seeComments = false
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    
                    HStack(spacing: 0) {
                        showImage
                        
                        VStack {
                            VStack(alignment: .center) {
                                Text(show.name.capitalized)
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 10)
                            }
                            
                            Spacer()
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Online Rating: ")
                                    Text("User Rating: ")
                                    Text("Total Reviews: ")
                                        .padding(.top, 5)
                                }
                                .foregroundColor(.gray)
                                VStack {
                                    Text("\(String(format: "%.1f", show.onlineRating))")
                                    Text("\(String(format: "%.1f", show.userRating))")
                                    Text("\(show.totalReviews)")
                                        .padding(.top, 5)
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Premiered: \(show.premiered)")
                                Text("Ended: \(show.ended)")
                            }
                            .foregroundColor(.gray)
                            .font(.caption)
                            .padding(.top, 5)
                            .padding(.bottom, 20)
                            .padding(.trailing, 10)
                        }
                    }
                    .padding(.trailing)
                    .padding(.bottom)
                    .padding(.top)
                    
                    VStack(alignment: .leading) {
                        
                        Text("Summary:")
                            .bold()
                            .padding(.bottom, 8)
                        ScrollView {
                            Text(showVM.formatSummary(summary: show.summary))
                        }
                    }
                    .padding(.top, 5)
                    .frame(width: 335, height: 370)
                    .padding(.leading, 5)
                }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        newReview.toggle()
                    } label: {
                        Text("Add Review")
                    }
                    .foregroundColor(Color("MyColor"))
                }
                ToolbarItem(placement: .bottomBar) {
                    NavigationLink {
                        EpisodesListView(show: show)
                    } label: {
                        Text("Episodes")
                    }
                    .foregroundColor(Color("MyColor"))
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        seeComments.toggle()
                    } label: {
                        Text("See Reviews")
                    }
                    .foregroundColor(Color("MyColor"))
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .foregroundColor(Color("MyColor"))
                }
//                ToolbarItem(placement: .status) {
//                    VStack(alignment: .leading) {
//                        Text("Premiered: \(show.premiered)")
//                        Text("Ended: \(show.ended)")
//                    }
//                    .foregroundColor(.gray)
//                    .font(.caption)
//                }
            }
            .sheet(isPresented: $newReview) {
                AddShowReviewView(show: show)
            }
            .sheet(isPresented: $seeComments) {
                CommentsView(show: show)
            }
            .navigationBarBackButtonHidden()
        }
    }
}

extension SavedShowView {
    var showImage: some View {
        AsyncImage(url: URL(string: show.imageURL)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .shadow(radius: 8, x: 5, y: 5)
            } else{
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 200, height: 200)
                    .shadow(radius: 8, x: 5, y: 5)
            }
        }
    }
}

struct SavedShowView_Previews: PreviewProvider {
    static var previews: some View {
        SavedShowView(show: SavedShow(name: "", url: "", summary: "", onlineRating: 0.0, userRating: 0.0, userTotalRating: 0.0, premiered: "", ended: "", imageURL: "", onlineID: 0, totalReviews: 0))
    }
}
