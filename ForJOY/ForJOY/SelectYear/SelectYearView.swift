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
    var body: some View {
        VStack(spacing: 20) {
            HeaderView(isNewest: $isNewest)
            AlbumView(isNewest: $isNewest)
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
                    Image(systemName: "plus")
                }
                .padding(.leading, 20)
                Spacer()
                Menu("정렬") {
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
                }
                .padding(.trailing, 20)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.testName, id: \.self) { name in
                        TagView(name: name)
                    }
                }
            }
            .frame(width: screenWidth * 0.4)
        }
    }
}

struct TagView: View {
    @State var isSelected = false
    let name: String
    var body: some View {
        Text(name)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(10)
            .lineLimit(1)
            .background(isSelected ? Color.yellow : Color.gray)
            .frame(height: 25)
            .cornerRadius(7)
            .onTapGesture {
                isSelected.toggle()
            }
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
        var temp = YearGroup.map({ $0.key }).sorted()
        
        return isNewest ? temp.reversed() : temp
    }
    // Grid를 사용하기 위한..?!
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(yearKey, id: \.self) { i in
                    VStack {
                        Button(action: {}) {
                            YearGroup[i]![0].image
                                .resizable()
                                .scaledToFit()
                        }
                        Text(i)
                    }
                }
            }
        }
    }
}

struct SelectYearView_Previews: PreviewProvider {
    static var previews: some View {
        SelectYearView()
    }
}
