//
//  EpisodesListView.swift
//  WhatToWatch
//
//  Created by Jay Noonan on 12/5/22.
//

import SwiftUI

struct EpisodesListView: View {
    @Environment(\.dismiss) private var dismiss
    @State var show: SavedShow
    @StateObject var episodesVM = EpisodesViewModel()
    @State private var count = 0
    var body: some View {
        NavigationStack {
            ZStack {
                List(episodesVM.episodes) { episode in
                    LazyVStack {
                        NavigationLink {
                            EpisodeView(show: show, episodeID: episode.id!)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(episode.name!)
                                    .font(.title3)
                                Text("Season \(episode.season!)")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            }
                        }
                    }
                }
                .navigationTitle("\(show.name.capitalized) Episodes")
                .navigationBarTitleDisplayMode(.inline)
                .listStyle(.plain)
                .toolbar {
                    ToolbarItem(placement: .status) {
                        Text("\(episodesVM.episodes.count) Episodes")
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
                .navigationBarBackButtonHidden()
                
                if episodesVM.isLoading {
                    ProgressView()
                        .tint(.gray)
                        .scaleEffect(4)
                }
            }
            .task {
                await episodesVM.getData(showID: show.onlineID)
            }
        }
    }
}


struct EpisodesListView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodesListView(show: SavedShow(name: "", url: "", summary: "", onlineRating: 0.0, userRating: 0.0, userTotalRating: 0.0, premiered: "", ended: "", imageURL: "", onlineID: 0, totalReviews: 0))
    }
}
