import SwiftUI

/// Mods tab — plain text rows only.
/// No fake download buttons: these are mavs's PC/Android GTA SA files,
/// not iPhone-installable from this launcher yet.
struct ModsView: View {
    @EnvironmentObject private var store: ServerStore

    var body: some View {
        NavigationView {
            List {
                Section {
                    Text("Ang mga mod sa ibaba ay files pa lang ni mavs. Hindi pa sila puwedeng i-install sa iPhone mula sa launcher na ito.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                Section("Mga mod ni mavs") {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("kit_sedan")
                            .font(.headline)
                        Text("Simple low-poly red sedan para sa GTA SA-MP. Status: soon / nasa files pa — hindi pa puwedeng i-install dito sa iPhone.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Bullet — 'siobe' hood edit")
                            .font(.headline)
                        Text("Detailed Bullet sports car na may 'siobe' text sa hood. Status: soon / nasa files pa — PC/Android GTA SA file ito, hindi pa puwedeng i-install dito sa iPhone.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                Section {
                    Text("Kapag may download link na, dito siya ilalagay — pero sa v1, listahan lang muna ito, walang download button na walang ginagawa.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle(store.text("mods"))
        }
    }
}
