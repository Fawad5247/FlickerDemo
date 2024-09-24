//
//  FlickrDetailView.swift
//  Flicker
//
//  Created by Fawad Akhtar on 09/24/2024.
//

import SwiftUI
import UIKit

struct HTMLTextView: UIViewRepresentable {
    let htmlContent: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.backgroundColor = .clear
        return textView
    }
    
    func updateUIView(_ textView: UITextView, context: Context) {
        // Convert the HTML string into an attributed string
        if let data = htmlContent.data(using: .utf8) {
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ]
            if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
                textView.attributedText = attributedString
            } else {
                textView.text = htmlContent // Fallback to plain text if parsing fails
            }
        }
    }
}

struct FlickrDetailView: View {
    let image: FlickrImage
    
    var body: some View {
        VStack {
            if let url = image.imageUrl {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 300)
                    }
                }
            }
            Text(image.title)
                .font(.headline)
                .padding()
                .lineLimit(nil)
            HTMLTextView(htmlContent: image.description)
                .frame(maxHeight: 300) //frame height
                .padding()
                .padding()
            Text("Author: \(image.formattedAuthor)")
                .padding()
                .lineLimit(nil)
            Text("Published: \(formatDate(dateString: image.published))")
                .padding()
                .lineLimit(nil)
            Text("Date Taken: \(formatDate(dateString: image.date_taken))")
                .padding()
                .lineLimit(nil)
        }
        .navigationTitle(image.title)
    }
    
    // Helper function to format the date
    func formatDate(dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            return displayFormatter.string(from: date)
        }
        return dateString
    }
}
