//
//  Memory.swift
//  ForJOY
//
//  Created by hyebin on 2023/05/15.
//

import Foundation
import RealmSwift

class Memory: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String = ""
    @Persisted var year: Int
    @Persisted var date = Date()
    @Persisted var tag: String = ""
    @Persisted var image: Data
    @Persisted var voice: String = ""
}
