<!-- markdownlint-disable MD012 MD022 MD026 MD031 MD032 MD034 MD036 MD040 MD060 -->

# Dokumentation – TN-Doku-Ersteller-Portable

Willkommen zur Dokumentation von **TN-Doku-Ersteller-Portable**!

Hier findest du alle Informationen zur Installation, Verwendung und Entwicklung der Anwendung.

---

## 📖 Dokumentations-Übersicht

### Für Endbenutzer

| Dokument | Inhalt | Zielgruppe |
|----------|--------|-----------|
| **[ANWENDERDOKUMENTATION.md](ANWENDERDOKUMENTATION.md)** | Schritt-für-Schritt Bedienung, CSV-Format, Fehlerbehandlung | Alle Nutzer |
| **[INSTALLATION.md](INSTALLATION.md)** | Systemvoraussetzungen, Installation, Vorbereitung der Daten | Neue Nutzer |
| **[FAQ.md](FAQ.md)** | Häufig gestellte Fragen, Tipps & Tricks, Troubleshooting | Alle |

### Für Entwickler

| Dokument | Inhalt | Zielgruppe |
|----------|--------|-----------|
| **[TECHNISCHE_DOKUMENTATION.md](TECHNISCHE_DOKUMENTATION.md)** | Architektur, Module, API, Build-System | Entwickler |
| **[CHANGELOG.md](CHANGELOG.md)** | Versionsgeschichte, Release-Notes, Roadmap | Alle |

---

## 🚀 Schnelleinstieg

### 1️⃣ Installation

Siehe [INSTALLATION.md](INSTALLATION.md) für:
- Systemvoraussetzungen
- Download & Setup
- Vorbereitung der Daten (_Listen, CSV)

**Kurzversion:**
```
1. ZIP entpacken
2. TN-Doku-Ersteller-Portable.exe starten
3. CSV und Ordner auswählen
4. „Dokumentation erstellen" klicken
```

### 2️⃣ Erste Schritte

Siehe [ANWENDERDOKUMENTATION.md](ANWENDERDOKUMENTATION.md) für:
- Grundlegende Bedienung
- CSV-Format
- Ergebnis-Struktur
- Häufige Aufgaben

### 3️⃣ Probleme lösen

Siehe [FAQ.md](FAQ.md) für:
- Häufig gestellte Fragen
- Fehlerbehandlung
- Tipps & Tricks

---

## 💻 Technische Informationen

### Architektur

**5-Schritte-Pipeline:**
1. Ordnerstruktur anlegen
2. Ablagestruktur kopieren
3. Excel-Dateien umbenennen
4. Tabellenblätter umbenennen
5. Anwesenheitsliste erzeugen

**Komponenten:**
- `main.py` – GUI (Tkinter)
- `core.py` – Kernlogik
- `csv_reader.py` – CSV-Import
- `build_info.py` – Versionierung

Siehe [TECHNISCHE_DOKUMENTATION.md](TECHNISCHE_DOKUMENTATION.md) für vollständige Dokumentation.

### Build & Deployment

```powershell
# Setup (einmalig)
.\setup.ps1

# Starten (Entwicklungsmodus)
.\.venv\Scripts\python.exe src/main.py

# Build (EXE + ZIP)
.\build.ps1
```

Siehe [TECHNISCHE_DOKUMENTATION.md](TECHNISCHE_DOKUMENTATION.md#build-system) für Details.

---

## 📝 Versionsgeschichte

**Aktuelle Version:** 3.0.1 (18.05.2026)

Siehe [CHANGELOG.md](CHANGELOG.md) für:
- Detaillierte Release-Notes
- Bugfixes und Features pro Version
- Geplante Verbesserungen

**Highlights der aktuellen Version (3.0.1):**
- Doku-Buttons in der GUI für Anwender- und Technik-Dokumentation ergänzt
- CSV-Vorschaufenster in der GUI kompakter gestaltet
- Build/Release abgesichert: `docs/` wird verpflichtend mitkopiert, validiert und mitgezippt

---

## ❓ Häufig gestellte Fragen

**Brauche ich Microsoft Office?**
Nein! Die Anwendung funktioniert ohne Office-Installation.

**Läuft die Anwendung auf macOS/Linux?**
Momentan nur Windows. Ein Cross-Platform-Port ist geplant.

**Wo berichte ich Bugs?**
GitHub Issues: [https://github.com/TomGorontzy/TN-Doku-Ersteller-Portable/issues](https://github.com/TomGorontzy/TN-Doku-Ersteller-Portable/issues)

**Kann ich das Projekt ändern und verwenden?**
Ja! Der Code ist Open Source. Siehe [LICENSE](../LICENSE).

Weitere Fragen? Siehe [FAQ.md](FAQ.md).

---

## 🔗 Externe Links

- **GitHub Repository:** [https://github.com/TomGorontzy/TN-Doku-Ersteller-Portable](https://github.com/TomGorontzy/TN-Doku-Ersteller-Portable)
- **Issue Tracker:** [https://github.com/TomGorontzy/TN-Doku-Ersteller-Portable/issues](https://github.com/TomGorontzy/TN-Doku-Ersteller-Portable/issues)
- **Lizenz:** [LICENSE](../LICENSE)
- **README (Projekt-Wurzel):** [../README.md](../README.md)

---

## 📧 Support & Kontakt

- **GitHub Issues:** [https://github.com/TomGorontzy/TN-Doku-Ersteller-Portable/issues](https://github.com/TomGorontzy/TN-Doku-Ersteller-Portable/issues)
- **FAQ:** [FAQ.md](FAQ.md)
- **Dokumentation:** Diese Seite

---

## 📋 Dokumentations-Struktur

```
docs/
├── README.md                    ← Du bist hier
├── ANWENDERDOKUMENTATION.md      ← Für Nutzer
├── INSTALLATION.md              ← Setup & Konfiguration
├── FAQ.md                        ← Häufige Fragen
├── TECHNISCHE_DOKUMENTATION.md   ← Für Entwickler
└── CHANGELOG.md                 ← Versionsgeschichte
```

---

## 🎯 Nächste Schritte

1. **Neue Nutzer:** Starten Sie mit [INSTALLATION.md](INSTALLATION.md)
2. **Erste Verwendung:** Lesen Sie [ANWENDERDOKUMENTATION.md](ANWENDERDOKUMENTATION.md)
3. **Probleme:** Schauen Sie in [FAQ.md](FAQ.md)
4. **Entwickler:** Siehe [TECHNISCHE_DOKUMENTATION.md](TECHNISCHE_DOKUMENTATION.md)

---

Viel Spaß mit **TN-Doku-Ersteller-Portable**! 🎉

