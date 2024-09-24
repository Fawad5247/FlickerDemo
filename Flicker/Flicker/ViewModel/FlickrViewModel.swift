//
//  FlickrViewModel.swift
//  Flicker
//
//  Created by Fawad Akhtar on 09/24/2024.
//

import Foundation
import Combine

class FlickrViewModel: ObservableObject {
    @Published var images: [FlickrImage] = []
    @Published var isLoading = false
    private var cancellable: AnyCancellable?
    
    func searchImages(for searchTerm: String) {
        guard !searchTerm.isEmpty else {
            self.images = []
            return
        }
        
        let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(searchTerm)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        isLoading = true
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .tryMap { data -> Data in
                // Flickr API response may have non-standard JSON so you need to clean up
                guard var jsonString = String(data: data, encoding: .utf8) else {
                    throw URLError(.badServerResponse)
                }
                
                // Clean up the extra Flickr prefix
                jsonString = jsonString.replacingOccurrences(of: "jsonFlickrFeed(", with: "")
                jsonString = jsonString.replacingOccurrences(of: ")", with: "")
                
                guard let cleanedData = jsonString.data(using: .utf8) else {
                    throw URLError(.badServerResponse)
                }
                
                return cleanedData
            }
            .decode(type: FlickrResponse.self, decoder: JSONDecoder())
            .replaceError(with: FlickrResponse(items: []))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                self?.images = response.items
                self?.isLoading = false
            }
    }
}
