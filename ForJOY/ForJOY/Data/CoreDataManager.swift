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
    
    func readAllMemories() -> [Memories] {
        let fetchRequest: NSFetchRequest<Memories> = Memories.fetchRequest()
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func getUniqueTags() -> [String] {
        let memories = readAllMemories()
        let distinctTags = Set(memories.compactMap { $0.tag })
        let uniqueTags = Array(distinctTags)
        
        return uniqueTags
    }
        
    func getYearlyMemories() -> [Int: [Memory]] {
        let memories = readAllMemories()
        let yearlyMemories = Dictionary(grouping: memories.map { memory -> Memory in
            return Memory(objectID: memory.objectID ,title: memory.title ?? "", year: Int(memory.year), date: memory.date ?? Date(), tag: memory.tag ?? "", image: memory.image ?? "", voice: memory.voice ?? "")
        }) { memory -> Int in
            return Int(memory.year)
        }
        return yearlyMemories
    }
    
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
    
    // 상위 뷰에서 title
    // 수정하려는 뷰에서 newTitle, newTag, newDate
    func updateMemory(_ id: NSManagedObjectID, _ newTitle: String, _ newTag: String, _ newDate: Date) {
        let newYear = Int16(newDate.toString(dateFormat: "yyyy"))!
        
        if let data = try? persistentContainer.viewContext.existingObject(with: id) as? Memories {
            data.title = newTitle
            data.tag = newTag
            data.date = newDate
            data.year = newYear
            saveContext()
        }
    }
    
    func deleteMemory(_ id: NSManagedObjectID) {
        if let data = try? persistentContainer.viewContext.existingObject(with: id) as? Memories {
            persistentContainer.viewContext.delete(data)
            saveContext()
        }
    }
    
    func saveContext() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
