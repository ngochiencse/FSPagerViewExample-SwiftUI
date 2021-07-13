//
//  ContentView.swift
//  FSPagerViewExample-SwiftUI
//
//  Created by Hien Pham on 7/13/21.
//

import SwiftUI

struct ContentView: View {
    private struct TutorialItem: Identifiable {
        let id: UUID = UUID()
        let image: String
    }

    private let images: [TutorialItem] = [
        TutorialItem(image: "1"),
        TutorialItem(image: "2"),
        TutorialItem(image: "3"),
        TutorialItem(image: "4"),
        TutorialItem(image: "5"),
        TutorialItem(image: "6"),
        TutorialItem(image: "7"),
    ]
    
    @State var currentPage: Int = 0
    var body: some View {
        ZStack(content: {
            FSPagerViewSUI($currentPage, images) { item in
                Image(item.image)
                    .resizable()
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )
            }

            VStack(alignment: .center, spacing: nil, content: {
                FSPageControlSUI(currentPage: $currentPage)
                    .numberOfPages(images.count)
                    .contentHorizontalAlignment(.right)
                    .contentInsets(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
                    .frame(maxWidth: .infinity)
                    .frame(height: 20)
                .background(Color.black.opacity(0.5))
            })
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .bottomTrailing
            )
        })
        .aspectRatio(375.0/193.0, contentMode: .fit)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
