//
//  PlusView.swift
//  AccessBox_final
//
//  Created by 本山武文 on 2020/09/28.
//

import SwiftUI

struct PlusView: View {
    @EnvironmentObject var systemState: SystemState
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            NavigationView {
                List{
                    Button(action: {
                        UIApplication.shared.open(URL(string: "https://note.com/aerohand")!,
                                                  options: [.universalLinksOnly: false],
                                                  completionHandler: {completed in
                            print(completed)
                            systemState.isPlus = false
                        })
                    }, label: {Text(#"Safariの"共有"で追加"#)})
                    NavigationLink("手動で追加", destination: ManualPlusView())
                }
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {
                            withAnimation {
                                systemState.isPlus = false
                            }
                        }, label: {
                            Text("閉じる")
                        })
                    }
                }
            }
        }
    }
}

struct ManualPlusView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var systemState: SystemState
    @State var url = ""
    @State var tag = ""
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
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
                        systemState.isPlus = false
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                }, label: {Text("Create")})
            }
        }
    }
}

struct PlusView_Previews: PreviewProvider {
    static var previews: some View {
        PlusView()
    }
}
