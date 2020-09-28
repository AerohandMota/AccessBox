//
//  AccessBox_finalApp.swift
//  AccessBox_final
//
//  Created by 本山武文 on 2020/09/27.
//

import SwiftUI

@main
struct AccessBox_finalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(SystemState())
                .environmentObject(UserData())
        }
    }
}
