//
//  GalleryView.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/05/09.
//

import SwiftUI

struct GalleryView: View {
    @Environment(\.dismiss) var dismiss
    @State var offset = CGSize(width: 0.0, height: screenHeight * 0.07)
    
    var tagName: String
    var year: Int
    var album: [Memory]
    
    init(tagName: String, year: Int, album: [Memory]) {
        self.tagName = tagName
        self.year = year
        self.album = album
        
        // 네비게이션바 투명
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    var columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 3), count: 3)
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 3) {
                    ForEach(album, id: \.self) { post in
                        NavigationLink(destination: CardView(filteredData: album)) {
                        Image(uiImage: UIImage(data: post.image) ?? UIImage(systemName: "house")!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: screenWidth / 3 - 3, height: screenWidth / 3 - 3)
                            .clipped()
                        }
                    }
                }
                .offset(self.offset)
            }
            .background(Color("JoyDarkG"))

            VStack {
                Color("JoyDarkG")
                    .ignoresSafeArea()
                    .opacity(0.5)
                    .blur(radius: 10)
                    .frame(height: screenHeight * 0.07)
                Spacer()
            }

            HStack {
                VStack {
                    Text("#" + tagName + " " + "\(year)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.top)
                .padding(.leading)
                Spacer()
            }
        }
        .toolbar {
            //TODO: VoiceView와 연동
            Button(action: {}) {
                NavigationLink(destination: VoiceView()) {
                    Image(systemName: "mic.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color(hex: "659BD5"))
                }
                .isDetailLink(false)
            }
        }
    }
}
