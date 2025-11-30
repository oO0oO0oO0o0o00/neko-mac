//
//  SettingsViewModel.swift
//  Neko
//
//  Created by MeowCat on 2025/1/28.
//

import Foundation
import ServiceManagement

enum AutostartErrorKind {
    case register, unregister
}

public let kAutostartKey = "autostart"

@Observable
class SettingsViewModel {
    private var catSettings: CatSettings
    
    var easterEggClickCount = 0
    
    var autoStart: Bool = false {
        didSet {
            autostartError = nil
            UserDefaults.standard.set(autoStart, forKey: kAutostartKey)
            if autoStart {
                do {
                    try SMAppService.mainApp.register()
                } catch let error as NSError {
                    if error.code != kSMErrorAlreadyRegistered {
                        autostartError = .register
                        debugPrint("Cannot register autostart: \(error)")
                    }
                }
            } else {
                do {
                    try SMAppService.mainApp.unregister()
                } catch let error as NSError {
                    if error.code != kSMErrorJobNotFound {
                        autostartError = .unregister
                        debugPrint("Cannot unregister autostart: \(error)")
                    }
                }
            }
        }
    }
    
    var autostartError: AutostartErrorKind?
    
    var onLayoutChanged: () -> Void
    
    init(
        _ catSettings: CatSettings,
        onLayoutChanged: @escaping () -> Void
    ) {
        self.catSettings = catSettings
        self.onLayoutChanged = onLayoutChanged
        if UserDefaults.standard.bool(forKey: kAutostartKey) {
            autoStart = true
        }
    }
    
    var transparencyRadius: Int32 {
        get { catSettings.transparencyRadius }
        set {
            catSettings.transparencyRadius = newValue
            catSettings = catSettings
        }
    }
    
    var centerTransparency: Int32 {
        get { catSettings.centerTransparency }
        set {
            catSettings.centerTransparency = newValue
            catSettings = catSettings
        }
    }
    
    var numCats: Int32 {
        get { catSettings.numCats }
        set {
            catSettings.numCats = newValue
            catSettings = catSettings
            onLayoutChanged()
        }
    }
    
    func finish() -> CatSettings {
        return self.catSettings
    }
}
