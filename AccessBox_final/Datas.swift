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
    @Published var passIsNotActive: Bool {
        didSet {
            UserDefaults.standard.set(passIsNotActive, forKey: "passIsActive")
        }
    }
    @Published var faceIDIsActive: Bool {
        didSet {
            UserDefaults.standard.set(faceIDIsActive, forKey: "faceIDIsActive")
        }
    }
    @Published var isNotFirstLaunch: Bool {
        didSet {
            UserDefaults.standard.set(isNotFirstLaunch, forKey: "isFirstLaunch")
        }
    }
    init() {
        self.password = UserDefaults.standard.string(forKey: "password")
        self.passIsNotActive = UserDefaults.standard.bool(forKey: "passIsNotActive")
        self.faceIDIsActive = UserDefaults.standard.bool(forKey: "faceIDIsActive")
        self.isNotFirstLaunch = UserDefaults.standard.bool(forKey: "isNotFirstLaunch")
    }
}

class SystemState: ObservableObject {
    @Published var isUnlocked: Bool = false
    @Published var isSystem: Bool = false
    @Published var pass1: String = ""
    @Published var pass2: String = ""
}
