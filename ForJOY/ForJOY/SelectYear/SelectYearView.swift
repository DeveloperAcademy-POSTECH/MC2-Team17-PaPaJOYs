//
//  SelectYearView.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/05/02.
//

import SwiftUI

struct SelectYearView: View {
    @State var isNewest = true
    @State var selection = "All"
    var body: some View {
        NavigationStack {
            ZStack {
                Color("JoyDarkG")
                    .ignoresSafeArea()
                VStack(spacing: 20) {
                    HeaderView(isNewest: $isNewest)
                    HStack {
                        Spacer()
                        TagView(selection: $selection)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        AlbumView(isNewest: $isNewest, selection: $selection)
                        Spacer()
                    }
                }
            }
        }
    }
}

struct HeaderView: View {
    @ObservedObject var viewModel = TestViewModel()
    @Binding var isNewest: Bool
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Spacer()
                // 녹음하는 뷰와 이어지는 NavigationLink로 변경 예정
                Button(action: {}) {
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
    @ObservedObject var viewModel = TestViewModel()
    @Binding var selection: String
    @State var isAllSelect = true
    
    var tags: [String] {
        Array(Set(viewModel.testData.map { $0.tagName })).sorted()
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                Button {
                    selection = "All"
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
                ForEach(viewModel.tags!, id: \.self) { i in
                    Button {
                        selection = i
                        isAllSelect = false
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 75, height: 30)
                            .foregroundColor(isAllSelect ? Color(hex: "F2F2F7") : (selection == i ? Color("JoyYellow") : Color(hex: "F2F2F7")))
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
    @ObservedObject var viewModel = TestViewModel()
    @Binding var isNewest: Bool
    @Binding var selection: String
    
    // 데이터를 연도 단위로 묶어주기
    var YearGroup: [String: [TestModel]] {
        var data = Dictionary(grouping: viewModel.testData) { i in
            i.year
        }
        for(key, value) in data {
            data[key] = value.sorted(by: {$0.idx > $1.idx})
        }
        
        if selection == "All" {
            return data
        } else {
            let filteredData = data.filter({ $0.value.contains(where: { $0.tagName == selection })})
            let filteredByTag = filteredData.mapValues { value in
                value.filter{ $0.tagName == selection }
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
                    let filteredData = (selection == "All" ? YearGroup[i]! : YearGroup[i]!.filter{ $0.tagName == selection })
                    NavigationLink(destination: GalleryView(tagName: selection, year: i, imageNames: filteredData.map{ $0.imageName })) {
                        AlbumSubView(imageName: YearGroup[i]![0].imageName, year: i)
                    }
                }
            }
        }
    }
}

struct AlbumSubView: View {
    let imageName: String
    let year: String
    var body: some View {
        ZStack {
            Color("JoyWhite")
            VStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: screenWidth * 0.4, height: screenWidth * 0.4)
                    .clipped()
                    .cornerRadius(10)
                    .padding(10)
                HStack {
                    Spacer()
                    Text(year)
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
