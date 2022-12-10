//
//  EpisodeView.swift
//  WhatToWatch
//
//  Created by Jay Noonan on 12/5/22.
//

import SwiftUI

struct EpisodeView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var episodeVM = EpisodeViewModel()
    @StateObject var showVM = ShowViewModel()
    @State var show: SavedShow
    @State var episodeID: Int
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(alignment: .center, spacing: 0) {
                        Text(episodeVM.episode.name!.capitalized)
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                        
                        showImage
                        
                    }
                    .padding(.bottom)
                    .padding(.trailing)
                    .padding(.top)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Rating: ")
                                Text("Season: ")
                                Text("Aired: ")
                                Text("Runtime: ")
                            }
                            .foregroundColor(.gray)
                            VStack(alignment: .leading) {
                                Text("\(String(format: "%.1f", (episodeVM.episode.rating ?? Rating(average: nil)).average ?? 0.0))")
                                Text("\(episodeVM.episode.season ?? 0)")
                                Text("\(episodeVM.episode.airdate ?? "N/A")")
                                Text("\(episodeVM.episode.runtime ?? 0) minutes")
                            }
                        }
                        .padding(.bottom, 20)
                        
                        Text("Summary:")
                            .bold()
                            .padding(.bottom, 8)
                        ScrollView {
                            Text(showVM.formatSummary(summary: episodeVM.episode.summary ?? ""))
                        }
                    }
                    .frame(width: 335, height: 390)
                    .padding(.leading, 5)
                }
                .navigationTitle("\(show.name.capitalized)")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
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
                
                if episodeVM.isLoading {
                    ProgressView()
                        .tint(.gray)
                        .scaleEffect(4)
                }
            }
            .task {
                await episodeVM.getData(episodeID: episodeID)
            }
        }
    }
}

extension EpisodeView {
    var showImage: some View {
        AsyncImage(url: URL(string: (episodeVM.episode.image ?? Picture(medium: nil)).medium ?? "N/A")) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 180)
                    .shadow(radius: 8, x: 5, y: 5)
            } else{
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 250, height: 180)
                    .shadow(radius: 8, x: 5, y: 5)
            }
        }
    }
}

struct EpisodeView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeView(show: SavedShow(name: "", url: "", summary: "", onlineRating: 0.0, userRating: 0.0, userTotalRating: 0.0, premiered: "", ended: "", imageURL: "", onlineID: 0, totalReviews: 0), episodeID: Int())
    }
}
