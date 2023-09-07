//
//  Memory.swift
//  ForJOY
//
//  Created by hyebin on 2023/05/14.
//

import Foundation
import CoreData

// 기본 데이터 구조
class Memory: ObservableObject {
    @Published var objectID = NSManagedObjectID()
    @Published var title: String = ""
    @Published var year: Int
    @Published var date = Date()
    @Published var tag: String = ""
    @Published var image: String = ""
    @Published var voice: String = ""
    
    init(objectID: NSManagedObjectID, title: String, year: Int, date: Date, tag: String, image: String, voice: String) {
        self.objectID = objectID
        self.title = title
        self.year = year
        self.date = date
        self.tag = tag
        self.image = image
        self.voice = voice
    }
}
