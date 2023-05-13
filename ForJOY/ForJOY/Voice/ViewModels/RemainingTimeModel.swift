//
//  RemainingTimeModel.swift
//  ForJOY
//
//  Created by 조호식 on 2023/05/11.
//

import Foundation

class RemainingTimeModel : ObservableObject {
    @Published var remainingTime : TimeInterval = 10.0
    
    func timeString(from time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
}
