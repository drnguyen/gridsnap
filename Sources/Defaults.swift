import Cocoa
import Carbon

// grid, gap, hotkey (keyCode/keyMods/keyLabel, default ⌃⌥D), target rule, what the panel shows (showHeader, showList, showMarks), its theme
// (theme: a built-in name or a file name; appearance: 0 match system, 1 light, 2 dark) and presets live in UserDefaults.
// So does grace, the seconds a drag keeps its selection after leaving the panel; it has no control in Settings.
let defaultPresets = [
    Preset(name: "Full screen", x: 0, y: 0, w: 1, h: 1, keyCode: kVK_ANSI_F, keyMods: optionKey | controlKey, keyLabel: "⌃⌥F"),
    Preset(name: "Left half", x: 0, y: 0, w: 0.5, h: 1, keyCode: kVK_ANSI_L, keyMods: optionKey | controlKey, keyLabel: "⌃⌥L"),
    Preset(name: "Right half", x: 0.5, y: 0, w: 0.5, h: 1, keyCode: kVK_ANSI_R, keyMods: optionKey | controlKey, keyLabel: "⌃⌥R"),
    Preset(name: "Centre", x: 1.0 / 6, y: 0.125, w: 2.0 / 3, h: 0.75, keyCode: kVK_ANSI_C, keyMods: optionKey | controlKey, keyLabel: "⌃⌥C"),
]
let defaults: UserDefaults = {
    let d = UserDefaults.standard
    if !d.bool(forKey: "seeded") {   // once: a list that is empty or holds only Full screen gains the other defaults
        d.set(true, forKey: "seeded")
        if let old = d.data(forKey: "presets").flatMap({ try? JSONDecoder().decode([Preset].self, from: $0) }),
           old.isEmpty || old.count == 1 && old[0].rect == defaultPresets[0].rect {
            d.set(try! JSONEncoder().encode(old + defaultPresets.dropFirst(old.count)), forKey: "presets")
        }
    }
    d.register(defaults: ["cols": 12, "rows": 8, "gap": 0, "showHeader": true, "showList": true, "showMarks": true, "theme": "Default", "appearance": 0, "grace": 1.0,
                          "presets": try! JSONEncoder().encode(defaultPresets)])
    return d
}()
var cols: Int { min(max(defaults.integer(forKey: "cols"), 1), 24) }
var rows: Int { min(max(defaults.integer(forKey: "rows"), 1), 24) }
