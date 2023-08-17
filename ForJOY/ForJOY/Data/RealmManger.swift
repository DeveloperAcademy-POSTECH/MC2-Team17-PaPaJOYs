//
//  RealmManger.swift
//  ForJOY
//
//  Created by hyebin on 2023/05/14.
//

import Foundation
import RealmSwift

// Realm 데이터베이스 관리를 위한 클래스
class RealmManger: ObservableObject{
    
    // Realm 데이터베이스 인스턴스
    private(set) var localRealm: Realm?
    
    // 모든 Memory 객체를 담기 위한 배열
    @Published private var memories: [Memory] = []
    
    // 연도별로 분류된 Memory 객체를 담기 위한 딕셔너리
    @Published var yearlyMemories = [Int: [Memory]]()
    
    // 연도별로 분류된 특정 태그를 포함한 Memory 객체를 담기 위한 딕셔너리
    @Published var yearlyTagMemories = [Int: [Memory]]()
    
    // 모든 unique 태그를 담기 위한 배열
    @Published var uniqueTags = [String]()
    
    // 초기화 함수
    init() {
        // Realm 데이터베이스 오픈
        openRealm()
        // 연도별 Memory 객체 가져오기
        getYearlyMemories()
    }
    
    // Realm 데이터베이스 연결 설정 및 오픈
    func openRealm() {
        do{
            let config = Realm.Configuration(schemaVersion: 1)
            Realm.Configuration.defaultConfiguration = config
            localRealm = try Realm()
        } catch {
            // 오류 출력
            print("Error opening Realm: \(error)")
        }
    }
    
    // 연도별로 분류된 Memory 객체를 가져오는 함수
    func getYearlyMemories() {
        if let localRealm = localRealm {
            
            // 모든 Memory 객체를 날짜 순으로 가져옴
            let allMemories  = localRealm.objects(Memory.self).sorted(byKeyPath: "date", ascending: false)
            
            // 모든 unique 태그를 가져옴
            uniqueTags = Array(Set(allMemories.value(forKey: "tag") as! [String]))
            
            memories = []
            allMemories.forEach{ memory in
                // 모든 Memory 객체를 배열에 추가
                memories.append(memory)
                // 연도별로 분류하여 딕셔너리에 추가
                yearlyMemories[memory.year, default: []].append(memory)
            }
        }
    }
    
    // 특정 태그를 포함하는 연도별로 분류된 Memory 객체를 가져오는 함수
    func getYearlyTagMemories(_ tag: String){
        if let localRealm = localRealm {
            
            // 특정 태그를 포함하는 모든 Memory 객체를 날짜 순으로 가져옴
            let allMemories  = localRealm
                                    .objects(Memory.self)
                                    .sorted(byKeyPath: "date", ascending: false)
                                    .filter( "tag CONTAINS[c] %@", tag )
            
            allMemories.forEach{ memory in
                // 연도별로 분류하여 딕셔너리에 추가
                yearlyTagMemories[memory.year, default: []].append(memory)
            }
        }
    }
    
    // Memory 객체를 추가하는 함수
    func addMemories(_ memory: Memory) {
        if let localRealm = localRealm {
            do{
                // Realm 데이터베이스에 새로운 Memory 객체 추가
                try localRealm.write {
                    localRealm.add(memory)
                    // 연도별 Memory 객체를 다시 가져옴
                    getYearlyMemories()
                }
            }catch {
                // 오류 출력
                print("Error adding Realm: \(error)")
            }
        }
    }
}
