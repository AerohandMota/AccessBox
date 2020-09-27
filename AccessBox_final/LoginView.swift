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

    var body: some View {
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

struct ButtonView: View {
    @Binding var exeStatus: ExeStatus
    @Binding var counter: Int
    var buttonNum: Int
    let size = UIScreen.main.bounds.width / 3 * 0.5
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var systemState: SystemState
    @State var pass1: String = ""
    @State var pass2: String = ""

    var body: some View {
        if buttonNum < 10 {
            Button(action: {
                if counter < 4 {
                    counter += 1
                    switch exeStatus {
                    case .auth, .auth_first:
                        pass1 += "\(buttonNum)"
                    case .auth_second:
                        pass2 += "\(buttonNum)"
                    }
                    if counter == 4 {
                        switch exeStatus {
                        case .auth:
                            if pass1 == userData.password {
                                systemState.isUnlocked = true
                            } else {
                                counter = 0
                                pass1 = ""
                            }
                        case .auth_first:
                            exeStatus = .auth_second
                            counter = 0
                        case .auth_second:
                            if pass1 == pass2 {
                                userData.password = pass1
                            } else {
                                counter = 0
                                pass1 = ""
                                pass2 = ""
                                exeStatus = .auth_first
                            }
                        }
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
                        pass1 = String(pass1.dropLast())
                    case .auth_second:
                        pass2 = String(pass2.dropLast())
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
