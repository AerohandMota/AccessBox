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
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var systemState: SystemState

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \URLData.timestamp, ascending: true)],
        animation: .default)
    private var urls: FetchedResults<URLData>

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
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { urls[$0] }.forEach(viewContext.delete)

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

    var body: some View {
        ZStack {
            VStack {
                List {
                    ForEach(urls) { url in
                        Text("\((url.tag)!)")
                    }
                    .onDelete(perform: deleteItems)
                }
                HStack {
                    #if os(iOS)
                    EditButton()
                        .padding()
                        .foregroundColor(.black)
                    #endif
                    Spacer()
                    Image(systemName: "plus")
                        .padding()
                        .foregroundColor(.black)
                }
                .frame(width: UIScreen.main.bounds.width)
            }
            if userData.isNotFirstLaunch {
                if !(systemState.isUnlocked) {
                    LoginView(exeStatus: .auth)
                }
            } else {
                LoginView(exeStatus: .auth_first)
            }
            if scenePhase != .active {
                ZStack {
                    Color.white.edgesIgnoringSafeArea(.all)
                    Image(systemName: "cube.fill")
                        .font(.system(size: 30, weight: .thin))
                        .foregroundColor(.orange)
                }
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
    }
}

struct PlusView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentation
    @State var url = ""
    @State var tag = ""
    var body: some View {
        VStack {
            TextField("url", text: $url)
            TextField("tag", text: $tag)
            Button(action: {
                let newURL = URLData(context: viewContext)
                newURL.url = self.url
                newURL.tag = self.tag
                newURL.timestamp = Date()
                do {
                    try viewContext.save()
                    self.presentation.wrappedValue.dismiss()
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }, label: {Text("Create")})
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
