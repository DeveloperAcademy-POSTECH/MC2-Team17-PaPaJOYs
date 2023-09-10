//
//  Font+.swift
//  ForJOY
//
//  Created by Nayeon Kim on 2023/09/10.
//

import SwiftUI

extension Font {
    // 위는 영문/숫자, 아래는 한글
    static let largeTitle: Font = .system(size: 24).weight(.semibold)
    static let largeTitleKor: Font = .system(size: 24).weight(.bold)
    
    static let title1: Font = .system(size: 20).weight(.semibold)
    static let title1Kor: Font = .system(size: 20).weight(.bold)
    
    static let title2: Font = .system(size: 17).weight(.semibold)
    static let title2Kor: Font = .system(size: 17).weight(.bold)
    
    static let body1: Font = .system(size: 17)
    static let body1Kor: Font = .system(size: 17).weight(.medium)
    
    static let body2: Font = .system(size: 15)
    static let body2Kor: Font = .system(size: 15).weight(.medium)
    
    static let body3: Font = .system(size: 12)
    static let body3Kor: Font = .system(size: 12).weight(.medium)
}
