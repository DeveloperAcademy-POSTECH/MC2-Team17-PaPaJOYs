//
//  convertSecToMinAndHour.swift
//  ForJOY
//
//  Created by 조호식 on 2023/05/03.
//

import Foundation

// VoiceViewModel 클래스에 대한 익스텐션으로, 초를 분과 시간으로 변환하는 기능을 제공하는 함수를 제공합니다.
extension VoiceViewModel {
    
    // 주어진 초를 "mm:ss" 형식의 문자열로 변환하는 함수입니다.
    func covertSecToMinAndHour(seconds : Int) -> String{
        
        // 분과 초를 계산합니다.
        let (_,m,s) = (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        
        // 초가 10보다 작으면 앞에 0을 추가합니다.
        let sec : String = s < 10 ? "0\(s)" : "\(s)"
        
        // "mm:ss" 형식으로 된 시간 문자열을 반환합니다.
        return "\(m):\(sec)"
    }
}
