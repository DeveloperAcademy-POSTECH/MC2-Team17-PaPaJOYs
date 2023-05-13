//
//  PostViewModel.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/05/12.
//


import SwiftUI
import AVKit

class PostViewModel: ObservableObject {
    @Published var postData: [PostModel] = [
        PostModel(tagName: "조이한", imageName: "test1", audioName: "Overnight", title: "봄봄봄🌹", year: "2023", date: "2023.05.05", idx: 1),
        PostModel(tagName: "조이서", imageName: "test2", audioName: "I AM", title: "조이서2023 테스트", year: "2023", date: "2023.03.05", idx: 2),
        PostModel(tagName: "조이서", imageName: "test3", audioName: "Overnight", title: "조이서 2022 테스트", year: "2022", date: "2022.05.05", idx: 1),
        PostModel(tagName: "조이한", imageName: "test4", audioName: "I AM", title: "조이서2021 테스트", year: "2021", date: "2021.03.05", idx: 1),
        PostModel(tagName: "조이한", imageName: "test5", audioName: "Overnight", title: "2020테스트 이한", year: "2020", date: "2020.05.05", idx: 1),
        PostModel(tagName: "조이서", imageName: "test6", audioName: "I AM", title: "조이서2020 테스트", year: "2020", date: "2020.03.05", idx: 2)
    ]
    
    @Published var tags: [String]?
    
    @Published var players: [AVPlayer]?
    
    init() {
        self.tags = Array(Set(postData.map { $0.tagName })).sorted()
        self.players = postData.map{ AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: $0.audioName, ofType: "mp3")!)) }
    }
}
