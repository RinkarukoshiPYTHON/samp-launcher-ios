import SwiftUI

// MARK: - Model

struct GameServer: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var ip: String
    var port: Int
    var isFavorite: Bool = false
    var isSample: Bool = false

    var address: String { "\(ip):\(port)" }
}

// MARK: - Store (UserDefaults only, no network, no fake data)

final class ServerStore: ObservableObject {
    @Published var servers: [GameServer] {
        didSet { saveServers() }
    }
    @Published var nickname: String {
        didSet { UserDefaults.standard.set(nickname, forKey: "nickname") }
    }
    @Published var showFavoritesOnly: Bool {
        didSet { UserDefaults.standard.set(showFavoritesOnly, forKey: "showFavoritesOnly") }
    }
    /// "tl" = Tagalog, "en" = English. Changes the main headings only.
    @Published var language: String {
        didSet { UserDefaults.standard.set(language, forKey: "language") }
    }

    private let serversKey = "savedServers"
    private let seededKey = "didSeedServersV2"

    init() {
        self.nickname = UserDefaults.standard.string(forKey: "nickname") ?? "Xiz_Tues"
        self.showFavoritesOnly = UserDefaults.standard.bool(forKey: "showFavoritesOnly")
        self.language = UserDefaults.standard.string(forKey: "language") ?? "tl"

        if let data = UserDefaults.standard.data(forKey: serversKey),
           let decoded = try? JSONDecoder().decode([GameServer].self, from: data) {
            self.servers = decoded
        } else {
            self.servers = []
        }

        if !UserDefaults.standard.bool(forKey: seededKey) {
            // Preloaded from mavs's own ReSA setup (video, 2026-11-10):
            // GTA: Philippine Reality Roleplay, samp.philippine-rp.net:7777.
            // Favorite by default; the user can delete it like any server.
            self.servers = [
                GameServer(name: "GTA: Philippine Reality Roleplay", ip: "samp.philippine-rp.net", port: 7777, isFavorite: true)
            ]
            UserDefaults.standard.set(true, forKey: seededKey)
        }
    }

    private func saveServers() {
        if let data = try? JSONEncoder().encode(servers) {
            UserDefaults.standard.set(data, forKey: serversKey)
        }
    }

    func addServer(name: String, ip: String, port: Int) {
        servers.append(GameServer(name: name, ip: ip, port: port))
    }

    func deleteServer(at offsets: IndexSet) {
        servers.remove(atOffsets: offsets)
    }

    func deleteServer(_ server: GameServer) {
        servers.removeAll { $0.id == server.id }
    }

    func toggleFavorite(_ server: GameServer) {
        guard let index = servers.firstIndex(where: { $0.id == server.id }) else { return }
        servers[index].isFavorite.toggle()
    }

    // MARK: - Minimal Tagalog / English headings

    func text(_ key: String) -> String {
        let tl: [String: String] = [
            "servers": "Mga Server",
            "mods": "Mga Mod",
            "settings": "Settings",
            "search": "Hanapin ang server",
            "addServer": "Magdagdag ng Server",
            "nickname": "Nickname",
            "play": "Play",
            "favoritesOnly": "Favorites lang ang ipakita"
        ]
        let en: [String: String] = [
            "servers": "Servers",
            "mods": "Mods",
            "settings": "Settings",
            "search": "Search servers",
            "addServer": "Add Server",
            "nickname": "Nickname",
            "play": "Play",
            "favoritesOnly": "Show favorites only"
        ]
        let table = (language == "en") ? en : tl
        return table[key] ?? key
    }
}
