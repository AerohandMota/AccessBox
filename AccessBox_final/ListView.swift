//
//  ContentView.swift
//  AccessBox_final
//
//  Created by 本山武文 on 2020/09/27.
//

import SwiftUI
import CoreData
import LocalAuthentication

struct ListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject var userData = UserData()
    @ObservedObject var systemState = SystemState()
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    private func authenticate() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            userData.faceIDIsActive = true
            let reason = "Log in to your account"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason ) { success, error in

                if success {

                    // Move to the main thread because a state update triggers UI changes.
                    systemState.isUnlocked = true

                } else {
                    print(error?.localizedDescription ?? "認証に失敗しました")

                    // Fall back to a asking for username and password.
                    // ...
                }
            }
        }
    }

    var body: some View {
        if scenePhase == .active {
            ZStack {
                List {
                    ForEach(items) { item in
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    }
                    .onDelete(perform: deleteItems)
                }
                .toolbar {
                    #if os(iOS)
                    EditButton()
                    #endif

                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                if userData.isNotFirstLaunch {
                    if !(systemState.isUnlocked) {
                        LoginView(exeStatus: .auth)
                            .environmentObject(userData)
                            .environmentObject(systemState)
                    }
                } else {
                    LoginView(exeStatus: .auth_first)
                        .environmentObject(userData)
                        .environmentObject(systemState)
                }
            }
            .onAppear(perform: {
                if userData.faceIDIsActive {
                    authenticate()
                }
            })
            .onChange(of: scenePhase) { newScenePhase in
                if newScenePhase == .background || newScenePhase == .inactive {
                    systemState.isUnlocked = false
                } else if newScenePhase == .active && systemState.isUnlocked == false {
                    if userData.faceIDIsActive {
                        authenticate()
                    }
                }
            }
        } else {
            Image(systemName: "cube.fill")
                .font(.system(size: 30, weight: .thin))
                .foregroundColor(.orange)
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(UserData())
            .environmentObject(SystemState())
    }
}
