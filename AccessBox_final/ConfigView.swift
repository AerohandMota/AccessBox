//
//  ConfigView.swift
//  AccessBox_final
//
//  Created by 本山武文 on 2020/09/28.
//

import SwiftUI

struct ConfigView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var systemState: SystemState
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            NavigationView {
                List {
                    Toggle("FaceID", isOn: $userData.faceIDIsActive)
                    NavigationLink("パスワードの変更", destination: LoginView(exeStatus: .auth))
                    Button(action: {
                        UIApplication.shared.open(URL(string: "https://note.com/aerohand")!,
                                                  options: [.universalLinksOnly: false],
                                                  completionHandler: {completed in
                                                        print(completed)})
                    }, label: {Text("ブログ")})
                }
                .toolbar {
                    ToolbarItem {
                        Button(action: {
                            systemState.isSystem = false
                        }, label: {
                            Text("閉じる")
                        })
                    }
                }
            }
        }
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView()
    }
}
