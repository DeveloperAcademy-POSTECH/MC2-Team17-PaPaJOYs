//
//  GalleryView.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/05/09.
//

import SwiftUI

struct GalleryView: View {
    var columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 3), count: 3)
    let testImg = ["test1", "test2", "test3", "test4", "test5", "test6", "test7", "test8"]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 3) {
                ForEach(testImg, id: \.self) { name in
                    Image(name)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: screenWidth / 3 - 3, height: screenWidth / 3 - 3)
                        .clipped()
                }
            }
        }
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView()
    }
}
