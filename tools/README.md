# Tools

Dieser Ordner enthält Hilfsskripte für Wartung und Qualitätsprüfungen im Projekt.

## Enthaltene Skripte

### `check-doc-naming-uppercase.ps1`

Prüft im Workspace, ob dokumentationsähnliche Dateien in `docs/` konsistent in **GROSSBUCHSTABEN** benannt sind und ob keine alten gemischten Doku-Referenzen mehr verwendet werden.

#### Was wird geprüft?

1. **Dateinamen in `docs/`**
   - Relevante Doku-Dateien (`.md`, `.txt`, `.rst`) mit typischen Namensstämmen wie z. B. `doku`, `dokumentation`, `readme`, `liesmich`, `anleitung`, `checkliste`.
   - Diese Dateien müssen (Dateiname ohne Endung) vollständig in Großbuchstaben sein.

2. **Legacy-Referenzen in Textdateien**
   - Sucht im Projekt nach veralteten Referenzen wie:
     - `docs/Liesmich.txt`
     - `docs\\Liesmich.txt`
     - `docs/Dokumentation_Anwender.md`
     - `docs/Dokumentation_Technik.md`
     - `docs/Dokumentation_Checkliste.md`

#### Ignorierte Pfade

Für die Referenzsuche werden typische Build-/Umgebungsordner ignoriert:

- `.venv`
- `dist`
- `build`
- `release`
- `.git`
- `node_modules`

## Aufruf

### Standard (Workspace automatisch aus `tools/..`)

```powershell
.\tools\check-doc-naming-uppercase.ps1
```

### Mit explizitem Workspace

```powershell
.\tools\check-doc-naming-uppercase.ps1 -WorkspaceRoot "D:\Pfad\zum\Workspace"
```

### Backups mitprüfen

```powershell
.\tools\check-doc-naming-uppercase.ps1 -IncludeBackups
```

## Parameter

- `-WorkspaceRoot <string>`
  - Optional. Root-Verzeichnis mit Projektordnern.
  - Wenn nicht gesetzt, wird automatisch der Ordner über `tools/` verwendet.

- `-IncludeBackups`
  - Optionaler Switch.
  - Standardmäßig wird ein Ordner `_Backups` von der Prüfung ausgeschlossen.
  - Mit diesem Schalter wird `_Backups` einbezogen.

## Rückgabecodes (Exit Codes)

- `0` → Prüfung erfolgreich, keine Verstöße
- `1` → Verstöße gefunden (Naming oder Legacy-Referenzen)
- `2` → Ungültiger/fehlender `WorkspaceRoot`

## Typischer Einsatz

- Vor Releases zur Sicherung konsistenter Doku-Dateinamen
- In CI/CD-Pipelines als Qualitäts-Gate
- Nach Refactorings von Doku-Dateien und -Pfade
