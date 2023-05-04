//
//  SelectYearView.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/05/02.
//

// 뷰만 그려놓음, 기능 구현 필요!!

import SwiftUI

struct SelectYearView: View {
    var body: some View {
        VStack(spacing: 20) {
            HeaderView()
//            Spacer()
            AlbumView()
        }
    }
}

struct HeaderView: View {
    @ObservedObject var viewModel = TestViewModel()
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Button(action: {}) {
                    Image(systemName: "plus")
                }
                .padding(.leading, 20)
                Spacer()
                Menu("정렬") {
                    Button("최근부터 보기", action: {})
                    Button("과거부터 보기", action: {})
                }
                .padding(.trailing, 20)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.testData) { i in
                        TagView(name: i.tagName)
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
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    VStack {
                        Button(action: {}) {
                            Rectangle()
                                .frame(width: screenWidth * 0.42, height: screenWidth * 0.42)
                        }
                        Text("2023")
                    }
                    .padding(.leading, 20)
                    Spacer()
                    VStack {
                        Button(action: {}) {
                            Rectangle()
                                .frame(width: screenWidth * 0.42, height: screenWidth * 0.42)
                        }
                        Text("2022")
                    }
                    .padding(.trailing, 20)
                }
                HStack {
                    VStack {
                        Button(action: {}) {
                            Rectangle()
                                .frame(width: screenWidth * 0.42, height: screenWidth * 0.42)
                        }
                        Text("2021")
                    }
                    .padding(.leading, 20)
                    Spacer()
                    VStack {
                        Button(action: {}) {
                            Rectangle()
                                .frame(width: screenWidth * 0.42, height: screenWidth * 0.42)
                        }
                        Text("2020")
                    }
                    .padding(.trailing, 20)
                }
                HStack {
                    VStack {
                        Button(action: {}) {
                            Rectangle()
                                .frame(width: screenWidth * 0.42, height: screenWidth * 0.42)
                        }
                        Text("2019")
                    }
                    .padding(.leading, 20)
                    Spacer()
                    VStack {
                        Button(action: {}) {
                            Rectangle()
                                .frame(width: screenWidth * 0.42, height: screenWidth * 0.42)
                        }
                        Text("2018")
                    }
                    .padding(.trailing, 20)
                }
                
                HStack {
                    VStack {
                        Button(action: {}) {
                            Rectangle()
                                .frame(width: screenWidth * 0.42, height: screenWidth * 0.42)
                        }
                        Text("2017")
                    }
                    .padding(.leading, 20)
                    Spacer()
                    VStack {
                        Button(action: {}) {
                            Rectangle()
                                .frame(width: screenWidth * 0.42, height: screenWidth * 0.42)
                        }
                        Text("2016")
                    }
                    .padding(.trailing, 20)
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
