//
//  TestModel.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/05/03.
//

import SwiftUI

struct TestModel: Identifiable {
    let tagName: String
    let imageName: String
    let year: String
    let idx: Int
    
    let id = UUID()
}


// idx -> 파일이름, 저장 순서 등 데이터 순서 구분 위한 것 모든..
// year -> 게시물 등록 시 날짜를 저장하므로 추후 y, m, d 모두 있는 날짜 형식으로 바뀔 수 있음

// 녹음 관련 변수는 아직 반영 X
