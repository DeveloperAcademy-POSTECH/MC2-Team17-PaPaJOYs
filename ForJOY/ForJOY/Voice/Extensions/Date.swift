//
//  Date.swift
//  ForJOY
//
//  Created by 조호식 on 2023/05/03.
//

import Foundation

// Date 타입의 Extension으로 format에 따라 문자열로 반환하는 함수를 제공합니다.
extension Date
{
func toString(dateFormat format: String ) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
        
    }

}
