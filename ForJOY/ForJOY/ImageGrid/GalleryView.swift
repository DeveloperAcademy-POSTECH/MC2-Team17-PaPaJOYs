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
    @State private var offset: CGSize = CGSize(width: 0.0, height: UIScreen.height * 0.07)
    @State private var isNewest = true
    
    var tagName: String
    var year: Int
    var album: [Memory]

    private let imageSize = (UIScreen.width - 9) / 3
    
//    init(tagName: String, year: Int, album: [Memory]) {
//        self.tagName = tagName
//        self.year = year
//        self.album = album
//
//        players.makePlayers(filteredData: self.album)
//    }
    
    var columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 4.5), count: 3)
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollViewReader { value in
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 4.5) {
                            // TODO: 정렬하기..
                            ForEach(Array(album.enumerated()), id: \.0) { i, post in
                                NavigationLink(destination: CardView(players: $players.players, order: i, filteredData: album)) {
                                    Image(uiImage: UIImage(data: Data(base64Encoded: post.image)!) ?? UIImage(systemName: "house")!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: imageSize, height: imageSize)
                                        .clipped()
                                        .cornerRadius(10)
                                }
                            }
                        }
                        .offset(self.offset)
                    }
                }
                .background(Color("JoyDarkG"))
                
                VStack {
                    Color("JoyDarkG")
                        .ignoresSafeArea()
                        .opacity(0.5)
                        .blur(radius: 10)
                        .frame(height: UIScreen.height * 0.07)
                    
                    Spacer()
                }
                
                HStack {
                    VStack {
                        if tagName == "All" {
                            Text(year.description)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        } else {
                            Text(tagName + " " + year.description)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 10)
                    .padding(.leading)
                    
                    Spacer()
                }
            }
            .onAppear {
                players.makePlayers(filteredData: self.album)
            }
            
            .navigationBarBackButtonHidden()
            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationBarItems(leading: BackButton)
            .navigationBarItems(trailing: SortButton)
        }
    }
    
    private var BackButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .foregroundColor(Color("JoyBlue"))
        }
    }
    
    private var SortButton: some View {
        Menu {
            Button(action: {isNewest = true}) {
                HStack {
                    Text("최신 항목 순으로")
                    Spacer()
                    if isNewest {
                        Image(systemName: "checkmark")
                    }
                }
            }
            Button(action: {isNewest = false}) {
                Text("오래된 항목 순으로")
                Spacer()
                if !isNewest {
                    Image(systemName: "checkmark")
                }
            }
        } label: {
            Image(systemName: "chevron.up.chevron.down")
                .foregroundColor(Color("JoyBlue"))
        }
    }
    
    
}
