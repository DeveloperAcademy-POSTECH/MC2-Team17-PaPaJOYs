//
//  SelectYearView.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/05/02.
//

// 뷰만 그려놓음, 기능 구현 필요!!


import SwiftUI

struct SelectYearView: View {
    @State var isNewest = true
    @State var tagActive = Array(repeating: true, count: TestViewModel().testName.count)
    var body: some View {
        ZStack {
            Color(hex: "524F4D")
                .ignoresSafeArea()
            VStack(spacing: 20) {
                HeaderView(isNewest: $isNewest)
                HStack {
                    Spacer()
                    TagView()
                }
                .padding(.trailing, 15)
                AlbumView(isNewest: $isNewest)
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
                Button(action: {}) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(Color(hex: "659BD5"))
                }
                .padding(.leading, 20)
                Spacer()
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
                        .foregroundColor(Color(hex: "659BD5"))
                }
                .padding(.trailing, 20)
            }
        }
    }
}

struct TagView: View {
    @ObservedObject var viewModel = TestViewModel()
    @State var isAllSelect = true
//    @Binding var tagActive: [Bool]
    
    // 데이터를 태그 단위로 묶어주기
    var TagGroup: [String: [TestModel]] {
        var data = Dictionary(grouping: viewModel.testData) { i in
            i.tagName
        }
        for(key, value) in data {
            data[key] = value.sorted(by: {$0.idx > $1.idx})
        }
        return data
    }
    
    var tagKey: [String] {
        TagGroup.map({ $0.key }).sorted()
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                Text("모든태그")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding(10)
                    .lineLimit(1)
                    .background(isAllSelect ? Color("JoyYellow") : Color(hex: "F2F2F7"))
                    .opacity(0.9)
                    .frame(width: 75, height: 30)
                    .cornerRadius(7)
                    .onTapGesture {
                        isAllSelect.toggle()
                        if isAllSelect {
                            viewModel.testName = Dictionary(uniqueKeysWithValues: viewModel.testName.map { ($0.key, true) })
                        }
                        
                    }
                
                ForEach(tagKey, id: \.self) { i in
                    Text("#" + i)
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding(10)
                        .lineLimit(1)
                        .background(viewModel.testName[i]! ? Color("JoyYellow") : Color(hex: "F2F2F7"))
                        .opacity(0.9)
                        .frame(width: 75, height: 30)
                        .cornerRadius(10)
                        .onTapGesture {
                            viewModel.testName[i]!.toggle()
                        }
                }
            }
        }
        .frame(width: screenWidth * 0.6)
    }
}

struct AlbumView: View {
    @ObservedObject var viewModel = TestViewModel()
    @Binding var isNewest: Bool
    
    // 데이터를 연도 단위로 묶어주기
    var YearGroup: [String: [TestModel]] {
        var data = Dictionary(grouping: viewModel.testData) { i in
            i.year
        }
        for(key, value) in data {
            data[key] = value.sorted(by: {$0.idx > $1.idx})
        }
        return data
    }
    var yearKey: [String] {
        let temp = YearGroup.map({ $0.key }).sorted()
        
        return isNewest ? temp.reversed() : temp
    }
    // Grid를 사용하기 위한..?!
    var columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 12), count: 2)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(yearKey, id: \.self) { i in
                    Button(action: {}) {
                        AlbumSubView(image: YearGroup[i]![0].image, year: i)
                    }
                }
            }
        }
        .padding(.leading, 15)
        .padding(.trailing, 15)
    }
}

struct AlbumSubView: View {
    let image: Image
    let year: String
    var body: some View {
        ZStack {
            Color.white
            VStack {
                image
                    .resizable()
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
