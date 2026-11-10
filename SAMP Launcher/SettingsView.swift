import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: ServerStore

    var body: some View {
        NavigationView {
            Form {
                Section(store.text("nickname")) {
                    TextField("Hal. mavs", text: $store.nickname)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                Section("Launcher") {
                    Toggle(store.text("favoritesOnly"), isOn: $store.showFavoritesOnly)
                    Picker("Wika / Language", selection: $store.language) {
                        Text("Tagalog").tag("tl")
                        Text("English").tag("en")
                    }
                    .pickerStyle(.segmented)
                    Text("Ang wika ay nagpapalit ng mga pangunahing heading (Servers / Mga Server, Mods / Mga Mod, Settings).")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                Section("About") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("SAMP Launcher v1.0 (1)")
                            .font(.headline)
                        Text("v1 launcher shell lang ito — hindi ito GTA SA game, hindi pa ito direktang nagbubukas ng multiplayer.")
                        Text("Hindi ito kasama ang GTA SA game files, at hindi ito kopya ng ReSA Multiplayer. Ang Play button ay kumokopya lang ng IP:port — ikaw pa rin ang magko-connect sa sarili mong SA-MP client.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Text("Walang pekeng player count o ping sa v1. Kung hindi pa naka-query, “—” ang ipinapakita.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle(store.text("settings"))
        }
    }
}
