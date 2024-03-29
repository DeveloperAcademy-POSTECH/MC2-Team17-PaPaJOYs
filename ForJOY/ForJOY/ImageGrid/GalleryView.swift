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
    
    //
    var year: Int
    @Binding var tagName: String
    @State var album: [Memory]

    private let imageSize = (UIScreen.width - 9) / 3
    
    var columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 4.5), count: 3)
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollViewReader { value in
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 4.5) {
                            ForEach(Array(album.enumerated()), id: \.0) { i, post in
                                NavigationLink(destination: CardView(players: $players.players, order: i, filteredData: $album)) {
                                    Image(uiImage: UIImage(data: Data(base64Encoded: post.image)!) ?? UIImage(named: "EmptyMemory")!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: imageSize, height: imageSize)
                                        .clipped()
                                        .cornerRadius(10)
                                }
                            }
                        }
                        .offset(self.offset)
                        .onAppear {
                            if isNewest {
                                album.sort{ $0.date > $1.date }
                            } else {
                                album.sort{ $0.date < $1.date }
                            }
                        }
                    }
                }
                .background(Color.joyBlack)
                
                VStack {
                    Color.joyBlack
                        .ignoresSafeArea()
                        .opacity(0.5)
                        .blur(radius: 10)
                        .frame(height: UIScreen.height * 0.07)
                    
                    Spacer()
                }
                
                HStack {
                    VStack {
                        Text(tagName == "All" ? year.description : "\(tagName) \(year.description)")
                            .font(Font.largeTitle)
                            .foregroundColor(Color.joyWhite)
                        
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
                .foregroundColor(Color.joyBlue)
        }
    }
    
    private var SortButton: some View {
        Menu {
            Button(action: {
                isNewest = true
                album.sort{ $0.date > $1.date }
            }) {
                HStack {
                    Text("최신 항목 순으로")
                    Spacer()
                    if isNewest {
                        Image(systemName: "checkmark")
                    }
                }
            }
            Button(action: {
                isNewest = false
                album.sort{ $0.date < $1.date }
            }) {
                Text("오래된 항목 순으로")
                Spacer()
                if !isNewest {
                    Image(systemName: "checkmark")
                }
            }
        } label: {
            Image(systemName: "chevron.up.chevron.down")
                .foregroundColor(Color.joyBlue)
        }
    }
}
