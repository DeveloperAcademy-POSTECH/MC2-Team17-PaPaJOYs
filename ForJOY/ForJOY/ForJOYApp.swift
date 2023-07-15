//
//  ForJOYApp.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/05/02.
//

// 2023/06/19 dev 브랜치 생성

import SwiftUI
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "DataModel")
        
        container.loadPersistentStores { (storedDescription, error) in
            if let error = error as NSError? {
                fatalError("Container laod failed: \(error)")
            }
        }
    }
    
    func saveContext() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

//TODO: 온보딩 끝나고 필요한 권한 받기
@main
struct ForJOYApp: App {
    @State var linkActive = false
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                NavigationLink(destination: SelectYearView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .navigationBarBackButtonHidden(),
                               isActive: $linkActive) {
                    EmptyView()
                }
                SelectYearView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .background(Color("JoyDarkG"))
            }
            .accentColor(Color("JoyWhite"))
            .onOpenURL { url in
                guard url.scheme == "forjoy" else { return }
                linkActive = true
            }
        }
    }
}

