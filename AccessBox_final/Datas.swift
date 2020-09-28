//
//  Datas.swift
//  AccessBox_final
//
//  Created by 本山武文 on 2020/09/28.
//

import Foundation
import Combine

class UserData: ObservableObject {
    @Published var password: String? {
        didSet {
            UserDefaults.standard.set(password, forKey: "password")
        }
    }
    @Published var passIsActive: Bool {
        didSet {
            UserDefaults.standard.set(passIsActive, forKey: "passIsActive")
        }
    }
    @Published var faceIDIsActive: Bool {
        didSet {
            UserDefaults.standard.set(faceIDIsActive, forKey: "faceIDIsActive")
        }
    }
    @Published var isFirstLaunch: Bool {
        didSet {
            UserDefaults.standard.set(isFirstLaunch, forKey: "isFirstLaunch")
        }
    }
    init() {
        self.password = UserDefaults.standard.string(forKey: "password")
        self.passIsActive = UserDefaults.standard.bool(forKey: "passIsActive")
        self.faceIDIsActive = UserDefaults.standard.bool(forKey: "faceIDIsActive")
        self.isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
    }
}

class SystemState: ObservableObject {
    @Published var isUnlocked: Bool = false
    @Published var isSystem: Bool = false
    @Published var pass1: String = ""
    @Published var pass2: String = ""
}
