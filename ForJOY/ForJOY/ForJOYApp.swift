//
//  ForJOYApp.swift
//  ForJOY
//
//  Created by Chaeeun Shin on 2023/05/02.
//

// 2023/06/19 dev 브랜치 생성

import SwiftUI

@main
struct ForJOYApp: App {
    @StateObject var permissionHandler = PermissionHandler()
    @State var linkActive = false
    @State var image: UIImage? = nil
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if permissionHandler.areAllPermissionsGranted {
                    SelectYearView()
                }
            }
            .onAppear {
                permissionHandler.requestPermissions()
            }
        }
    }
}
