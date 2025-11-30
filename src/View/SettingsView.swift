//
//  SettingsView.swift
//  Neko
//
//  Created by MeowCat on 2025/1/5.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @State
    private var settings: SettingsViewModel
    
    @Environment(\.dismiss)
    private var dismiss
    
    init(
        settings: CatSettings,
        onLayoutChanged: @escaping () -> Void
    ) {
        self.settings = SettingsViewModel(
                settings, onLayoutChanged: onLayoutChanged)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            let itemsSpacing: CGFloat = 8
            Text("Number of Cats 🐱")
            EnterableSlider(
                value: .convert($settings.numCats),
                range: 1...8,
                step: 1)
            Spacer(minLength: itemsSpacing)
            Text("Transparency Radius")
            EnterableSlider(
                value: .convert($settings.transparencyRadius),
                range: 0...400)
            Spacer(minLength: itemsSpacing)
            Text("Center Transparency")
            EnterableSlider(
                value: .convert($settings.centerTransparency),
                range: 0...100)
            Spacer(minLength: itemsSpacing)
            Toggle(isOn: $settings.autoStart) {
                Text("Start on login")
            }
            if let error = settings.autostartError {
                switch error {
                case .register:
                    Text("""
        Cannot register to start on login.
        Go to System Settings → General → Login Items to add.
        """).foregroundStyle(.red)
                case .unregister:
                    Text("""
        Cannot unregister to start on login.
        """).foregroundStyle(.yellow)
                }
            }
            Spacer(minLength: 24)
            guide
            HStack {
                Spacer()
                Button("Cancel") {
                    settings.finish().load()
                    settings.onLayoutChanged()
                    dismiss()
                }.keyboardShortcut(.cancelAction)
                Button("OK") {
                    settings.finish().save()
                    settings.onLayoutChanged()
                    dismiss()
                }.keyboardShortcut(.defaultAction)
            }
        }.padding(20).frame(minWidth: 400)
    }
    
    var guide: some View {
        HStack {
            if let icon = NSImage(named: "Neko") {
                ZStack(alignment: .bottomTrailing) {
                    Image(nsImage: icon)
                        .resizable()
                        .frame(width: 32, height: 32)
                    Image(nsImage: NSCursor.current.image)
                    Image(nsImage: NSCursor.current.image)
                        .padding(EdgeInsets(
                            top: 0, leading: 0, bottom: -4, trailing: -4))
                }.onTapGesture {
                    settings.easterEggClickCount += 1
                }
            }
            Text("""
    Later on, open the opened Neko app again to enter Settings.
    \(easterEggText)
    """
            ).fixedSize(horizontal: false, vertical: true)
        }
    }
    
    var easterEggText: String {
        let baseText = """
    Double click the icon, for example in LaunchPad or Finder, not me, meow~
    """
        return switch settings.easterEggClickCount {
        case 0: ""
        case 1: baseText
        case 2: "\(baseText) Don't click me twice!"
        case 3: "There is NO developer mode..."
        case 5: "What do you expect?"
        case 9: "What the hell, for real?"
        case 12: "That is not fun, kid."
        case 16: "What are you doing?"
        case 20: "Could you just stop?"
        case 24: "?"
        case 30...40: "BUT JUST WHY?"
        case 200...499: "DOES THIS WORTH THE EFFORT?"
        case 500...550: "Should I report for abuse... of the mouse?"
        default: "..."
        }
    }
}
