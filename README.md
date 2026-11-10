# SAMP Launcher — v1 (iOS)

Taglish, dark game-launcher style, SwiftUI, iOS 15.1+, walang external dependencies.

## Ano ito — at ano HINDI ito

**Ito ay v1 launcher shell lang.**

- Listahan ng mga server (naka-save sa phone mo lang, UserDefaults)
- Magdagdag ng server gamit ang pangalan + IP + port, may validation
- Search, favorites (star), swipe-to-delete
- Nickname na naka-save
- Play button: **kumokopya lang ng `IP:port` sa clipboard**, tapos may sheet na nagsasabi na buksan mo ang naka-install mong SA-MP client (hal. ReSA, kung meron ka) at i-paste / i-connect doon
- Mods tab: listahan lang ng mga mod ni mavs (kit_sedan, Bullet "siobe") — walang pekeng download button
- Settings: nickname, favorites-only, Tagalog/English headings, at About

**Hindi ito:**

- Hindi ito GTA SA game. Walang Rockstar game files dito.
- Hindi ito nagpapatakbo ng multiplayer mag-isa. Hindi ito kopya ng ReSA Multiplayer — ang ReSA ay sariling game engine na rebuilt from scratch, hindi yun kaya i-clone dito.
- Hindi ito direktang nagbubukas ng laro. Walang hinulaang URL scheme para mag-launch ng ibang app.
- Walang pekeng player count o ping. Kung hindi pa naka-query, `—` / "Hindi pa naka-query" ang ipinapakita.

> Sa Settings > About, nakasulat din ito sa Tagalog: "v1 launcher shell lang ito — hindi ito GTA SA game, hindi pa ito direktang nagbubukas ng multiplayer."

## Paano mabuo ang .ipa

Walang Xcode sa Linux VM kung saan ito ginawa, kaya hindi ito na-compile dito. Ang build ay sa GitHub Actions (macOS runner):

1. I-push ang repo na ito sa GitHub (hindi pa naka-push — local files lang ito sa ngayon).
2. Sa GitHub, pumunta sa **Actions > Build unsigned IPA**.
3. Kapag tapos na ang run, i-download ang artifact na **`SAMP-Launcher-ipa`** — laman nito ang `SAMP-Launcher.ipa`.

Ang workflow (`.github/workflows/build-ipa.yml`) ay nag-a-archive nang unsigned:

```sh
xcodebuild archive -scheme "SAMP Launcher" -destination "generic/platform=iOS" \
  -archivePath build/SAMP-Launcher.xcarchive \
  CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY=""
mkdir Payload && cp -r "build/SAMP-Launcher.xcarchive/Products/Applications/SAMP Launcher.app" Payload/
zip -r SAMP-Launcher.ipa Payload
```

## Paano i-install sa iPhone (sideload, unsigned IPA)

Gamitin ang IPA installer mo — hal. AltStore, Scarlet, ESign, o TrollStore. Pangkalahatang daloy lang ito; magkaiba ang bawat installer, kaya sundin ang mismong app mo:

1. I-download ang `SAMP-Launcher.ipa` mula sa GitHub Actions artifact.
2. Ilipat ito sa iPhone mo (Files, AirDrop, o sa installer app mismo).
3. Buksan ang installer mo at piliin ang IPA para i-install / i-sign.

Mga paalala (markahan ang hindi pa sigurado bilang hindi pa sigurado):

- **Unsigned IPA ito.** Kailangan itong i-sign ng installer mo bago ito ma-install.
- **AltStore (free Apple ID):** karaniwang 7 araw lang ang validity ng sideloaded app at kailangan mag-resign / mag-refresh bago mag-expire — hindi pa ito na-verify sa setup mo mismo.
- **TrollStore:** kung supported ng iOS version mo, karaniwang hindi na kailangan ng 7-day resign — pero hindi pa ito na-verify sa phone mo.
- Hindi pa ito na-test mag-install sa totoong iPhone. Kapag may error ang installer mo, i-screenshot mo ang eksaktong error at ipadala — doon tayo mag-aayos.

## Kung gusto mong mag-ambag / magbago

- App name: `SAMP Launcher`, bundle id `com.mavs.samplauncher`, version 1.0 (1)
- Target: iOS 15.1+, iPhone + iPad, SwiftUI App lifecycle, walang external dependencies
- Servers / nickname / settings: UserDefaults lang, walang server-side at walang tracking
- Naka-preload na server sa unang bukas: GTA: Philippine Reality Roleplay, puwedeng i-delete (swipe o trash)

## Hindi pa na-test

- Hindi pa na-compile (walang Xcode/macOS dito — Linux lang ang VM).
- Hindi pa na-install sa totoong iPhone.
- Naka-preload na: GTA: Philippine Reality Roleplay (`samp.philippine-rp.net:7777`, favorite) at nickname na `Xiz_Tues` — galing sa ReSA setup ni mavs (video, 2026-11-10).
