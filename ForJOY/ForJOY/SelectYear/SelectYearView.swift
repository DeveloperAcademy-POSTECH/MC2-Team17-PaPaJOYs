//
//  SelectYearView.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/05/02.
//

import SwiftUI

struct SelectYearView: View {
    @State private var isNewest = true
    @State private var selectedTag = "All"
    var body: some View {
        NavigationStack {
            ZStack {
                Color("JoyDarkG")
                    .ignoresSafeArea()
                VStack(spacing: 20) {
                    HeaderView(isNewest: $isNewest)
                    HStack {
                        Spacer()
                        TagView(selectedTag: $selectedTag)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        AlbumView(isNewest: $isNewest, selectedTag: $selectedTag)
                        Spacer()
                    }
                }
            }
        }
    }
}

struct HeaderView: View {
    @Binding var isNewest: Bool
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Spacer()
                NavigationLink(destination: VoiceView()) {
                    Image(systemName: "mic.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color(hex: "659BD5"))
                }
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
                    Image(systemName: "slider.horizontal.3")
                        .font(.title2)
                        .foregroundColor(Color(hex: "659BD5"))
                }
                .padding(.trailing, 20)
            }
        }
    }
}

struct TagView: View {
    @ObservedObject var postViewModel = PostViewModel()
    @Binding var selectedTag: String
    @State var isAllSelect = true

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                Button {
                    selectedTag = "All"
                    isAllSelect = true
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 75, height: 30)
                        .foregroundColor(isAllSelect ? Color("JoyYellow") : Color(hex: "F2F2F7"))
                        .opacity(0.9)
                        .overlay(
                            Text("모든태그")
                                .font(.subheadline)
                                .foregroundColor(.black)
                                .lineLimit(1)
                        )
                }
                ForEach(postViewModel.tags ?? [], id: \.self) { i in
                    Button {
                        selectedTag = i
                        isAllSelect = false
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 75, height: 30)
                            .foregroundColor(isAllSelect ? Color(hex: "F2F2F7") : (selectedTag == i ? Color("JoyYellow") : Color(hex: "F2F2F7")))
                            .opacity(0.9)
                            .overlay(
                                Text("#" + i)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                            )
                    }
                }
            }
        }
    }
}

struct AlbumView: View {
    @ObservedObject var postViewModel = PostViewModel()
    @Binding var isNewest: Bool
    @Binding var selectedTag: String
    
    // 데이터를 연도 단위로 묶어주기
    var YearGroup: [String: [PostModel]] {
        var data = Dictionary(grouping: postViewModel.postData) { i in
            i.year
        }
        for(key, value) in data {
            data[key] = value.sorted(by: {$0.idx > $1.idx})
        }
        
        if selectedTag == "All" {
            return data
        } else {
            let filteredData = data.filter({ $0.value.contains(where: { $0.tagName == selectedTag })})
            let filteredByTag = filteredData.mapValues { value in
                value.filter{ $0.tagName == selectedTag }
            }
            return filteredByTag
        }
    }
    
    
    var yearKey: [String] {
        let temp = YearGroup.map({ $0.key }).sorted()
        
        return isNewest ? temp.reversed() : temp
    }
    
    var columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 12), count: 2)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(yearKey, id: \.self) { i in
                    NavigationLink(destination: GalleryView(tagName: selectedTag, year: i)) {
                        AlbumSubView(post: YearGroup[i]![0])
                    }
                }
            }
        }
    }
}

struct AlbumSubView: View {
    let post: PostModel
    var body: some View {
        ZStack {
            Color("JoyWhite")
            VStack {
                Image(post.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: screenWidth * 0.4, height: screenWidth * 0.4)
                    .clipped()
                    .cornerRadius(10)
                    .padding(10)
                HStack {
                    Spacer()
                    Text(post.year)
                        .font(.headline)
                        .foregroundColor(Color("JoyDarkG"))
                        .padding(.top, -10)
                        .padding(.trailing, 15)
                }
                .padding(.bottom, 10)
            }
        }
        .cornerRadius(10)
    }
}

struct SelectYearView_Previews: PreviewProvider {
    static var previews: some View {
        SelectYearView()
    }
}
