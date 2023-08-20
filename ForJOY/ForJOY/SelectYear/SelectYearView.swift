//
//  SelectYearView.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/05/02.
//

import SwiftUI
import PhotosUI

struct SelectYearView: View {
    @State private var tags: [String] = []
    @State private var memories: [Int: [Memory]] = [:]
    
    @State private var isNewest = true
    @State private var isAllSelect = true
    @State private var selectedTag = "All"
    
//    @State private var offset: CGSize = CGSize(width: 100, height: 0.0)
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("JoyDarkG")
                    .ignoresSafeArea()
                
                if memories.count > 0 {
                    VStack(spacing: 15) {
                        HeaderView
                            .padding(.top, 5)
                        
                        AlbumView(isNewest: $isNewest, selectedTag: $selectedTag)
                            .padding(10)
                            .ignoresSafeArea()
                    }
                } else {
                    Text("아직 저장된 추억이 없어요")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
                VStack() {
                    Spacer()
                    PhotoSelectButton()
                }
                .edgesIgnoringSafeArea([.bottom])
            }
        }
        .onAppear {
            getLoad()
        }
    }
    
    func getLoad() {
        tags = CoreDataManager.coreDM.getUniqueTags()
        memories = CoreDataManager.coreDM.getYearlyMemories()
    }
    
    private var InfoButton: some View {
        Button {
            
        } label: {
            Image(systemName: "info.circle")
        }

    }
    
    private var HeaderView: some View {
        HStack(spacing: 50) {
            Menu {
                Button(action: {isNewest = true}) {
                    HStack {
                        Text("최근부터 보기")
                        Spacer()
                        if isNewest {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                Button(action: {isNewest = false}) {
                    Text("과거부터 보기")
                    Spacer()
                    if !isNewest {
                        Image(systemName: "checkmark")
                    }
                }
            } label: {
                Image(systemName: "chevron.up.chevron.down")
                    .font(.system(size: 25))
                    .foregroundColor(Color("JoyBlue"))
                    .padding(.leading, 20)
            }
            
            TagView
                .frame(alignment: .trailing)
        }
    }
    
    private var TagView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                Button {
                    selectedTag = "All"
                    isAllSelect = true
                } label: {
                    Text("모든 태그")
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(isAllSelect ? Color("JoyBlue") : Color("JoyDarkG"))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .strokeBorder(isAllSelect ? Color("JoyBlue") : Color("JoyWhite"), lineWidth: 1)
                        )
                }

                ForEach( Array(tags.sorted().filter{$0 != "기본"}) , id: \.self) { i in
                    Button {
                        selectedTag = i
                        isAllSelect = false
                    } label: {
                        Text("#" + i)
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(isAllSelect ? Color("JoyDarkG") : (selectedTag == i ? Color("JoyBlue") : Color("JoyDarkG")))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .overlay {
                                RoundedRectangle(cornerRadius: 6)
                                    .strokeBorder(isAllSelect ? Color("JoyWhite") : (selectedTag == i ? Color("JoyBlue") : Color("JoyWhite")))
                            }
                    }
                }
            }
        }
    }
}

struct AlbumView: View {
    @Binding var isNewest: Bool
    @Binding var selectedTag: String
    
    var columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 10), count: 2)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                let memories = CoreDataManager.coreDM.getYearlyMemories()
                
                if selectedTag == "All" {
                    ForEach(Array(isNewest ? memories.keys.sorted(by: >) : memories.keys.sorted()), id: \.self) { key in
                        NavigationLink(destination: GalleryView(tagName: selectedTag, year: key, album: memories[key]!)) {
                                AlbumSubView(post: memories[key]!.first!)
                        }
                    }
                } else {
                    let filterMemories = memories.reduce(into: [Int: [Memory]]()){ result, entry in
                        let filterdMemories = entry.value.filter {$0.tag == selectedTag}
                        if !filterdMemories.isEmpty {
                            result[entry.key] = filterdMemories
                        }
                    }
                    
                    ForEach(Array(isNewest ? filterMemories.keys.sorted(by: >) : filterMemories.keys.sorted()), id: \.self) { key in
                        NavigationLink(destination: GalleryView(tagName: selectedTag, year: key, album: filterMemories[key]!)) {
                                AlbumSubView(post: filterMemories[key]!.first!)
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
        }
    }
}

struct AlbumSubView: View {
    let post: Memory
    var body: some View {
        ZStack {
            Color("JoyWhite")
            VStack(alignment: .trailing, spacing: 0) {
                Image(uiImage: UIImage(data: Data(base64Encoded: post.image)!) ?? UIImage(systemName: "house")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: screenWidth * 0.38, height: screenWidth * 0.38)
                    .clipped()
                    .cornerRadius(9)
                    .padding(.top, 13)
                
                Text("\(post.year)".replacingOccurrences(of: ",", with: ""))
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color("JoyDarkG"))
                    .padding(.vertical, 10)
            }
            .padding(.horizontal, 12)
        }
        .cornerRadius(10)
    }
}
