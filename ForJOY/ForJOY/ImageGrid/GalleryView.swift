//
//  GalleryView.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/05/09.
//

import SwiftUI

struct GalleryView: View {
    @ObservedObject var postViewModel = PostViewModel()
    var tagName: String
    var year: String
    
    init(tagName: String, year: String) {
        
        self.tagName = tagName
        self.year = year
        
        // 데이터 필터링하기
        postViewModel.filterData(tagName: self.tagName, year: self.year)
        
        // 네비게이션바 투명
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    @State var offset = CGSize(width: 0.0, height: screenHeight * 0.07)
    
    var columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 3), count: 3)
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 3) {
                        ForEach(Array(postViewModel.filteredData.enumerated()), id: \.1) { i, post in
                            NavigationLink(destination: CardView(filteredData: $postViewModel.filteredData, players: $postViewModel.players, order: i)) {
                                Image(post.imageName)
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
                        Text("#" + tagName + " " + year)
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
                Button(action: {}) {
                    Image(systemName: "mic.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color(hex: "659BD5"))
                }
            }
        }
    }
}

//struct GalleryView_Previews: PreviewProvider {
//    static var previews: some View {
//        GalleryView(tagName: "조이서", year: "2021", image: )
//    }
//}
