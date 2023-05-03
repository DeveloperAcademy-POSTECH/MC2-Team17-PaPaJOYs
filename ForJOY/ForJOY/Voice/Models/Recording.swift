//
//  Recording.swift
//  ForJOY
//
//  Created by 조호식 on 2023/05/03.
//

import Foundation

struct Recording : Equatable {
    
    let fileURL : URL   // 녹음 파일의 URL
    let createdAt : Date   // 녹음 파일이 생성된 시간
    var isPlaying : Bool   // 녹음 파일이 재생 중인지 여부
    
}

//위 코드는 Recording 구조체를 정의하는 코드입니다.
//
//let fileURL : URL : 녹음 파일의 URL을 저장하는 속성입니다.
//let createdAt : Date : 녹음 파일이 생성된 시간을 저장하는 속성입니다.
//var isPlaying : Bool : 녹음 파일이 재생 중인지 여부를 저장하는 속성입니다.

