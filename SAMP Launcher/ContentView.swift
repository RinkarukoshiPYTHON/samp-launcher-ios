import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: ServerStore

    var body: some View {
        TabView {
            ServersView()
                .tabItem {
                    Label(store.text("servers"), systemImage: "server.rack")
                }
            ModsView()
                .tabItem {
                    Label(store.text("mods"), systemImage: "wrench.and.screwdriver")
                }
            SettingsView()
                .tabItem {
                    Label(store.text("settings"), systemImage: "gear")
                }
        }
    }
}

// MARK: - Servers tab

struct ServersView: View {
    @EnvironmentObject private var store: ServerStore
    @State private var searchText = ""
    @State private var showingAdd = false
    @State private var playServer: GameServer?

    private var visibleServers: [GameServer] {
        var list = store.servers
        if store.showFavoritesOnly {
            list = list.filter { $0.isFavorite }
        }
        if !searchText.isEmpty {
            list = list.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
                || $0.address.localizedCaseInsensitiveContains(searchText)
            }
        }
        return list
    }

    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField(store.text("nickname"), text: $store.nickname)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                } header: {
                    Text(store.text("nickname"))
                } footer: {
                    Text("Nickname mo ito sa server. Naka-save sa phone mo lang.")
                }

                Section {
                    if visibleServers.isEmpty {
                        Text("Walang server dito. Pindutin ang + para magdagdag.")
                            .foregroundColor(.secondary)
                    }
                    ForEach(visibleServers) { server in
                        ServerRow(server: server, onPlay: {
                            playServer = server
                        })
                    }
                    .onDelete(perform: store.deleteServer)
                } header: {
                    Text(store.text("servers"))
                } footer: {
                    // Honest: no live query in v1, so no fake numbers.
                    Text("Players / Ping: — (Hindi pa naka-query sa v1.)")
                        .foregroundColor(.secondary)
                }
            }
            .searchable(text: $searchText, prompt: store.text("search"))
            .navigationTitle("SAMP Launcher")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAdd = true }) {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel(store.text("addServer"))
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddServerView()
                    .environmentObject(store)
            }
            .sheet(item: $playServer) { server in
                PlaySheet(server: server)
            }
        }
    }
}

struct ServerRow: View {
    @EnvironmentObject private var store: ServerStore
    let server: GameServer
    let onPlay: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(server.name)
                        .font(.headline)
                    if server.isSample {
                        Text("SAMPLE")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.yellow.opacity(0.25))
                            .cornerRadius(4)
                    }
                }
                Text(server.address)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Players / Ping: —")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button(action: { store.toggleFavorite(server) }) {
                Image(systemName: server.isFavorite ? "star.fill" : "star")
                    .foregroundColor(server.isFavorite ? .yellow : .secondary)
            }
            .buttonStyle(.plain)
            Button(store.text("play"), action: onPlay)
                .buttonStyle(.borderedProminent)
        }
        .swipeActions {
            Button(role: .destructive) {
                store.deleteServer(server)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

// MARK: - Add server

struct AddServerView: View {
    @EnvironmentObject private var store: ServerStore
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var ip = ""
    @State private var portText = "7777"
    @State private var errorMessage: String?

    private var port: Int? {
        guard let value = Int(portText.trimmingCharacters(in: .whitespaces)),
              (1...65535).contains(value) else { return nil }
        return value
    }

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
        && !ip.trimmingCharacters(in: .whitespaces).isEmpty
        && port != nil
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Pangalan ng server", text: $name)
                TextField("IP address (hal. 192.168.1.10)", text: $ip)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .keyboardType(.numbersAndPunctuation)
                TextField("Port (hal. 7777)", text: $portText)
                    .keyboardType(.numberPad)
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
                Text("Walang live check sa v1. Siguraduhing tama ang IP at port bago mag-Play.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .navigationTitle(store.text("addServer"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard isValid, let port else {
                            errorMessage = "Punan ang pangalan, IP, at port (1–65535)."
                            return
                        }
                        store.addServer(
                            name: name.trimmingCharacters(in: .whitespaces),
                            ip: ip.trimmingCharacters(in: .whitespaces),
                            port: port
                        )
                        dismiss()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
}

// MARK: - Play sheet (honest: copy IP, then connect in your SA-MP client)

struct PlaySheet: View {
    @Environment(\.dismiss) private var dismiss
    let server: GameServer
    @State private var copied = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text(server.name)
                    .font(.title2)
                    .fontWeight(.bold)
                Text(server.address)
                    .font(.system(.title3, design: .monospaced))
                Button(copied ? "Nakopya na ✓" : "Kopyahin ang \(server.address)") {
                    UIPasteboard.general.string = server.address
                    copied = true
                }
                .buttonStyle(.borderedProminent)
                Divider()
                Text("Paano mag-connect (v1):")
                    .font(.headline)
                Text("1. Buksan ang naka-install mong SA-MP client sa iPhone mo (hal. ReSA, kung meron ka).\n2. Piliin ang Add Server / magdagdag ng server doon.\n3. I-paste ang \(server.address) at mag-connect.")
                Text("Hindi direktang binubuksan ng launcher na ito ang laro. Launcher shell lang ito sa v1 — walang GTA SA game na kasama, at hindi ito nagpapatakbo ng multiplayer mag-isa.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding()
            .navigationTitle("Play")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Tapos") { dismiss() }
                }
            }
        }
    }
}
