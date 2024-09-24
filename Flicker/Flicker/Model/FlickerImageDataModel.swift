//
//  FlickerImageDataModel.swift
//  Flicker
//
//  Created by Fawad Akhtar on 09/24/2024.
//
import Foundation

struct FlickrImage: Codable, Identifiable {
    var id: String {
        return link
    }
    
    let title: String
    let link: String
    let media: Media
    let date_taken: String
    let description: String
    let published: String
    let author: String
    
    // Nested media struct to capture the image URL
    struct Media: Codable {
        let m: String
    }
    
    // Parse the image URL from the media field
    var imageUrl: URL? {
        return URL(string: media.m)
    }
    
    // Helper to format the author's name
    var formattedAuthor: String {
        let pattern = "\\(\"(.*?)\"\\)"
        if let range = author.range(of: pattern, options: .regularExpression) {
            return String(author[range]).trimmingCharacters(in: CharacterSet(charactersIn: "(\"\")"))
        }
        return author
    }
}

struct FlickrResponse: Codable {
    let items: [FlickrImage]
}
