//
//  Test.swift
//  ForJOY
//
//  Created by Nayeon Kim on 2023/08/12.
//

import SwiftUI

struct TestView: View {
    @State private var memories: [Memories] = []
    
    var body: some View {
        List {
            ForEach(memories, id: \.self) { memory in
                MemoryRowView(memory: memory)
            }
        }
        .onAppear {
            memories = CoreDataManager.coreDM.readAllMemories()
        }
    }
}

struct MemoryRowView: View {
    let memory: Memories
    
    var body: some View {
        VStack {
            Text("\(memory.title!)")
            Text("\(memory.tag!)")
            HStack {
                Button("Update") {
                    CoreDataManager.coreDM.updateMemory(memory.objectID, "Updated", "Updated", Date())
                }
                
                Spacer()
                
                Button("Delete") {
                    CoreDataManager.coreDM.deleteMemory(memory.objectID)
                }
            }
        }
    }
}

