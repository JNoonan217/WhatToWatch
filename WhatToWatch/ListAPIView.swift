//
//  ListAPIView.swift
//  WhatToWatch
//
//  Created by Jay Noonan on 12/4/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct ListAPIView: View {
    @FirestoreQuery(collectionPath: "shows") var savedShows: [SavedShow]
    @EnvironmentObject var showsVM: ShowsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var searchName = ""
    @FocusState private var isFocused: Bool
    @State private var searchResults: [Show] = []
    @State private var isSheetPresented = false
    @State private var getNewData = false
    
    var body: some View {
        NavigationStack {
            VStack {
                    TextField("Show", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray.opacity(0.5), lineWidth: 2)
                        }
                        .focused($isFocused)
                        .padding(.horizontal)
                        .onAppear {
                            isFocused = true
                        }
                        .onSubmit {
                            searchName = searchText.lowercased()
                            if searchText.contains(" ") {
                                searchName = searchName.replacingOccurrences(of: " ", with: "%20")
                            }
                            Task {
                                await showsVM.getData(showName: searchName)
                            }
                            searchResults = showsVM.shows
                        }
                
                ZStack {
                    List(filteredResults) { show in
                        LazyVStack {
                            NavigationLink {
                                AddNewShowView(show: show)
                            } label: {
                                VStack(alignment: .leading){
                                    Text((show.name ?? "N/A").capitalized)
                                        .font(.title2)
                                    Text("ID: \(show.id ?? -1)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                dismiss()
                            }
                            .foregroundColor(Color("MyColor"))
                        }
                        ToolbarItem(placement: .status) {
                            Text("\(filteredResults.count)")
                        }
                    }
                    
                    if showsVM.isLoading {
                        ProgressView()
                            .tint(.gray)
                            .scaleEffect(4)
                    }
                }
            }
        }
    }
    
    var filteredResults: [Show] {
        return showsVM.shows.filter {!savedIDs.contains($0.id!)}
    }
    
    var savedIDs: [Int] {
        var tempList: [Int] = []
        savedShows.forEach{tempList.append($0.onlineID)}
        return tempList
    }
}

struct ListAPIView_Previews: PreviewProvider {
    static var previews: some View {
        ListAPIView()
    }
}
