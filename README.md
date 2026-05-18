<!-- markdownlint-disable MD012 -->

# TN-Doku-Ersteller-Portable

Portables Windows-Tool zur automatischen Erstellung von Teilnehmer-Ablagesystemen
für neue Ausbildungsgruppen der Bildungseinrichtung.

## Version

3.0.1 (Build: 18.05.2026)

## Funktionen

- **Ordnerstruktur anlegen** – erzeugt je Teilnehmer einen eigenen Ordner
  (`Name - Maßnahmekürzel`) unterhalb eines Jahrgangsordners.
- **Ablagestruktur kopieren** – überträgt vordefinierte Unterordner und Vorlagen
  aus dem `_Listen`-Ordner in jeden Teilnehmerordner.
- **Excel-Dateien vorbereiten** – benennt die Musterdatei um und passt das
  Tabellenblatt (Sheet „Muster" → Teilnehmername) an; **kein installiertes Office erforderlich**.
- **Anwesenheitsliste erzeugen** – erstellt eine befüllte Word-Datei auf Basis
  der Word-Vorlage; **kein installiertes Office erforderlich**.
- **Portabel** – kein Python, keine Installation nötig (Windows 10/11, 64-bit).

## Voraussetzungen

- Windows 10 oder 11 (64-bit)
- Microsoft Office ist **nicht** erforderlich

## Quickstart

1. ZIP-Archiv entpacken.
2. `_Listen`-Ordner mit den aktuellen Vorlagen befüllen (sofern nicht bereits enthalten).
3. `Teilnehmer_Beginn.CSV` mit den Teilnehmerdaten der neuen Gruppe befüllen.
4. `TN-Doku-Ersteller-Portable.exe` starten.
5. CSV-Datei und Ausgabe-Ordner prüfen (werden automatisch vorausgefüllt).
6. Auf **„Dokumentation erstellen"** klicken.
7. Den neu erstellten `Jahrgang XXXX`-Ordner ins entsprechende Ablagesystem verschieben.

**Erste Schritte:** Siehe [docs/INSTALLATION.md](docs/INSTALLATION.md) oder [docs/ANWENDERDOKUMENTATION.md](docs/ANWENDERDOKUMENTATION.md)

## CSV-Format

Die Datei `Teilnehmer_Beginn.CSV` muss semikolongetrennt sein und mindestens diese drei Spalten enthalten:

| Spalte           | Beschreibung                | Beispiel        |
| ---------------- | --------------------------- | --------------- |
| `Name`           | Nachname, Vorname           | `Müller, Klaus` |
| `Maßnahme`       | Vollständiger Maßnahme-Name | `KBM 2601`      |
| `Maßnahmekürzel` | Kürzel der Maßnahme         | `KBM`           |

Die letzten vier Zeichen von `Maßnahme` werden als Jahrgangs-Suffix verwendet
(z. B. `2601` → `Jahrgang 2601`).

## Dokumentation

Umfangreiche Dokumentation im Ordner `docs/`:

- [docs/README.md](docs/README.md): Dokumentations-Index & Übersicht
- [docs/ANWENDERDOKUMENTATION.md](docs/ANWENDERDOKUMENTATION.md): Schritt-für-Schritt Bedienung
- [docs/INSTALLATION.md](docs/INSTALLATION.md): Installation und Vorbereitung
- [docs/FAQ.md](docs/FAQ.md): Häufig gestellte Fragen und Troubleshooting
- [docs/TECHNISCHE_DOKUMENTATION.md](docs/TECHNISCHE_DOKUMENTATION.md): Architektur und Build-System
- [docs/CHANGELOG.md](docs/CHANGELOG.md): Versionsgeschichte und Release-Notes

## Projektstruktur (Quellcode)

```text
TN-Doku-Ersteller-Portable/
├── src/
│   ├── main.py
│   ├── core.py
│   ├── csv_reader.py
│   └── build_info.py
├── docs/
│   ├── README.md
│   ├── ANWENDERDOKUMENTATION.md
│   ├── INSTALLATION.md
│   ├── FAQ.md
│   ├── TECHNISCHE_DOKUMENTATION.md
│   └── CHANGELOG.md
├── _Listen/
├── build.ps1
├── TN-Doku-Ersteller-Portable.spec
├── requirements.txt
└── setup.ps1
```

## Entwicklung & Build

```powershell
# Einmalig: Virtuelle Umgebung anlegen und Pakete installieren
.\setup.ps1

# Anwendung direkt starten (Entwicklungsmodus)
.\.venv\Scripts\python.exe src/main.py

# EXE und ZIP erstellen
.\build.ps1

# Ohne Versionserhöhung (z. B. nur für Tests)
.\build.ps1 -NoVersionBump

# Nur EXE, kein ZIP
.\build.ps1 -SkipZip
```

## Changelog

Siehe [docs/CHANGELOG.md](docs/CHANGELOG.md) für die vollständige Versionsgeschichte.

## Support & Links

- **GitHub Repository:** [https://github.com/TomGorontzy/TN-Doku-Ersteller-Portable](https://github.com/TomGorontzy/TN-Doku-Ersteller-Portable)
- **Issues & Feedback:** [https://github.com/TomGorontzy/TN-Doku-Ersteller-Portable/issues](https://github.com/TomGorontzy/TN-Doku-Ersteller-Portable/issues)
- **Lizenz:** [LICENSE](LICENSE)
- **Dokumentation:** [docs/README.md](docs/README.md)








