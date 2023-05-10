//
//  GalleryView.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/05/09.
//

// 스크롤 인식을 통한 변경사항 적용 필요...


import SwiftUI

struct GalleryView: View {
    init(tagName: String, year: String) {
        
        self.tagName = tagName
        self.year = year
//         네비게이션바 투명
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
//         네비게이션 타이틀 색상 변경
//        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
//        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        
        //네비게이션바 색상 변경
//        let inlineAppearance = UINavigationBarAppearance()
//        inlineAppearance.backgroundColor = .red

//        let largeAppearance = UINavigationBarAppearance()
//        largeAppearance.backgroundColor = .black.withAlphaComponent(0.1)
//
//        UINavigationBar.appearance().standardAppearance = largeAppearance
//        UINavigationBar.appearance().compactAppearance = inlineAppearance

    }
    @State var offset = CGSize(width: 0.0, height: screenHeight * 0.07)
    
    var columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 3), count: 3)
    let testImg = ["test1", "test2", "test3", "test4", "test5", "test6", "test7", "test8"]
    
    var tagName: String
    var year: String
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("JoyDarkG")
                    .ignoresSafeArea()
                HStack {
//                    ScrollViewReader { proxy in
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 3) {
                            ForEach(testImg, id: \.self) { name in
                                Image(name)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: screenWidth / 3 - 3, height: screenWidth / 3 - 3)
                                    .clipped()
                            }
                        }
                        .offset(self.offset)
//                        .onAppear{
//                            proxy.scrollTo(0, anchor: .top)
//                        }
                    }
//                    }
                }
            }
            
//            .navigationTitle("#" + tagName + " " + year)
            .toolbar {
                Button(action: {}) {
                    Image(systemName: "mic.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color(hex: "659BD5"))
                }
            }
        }
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView(tagName: "조이서", year: "2021")
    }
}
