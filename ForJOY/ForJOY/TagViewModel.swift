//
//  TagViewModel.swift
//  ForJOY
//
//  Created by hyebin on 2023/05/14.
//

import Foundation

class TagViewModel: ObservableObject {
    @Published var tags = [String]()
    
    func addTag(_ t: Tag) {
        tags.append(t.tagName)
    }
}
