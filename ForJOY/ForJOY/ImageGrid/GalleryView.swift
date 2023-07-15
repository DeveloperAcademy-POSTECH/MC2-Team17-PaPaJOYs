//
//  GalleryView.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/05/09.
//

import SwiftUI
import AVFoundation

struct GalleryView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var players = Players()
    @Binding var isNewestDay: Bool
    @State var offset: CGSize = CGSize(width: 0.0, height: screenHeight * 0.07)
    
    var tagName: String
    var year: Int
    var album: [Memory]
    
    
    init(tagName: String, year: Int, album: [Memory], isNewestDay: Binding<Bool>) {
        self.tagName = tagName
        self.year = year
        self.album = album
        self._isNewestDay = isNewestDay
        
        players.makePlayers(filteredData: self.album)
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    var columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 3), count: 3)
    
    var body: some View {
        NavigationStack{
            ZStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 3) {
                        ForEach(Array(album.enumerated()), id: \.1) { i, post in
                            NavigationLink(destination: CardView(players: $players.players, filteredData: album ,order: i)) {
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
                Menu {
                    Button(action: {isNewestDay = true}) {
                        HStack {
                            Text("최근부터 보기")
                            Spacer()
                            if isNewestDay {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    Button(action: {isNewestDay = false}) {
                        Text("과거부터 보기")
                        Spacer()
                        if !isNewestDay {
                            Image(systemName: "checkmark")
                        }
                    }
                } label: {
                    Image(systemName: "chevron.up.chevron.down")
                        .foregroundColor(Color("JoyBlue"))
                }
            }
        }
    }
}
