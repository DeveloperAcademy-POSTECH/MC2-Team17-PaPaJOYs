//
//  Players.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/05/15.
//

import SwiftUI
import AVFoundation

class Players: ObservableObject {
    // CardView에서 음악 멈추기 위한 배열
    @Published var players: [AVPlayer] = []
    
    func makePlayers(filteredData: [Memory]) {
        self.players = filteredData.map{ AVPlayer(url: URL(string: $0.voice)!) }
    }
}
