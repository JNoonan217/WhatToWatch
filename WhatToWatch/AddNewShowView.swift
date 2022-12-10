//
//  AddNewShowView.swift
//  WhatToWatch
//
//  Created by Jay Noonan on 12/4/22.
//

import SwiftUI

struct AddNewShowView: View {
    @EnvironmentObject var showsVM: ShowsViewModel
    @Environment(\.dismiss) private var dismiss
    @StateObject var showVM = ShowViewModel()
    @State var show: Show
    @State private var rating = ""
    @State private var comment = ""
    @State private var notDouble = false
    @FocusState private var focusField: Field?
    enum Field {
        case rating, comment
    }
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    HStack(spacing: 0) {
                        showImage
                        
                        VStack(alignment: .center) {
                            Text(showVM.name.capitalized)
                                .font(.title)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                            
                            
                            Spacer()
                            
                            HStack {
                                VStack {
                                    Text("Online Rating: ")
                                }
                                .foregroundColor(.gray)
                                VStack(alignment: .leading) {
                                    Text("\(String(format: "%.1f", showVM.onlineRating))")
                                }
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                Text("Premiered: \(showVM.premiered)")
                                Text("Ended: \(showVM.ended)")
                            }
                            .foregroundColor(.gray)
                            .font(.caption)
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
                            Text(showVM.formatSummary(summary: showVM.summary))
                        }
                    }
                    .padding(.top, 5)
                    .frame(width: 335, height: 390)
                    .padding(.leading, 5)
                }
                
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
                        .padding(.bottom, 20)
                        .focused($focusField, equals: .comment)
                        .onSubmit {
                            focusField = nil
                        }
                }
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            }
            
            if showVM.isLoading {
                ProgressView()
                    .tint(.gray)
                    .scaleEffect(4)
            }
        }
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
                        notDouble.toggle()
                        return
                    }
                    if rate > 10 {
                        rating = "10"
                    } else if rate < 0 {
                        rating = "0"
                    }
                    Task {
                        await showVM.saveShow(show: SavedShow(name: showVM.name, url: showVM.url, summary: showVM.summary, onlineRating: showVM.onlineRating, userRating: Double(rating)!, userTotalRating: Double(rating)!, premiered: showVM.premiered, ended: showVM.ended, imageURL: showVM.imageURL, onlineID: showVM.onlineID, totalReviews: 1))
                        
                        await showVM.saveComment(comment: Comment(data: comment, showID: showVM.onlineID, rating: Double(rating)!, date: Date()))
                    }
                    dismiss()
                }
                .bold()
                .foregroundColor(Color("MyColor"))
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .task{
            await showVM.getData(id: show.id!)
        }
    }
}

extension AddNewShowView {
    var showImage: some View {
        AsyncImage(url: URL(string: showVM.imageURL)) { phase in
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

struct AddNewShowView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewShowView(show: Show())
            .environmentObject(ShowsViewModel())
    }
}
