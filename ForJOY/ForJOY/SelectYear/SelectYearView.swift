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
    
    @State private var contentWidth = 0.0
    @State private var scrollID = UUID()
    
    private let descriptionForNil = "첫 기록을 기다리고 있어요"
    private let imageForNil = "EmptyMemory"
    private let imageForNilSize = 200.0 * UIScreen.height / 844
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.joyBlack
                    .ignoresSafeArea()

                if memories.count > 0 {
                    AlbumView(memories: $memories, isNewest: $isNewest, selectedTag: $selectedTag)
                        .padding(.horizontal)
                        .padding(.top, 20)
                        
                } else {
                    VStack(spacing: 25) {
                        Image(imageForNil)
                            .resizable()
                            .frame(width: imageForNilSize, height: imageForNilSize)
                        
                        Text(descriptionForNil)
                            .font(Font.body2Kor)
                            .foregroundColor(Color.joyWhite)
                        
                        Spacer()
                    }
                    .padding(.top, 140)
                }

                VStack() {
                    Spacer()
                    PhotoSelectButton(memories: $memories, tags: $tags)
                }
            }
            .edgesIgnoringSafeArea([.bottom])
            
            .navigationBarItems(leading: TagView)
            .navigationBarItems(trailing: SortButton)
        }
        .onAppear {
            getLoad()
        }
    }
    
    func getLoad() {
        tags = CoreDataManager.coreDM.getUniqueTags()
        memories = CoreDataManager.coreDM.getYearlyMemories()
    }
    
    private var TagView: some View {
        // 메뉴 버튼 버전
        Menu {
            Button {
                selectedTag = "All"
                isAllSelect = true
            } label: {
                HStack {
                    Text("모든 태그")
                    
                    Spacer()
                    
                    if isAllSelect {
                        Image(systemName: "checkmark")
                    }
                }
            }
            
            ForEach(tags, id: \.self) { i in
                Button {
                    selectedTag = i
                    isAllSelect = false
                } label: {
                    HStack {
                        Text(i)
                        
                        Spacer()
                        
                        if i == selectedTag {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            HStack(spacing: 5) {
                Image(systemName: "tag.fill")
                
                Text(selectedTag == "All" ? "모든 태그" : selectedTag)
                    .lineLimit(1)
            }
                .font(Font.body2Kor)
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(Color.joyBlue)
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .transaction { transaction in
            transaction.animation = nil
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
                HStack {
                    Text("오래된 항목 순으로")
                    Spacer()
                    if !isNewest {
                        Image(systemName: "checkmark")
                    }
                }
            }
        } label: {
            Image(systemName: "chevron.up.chevron.down")
                .foregroundColor(Color.joyBlue)
                .padding(.leading, 60)
        }
    }
}

struct AlbumView: View {
    @Binding var memories: [Int: [Memory]]
    @Binding var isNewest: Bool
    @Binding var selectedTag: String
    
    var columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 20), count: 2)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                if selectedTag == "All" {
                    ForEach(Array(isNewest ? memories.keys.sorted(by: >) : memories.keys.sorted()), id: \.self) { key in
                        NavigationLink(destination: GalleryView(year: key, tagName: $selectedTag, album: memories[key]!)) {
                                AlbumSubView(post: memories[key]!.last!)
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
                        NavigationLink(destination: GalleryView(year: key, tagName: $selectedTag, album: filterMemories[key]!)) {
                                AlbumSubView(post: filterMemories[key]!.last!)
                        }
                    }
                }
            }
        }
    }
}

struct AlbumSubView: View {
    let post: Memory
    
    private let imageForNil = "EmptyMemory"
    private let imageSize = UIScreen.width / 2 - 52
    
    var body: some View {
        ZStack {
            Color.joyWhite
            VStack(alignment: .trailing, spacing: 0) {
                Image(uiImage: UIImage(data: Data(base64Encoded: post.image)!) ?? UIImage(named: imageForNil)!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imageSize, height: imageSize)
                    .clipped()
                    .cornerRadius(9)
                    .padding(.top, 13)
                
                Text("\(post.year)"
                    .replacingOccurrences(of: ",", with: ""))
                    .font(Font.title1)
                    .foregroundColor(Color.joyBlack)
                    .padding(10)
            }
            .padding(.horizontal, 13)
        }
        .cornerRadius(10)
    }
}
