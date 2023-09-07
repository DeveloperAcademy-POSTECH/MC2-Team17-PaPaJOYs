//
//  CoreDataManager.swift
//  ForJOY
//
//  Created by Nayeon Kim on 2023/08/06.
//

import Foundation
import CoreData

class CoreDataManager: ObservableObject {
    static let coreDM = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "DataModel")
        persistentContainer.loadPersistentStores {(description, error) in
            if let error = error {
                fatalError("Core Data Store failed \(error.localizedDescription)")
            }
        }
    }
    
    // 데이터 모델에서 <Memories> 데이터 다 가져오기
    func readAllMemories() -> [Memories] {
        let fetchRequest: NSFetchRequest<Memories> = Memories.fetchRequest()
        let viewContext = persistentContainer.viewContext
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    // <Memories>에서 tag 값만 따로 모으기
    func getUniqueTags() -> [String] {
        let memories = readAllMemories()
        let distinctTags = Set(memories.compactMap { $0.tag })
        let uniqueTags = Array(distinctTags)
        
        return uniqueTags
    }
    
    // <Memories> 데이터 연도 기준으로 정리하기
    func getYearlyMemories() -> [Int: [Memory]] {
        let memories = readAllMemories()
        let yearlyMemories = Dictionary(grouping: memories.map { memory -> Memory in
            return Memory(objectID: memory.objectID ,title: memory.title ?? "", year: Int(memory.year), date: memory.date ?? Date(), tag: memory.tag ?? "", image: memory.image ?? "", voice: memory.voice ?? "")
        }) { memory -> Int in
            return Int(memory.year)
        }
        return yearlyMemories
    }
    
    // <Memories>에 데이터 추가하기
    func addMemory(_ title: String, _ year: Int16, _ date: Date, _ tag: String, _ image: String, _ voice: String) {
        let memory = Memories(context: persistentContainer.viewContext)
        
        memory.title = title
        memory.year = year
        memory.date = date
        memory.tag = tag
        memory.image = image
        memory.voice = voice
        
        saveContext()
    }
    
    // <Memories>에서 특정 데이터 값 수정하기
    func updateMemory(_ id: NSManagedObjectID, _ newTitle: String, _ newTag: String, _ newDate: Date) {
        let newYear = Int16(newDate.toString(dateFormat: "yyyy"))!
        let viewContext = persistentContainer.viewContext
        
        if let data = try? viewContext.existingObject(with: id) as? Memories {
            data.title = newTitle
            data.tag = newTag
            data.date = newDate
            data.year = newYear
            
            saveContext()
        }
    }
    
    // <Memories>에서 특정 데이터 삭제하기
    func deleteMemory(_ id: NSManagedObjectID) {
        let viewContext = persistentContainer.viewContext
        if let data = try? viewContext.existingObject(with: id) as? Memories {
            persistentContainer.viewContext.delete(data)
            saveContext()
        }
    }
    
    // 데이터 모델에 발생한 변화 저장하기
    func saveContext() {
        let viewContext = persistentContainer.viewContext
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
