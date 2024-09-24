//
//  FlickrSearchView.swift
//  Flicker
//
//  Created by Fawad Akhtar on 09/24/2024.
//
import SwiftUI

struct FlickrSearchView: View {
    @ObservedObject var viewModel = FlickrViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search images...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: searchText) { oldvalue, newValue in
                        // Call the search function after each keystroke
                        self.viewModel.searchImages(for: newValue)
                    }

                if viewModel.isLoading {
                    ProgressView()
                }

                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                        ForEach(viewModel.images) { image in
                            NavigationLink(destination: FlickrDetailView(image: image)) {
                                AsyncImage(url: image.imageUrl) { phase in
                                    if let image = phase.image {
                                        image.resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                    } else {
                                        ProgressView()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Flickr Search")
        }
    }
}
