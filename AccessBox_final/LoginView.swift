//
//  LoginView.swift
//  AccessBox_final
//
//  Created by 本山武文 on 2020/09/28.
//

import SwiftUI

struct LoginView: View {
    @State var exeStatus: ExeStatus
    @State var counter: Int = 0
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var systemState: SystemState

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack {
                Text(exeStatus.rawValue)
                KeyView(counter: $counter)
                Spacer()
                HStack {
                    ButtonView(exeStatus: $exeStatus, counter: $counter, buttonNum: 1)
                    ButtonView(exeStatus: $exeStatus, counter: $counter, buttonNum: 2)
                    ButtonView(exeStatus: $exeStatus, counter: $counter, buttonNum: 3)
                }
                HStack {
                    ButtonView(exeStatus: $exeStatus, counter: $counter, buttonNum: 4)
                    ButtonView(exeStatus: $exeStatus, counter: $counter, buttonNum: 5)
                    ButtonView(exeStatus: $exeStatus, counter: $counter, buttonNum: 6)
                }
                HStack {
                    ButtonView(exeStatus: $exeStatus, counter: $counter, buttonNum: 7)
                    ButtonView(exeStatus: $exeStatus, counter: $counter, buttonNum: 8)
                    ButtonView(exeStatus: $exeStatus, counter: $counter, buttonNum: 9)
                }
                HStack {
                    ButtonView(exeStatus: $exeStatus, counter: $counter, buttonNum: 0)
                    ButtonView(exeStatus: $exeStatus, counter: $counter, buttonNum: 10)
                }
            }
            .padding(.bottom, 100)
        }
    }
}

struct ButtonView: View {
    @Binding var exeStatus: ExeStatus
    @Binding var counter: Int
    var buttonNum: Int
    let size = UIScreen.main.bounds.width / 3 * 0.5
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var systemState: SystemState

    func initalize(_ pass: Int = 0) {
        systemState.pass1 = ""
        counter = 0
        if pass == 2 {
            systemState.pass2 = ""
        }
    }

    var body: some View {
        if buttonNum < 10 {
            Button(action: {
                if counter < 3 {
                    counter += 1
                    switch exeStatus {
                    case .auth, .auth_first:
                        systemState.pass1 += "\(buttonNum)"
                    case .auth_second:
                        systemState.pass2 += "\(buttonNum)"
                    }
                } else if counter == 3 {
                    counter += 1
                    switch exeStatus {
                    case .auth:
                        if systemState.pass1 == userData.password {
                            systemState.isUnlocked = true
                        }
                        initalize()
                    case .auth_first:
                        exeStatus = .auth_second
                        counter = 0
                    case .auth_second:
                        if systemState.pass1 == systemState.pass2 {
                            userData.password = systemState.pass1
                            if userData.isNotFirstLaunch {
                                systemState.isSystem = false
                            } else {
                                systemState.isUnlocked = true
                                userData.isNotFirstLaunch = true
                            }
                        } else {
                            exeStatus = .auth_first
                        }
                        initalize(2)
                    }
                }
            }, label: {
                Image(systemName: "\(buttonNum).circle")
                    .resizable()
                    .font(.system(size: 16, weight: .thin, design: .default))
                    .foregroundColor(.orange)
            })
            .frame(width: size, height: size, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        } else {
            Button(action: {
                if counter > 0 {
                    counter -= 1
                    switch exeStatus {
                    case .auth, .auth_first:
                        systemState.pass1 = String(systemState.pass1.dropLast())
                    case .auth_second:
                        systemState.pass2 = String(systemState.pass2.dropLast())
                    }
                }
            }, label: {
                Image(systemName: "delete.left")
                    .resizable()
                    .font(.system(size: 16, weight: .thin, design: .default))
                    .foregroundColor(.orange)
            })
            .frame(width: size, height: size, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
    }
}

struct KeyView: View {
    @Binding var counter: Int
    var body: some View {
        HStack {
            ForEach(0..<4) { num in
                if num < counter {
                    Image(systemName: "asterisk.circle.fill")
                        .font(.system(size: 16, weight: .thin))
                        .foregroundColor(.black)
                } else {
                    Image(systemName: "asterisk.circle")
                        .font(.system(size: 16, weight: .thin))
                        .foregroundColor(.black)
                }
            }
        }
    }
}

enum ExeStatus: String {
    case auth = "パスワードを入力してください"
    case auth_first = "パスワードを設定してください"
    case auth_second = "パスワードを再入力してください"
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(exeStatus: .auth_first)
    }
}
