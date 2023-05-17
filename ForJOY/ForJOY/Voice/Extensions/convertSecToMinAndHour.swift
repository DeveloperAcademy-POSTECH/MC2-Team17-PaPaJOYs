//
//  convertSecToMinAndHour.swift
//  ForJOY
//
//  Created by 조호식 on 2023/05/03.
//

import Foundation

extension VoiceViewModel {
    func covertSecToMinAndHour(seconds : Int) -> String{
        let (_,m,s) = (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        let sec : String = s < 10 ? "0\(s)" : "\(s)"
        return "\(m):\(sec)"
    }
}
