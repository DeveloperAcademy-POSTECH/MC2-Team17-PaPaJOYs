//
//  Tag.swift
//  ForJOY
//
//  Created by hyebin on 2023/05/14.
//

import Foundation

struct Tag: Identifiable, Codable {
    var id = UUID()
    var tagName: String
}
