//
//  RealmManger.swift
//  ForJOY
//
//  Created by hyebin on 2023/05/14.
//

import Foundation
import RealmSwift

class RealmManger: ObservableObject{
    private(set) var localRealm: Realm?
    @Published private var memories: [Memory] = []
    @Published var yearlyMemories = [Int: [Memory]]()
    @Published var yearlyTagMemories = [Int: [Memory]]()
    @Published var uniqueTags = [String]()
    
    init() {
        openRealm()
        getYearlyMemories()
    }
    
    func openRealm() {
        do{
            let config = Realm.Configuration(schemaVersion: 1)
            Realm.Configuration.defaultConfiguration = config
            localRealm = try Realm()
        } catch {
            print("Error opening Realm: \(error)")
        }
    }
    
    func getYearlyMemories() {
        if let localRealm = localRealm {
            let allMemories  = localRealm.objects(Memory.self).sorted(byKeyPath: "date", ascending: false)
            
            uniqueTags = Array(Set(allMemories.value(forKey: "tag") as! [String]))
            
            memories = []
            allMemories.forEach{ memory in
                memories.append(memory)
                yearlyMemories[memory.year, default: []].append(memory)
            }
        }
    }
    
    func getYearlyTagMemories(_ tag: String){
        if let localRealm = localRealm {
            let allMemories  = localRealm
                                    .objects(Memory.self)
                                    .sorted(byKeyPath: "date", ascending: false)
                                    .filter( "tag CONTAINS[c] %@", tag )
            
            allMemories.forEach{ memory in
                yearlyTagMemories[memory.year, default: []].append(memory)
            }
        }
    }
    
    func addMemories(_ memory: Memory) {
        if let localRealm = localRealm {
            do{
                try localRealm.write {
                    localRealm.add(memory)
                    getYearlyMemories()
                }
            }catch {
                print("Error adding Realm: \(error)")
            }
        }
    }
}
