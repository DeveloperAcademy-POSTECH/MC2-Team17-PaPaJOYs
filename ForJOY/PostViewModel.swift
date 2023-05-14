//
//  PostViewModel.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/05/12.
//


import SwiftUI
import AVKit

class PostViewModel: ObservableObject {
    // 전체 데이터(임시) - DB와 연결 필요
    @Published var postData: [PostModel] = [
        PostModel(tagName: "아카데미", imageName: "test2", audioName: "Overnight", title: "가족사진이어요", year: "2023", date: "2023.05.05", idx: 1),
        PostModel(tagName: "딸랑구", imageName: "test1", audioName: "I AM", title: "축제 즐기기", year: "2023", date: "2023.03.05", idx: 2),
        PostModel(tagName: "딸랑구", imageName: "test3", audioName: "Overnight", title: "노래감상", year: "2022", date: "2022.05.05", idx: 1),
        PostModel(tagName: "아카데미", imageName: "test4", audioName: "I AM", title: "댄스왕🕺", year: "2021", date: "2021.03.05", idx: 1),
        PostModel(tagName: "아카데미", imageName: "test5", audioName: "Overnight", title: "푸드트럭 즐기기", year: "2020", date: "2020.05.05", idx: 1),
        PostModel(tagName: "딸랑구", imageName: "test6", audioName: "I AM", title: "모델같은 둘째", year: "2020", date: "2020.03.05", idx: 2)
    ]
    
    // SelectYearView에서 태그 사용을 위한 배열
    @Published var tags: [String]?
    
    // CardView에서 음악 멈추기 위한 배열
    @Published var players: [AVPlayer] = []
    
    
    // 필터링된 데이터들
    @Published var filteredData: [PostModel] = []
    
    init() {
        self.tags = Array(Set(postData.map { $0.tagName })).sorted()
    }
    
    // 필터링 위한 함수
    func filterData(tagName: String, year: String) {
        if tagName == "All" {
            self.filteredData = postData.filter{ $0.year == year }.sorted(by: { $0.idx > $1.idx })
        } else {
            self.filteredData = postData.filter{ $0.tagName == tagName && $0.year == year }.sorted(by: { $0.idx > $1.idx })
        }
        makePlayers()
    }
    
    func makePlayers() {
        self.players = filteredData.map{ AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: $0.audioName, ofType: "mp3")!)) }
    }
}
