//
//  Memory.swift
//  ForJOY
//
//  Created by hyebin on 2023/05/14.
//

import Foundation
import RealmSwift

class Memory: ObservableObject {
    @Published var title: String = ""
    @Published var year: Int
    @Published var date = Date()
    @Published var tag: String = ""
    @Published var image: String = ""
    @Published var voice: String = ""
    
    init(title: String, year: Int, date: Date, tag: String, image: String, voice: String) {
        self.title = title
        self.year = year
        self.date = date
        self.tag = tag
        self.image = image
        self.voice = voice
    }
}
