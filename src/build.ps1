# Build-Skript für TN-Doku-Ersteller-Portable (primär in src)
# Erstellt EXE via PyInstaller und packt alles als ZIP ins release/-Verzeichnis.

param(
    [switch]$NoVersionBump,
    [switch]$SkipZip,
    [switch]$Help,
    [switch]$Quiet
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
if ($PSVersionTable.PSVersion.Major -ge 6) {
    $OutputEncoding = [System.Text.Encoding]::UTF8
}

$projectDir = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path

function Show-Usage {
    Microsoft.PowerShell.Utility\Write-Host "TN-Doku-Ersteller-Portable Build-Skript - Optionen:" -ForegroundColor DarkCyan
    Microsoft.PowerShell.Utility\Write-Host "  -Help          : Nur diese Hilfe anzeigen und beenden" -ForegroundColor DarkGray
    Microsoft.PowerShell.Utility\Write-Host "  -NoVersionBump : Versionsnummer nicht erhöhen" -ForegroundColor DarkGray
    Microsoft.PowerShell.Utility\Write-Host "  -SkipZip       : ZIP-Erstellung überspringen" -ForegroundColor DarkGray
    Microsoft.PowerShell.Utility\Write-Host "  -Quiet         : Kompakte Ausgabe (nur Fehler + Kurzfazit)" -ForegroundColor DarkGray
}

if (-not $Quiet -or $Help) { Show-Usage }
if ($Help) { exit 0 }

$script:QuietMode = $Quiet
function Write-Host {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [object[]]$Object,
        [ConsoleColor]$ForegroundColor,
        [switch]$NoNewline,
        [object]$Separator = ' '
    )
    if (-not $script:QuietMode) {
        Microsoft.PowerShell.Utility\Write-Host @PSBoundParameters
        return
    }
    $text = if ($null -eq $Object) { '' } else { ($Object -join [string]$Separator) }
    $isErrorColor = $PSBoundParameters.ContainsKey('ForegroundColor') -and $ForegroundColor -eq [ConsoleColor]::Red
    $isSummary = $text -match 'Build erfolgreich|fehlgeschlagen|^Ergebnis:|^ZIP:|^EXE:'
    if ($isErrorColor -or $isSummary) {
        Microsoft.PowerShell.Utility\Write-Host @PSBoundParameters
    }
}

# ---------------------------------------------------------------------------
# Schritt 0: Versionsnummer in build_info.py erhöhen
# ---------------------------------------------------------------------------
$buildInfoPath = Join-Path $PSScriptRoot 'build_info.py'
$newVersion = $null

if (Test-Path $buildInfoPath) {
    $content = Get-Content $buildInfoPath -Raw -Encoding UTF8
    if ($content -match "'version':\s*'([0-9]+)\.([0-9]+)\.([0-9]+)'") {
        $major = [int]$Matches[1]
        $minor = [int]$Matches[2]
        $patch = [int]$Matches[3]
        $currentVersion = "$major.$minor.$patch"

        if ($NoVersionBump) {
            $newVersion = $currentVersion
            Write-Host "Versionssprung übersprungen. Version: $newVersion" -ForegroundColor Cyan
        } else {
            $patch++
            if ($patch -ge 10) { $patch = 0; $minor++ }
            if ($minor -ge 10) { $minor = 0; $major++ }
            $newVersion = "$major.$minor.$patch"
            $newDate = (Get-Date).ToString('yyyy-MM-ddTHH:mm:ss')
            $content = $content -replace "'version':\s*'[0-9]+\.[0-9]+\.[0-9]+'", "'version': '$newVersion'"
            $content = $content -replace "'build_date':\s*'[^']+'", "'build_date': '$newDate'"
            Set-Content $buildInfoPath $content -Encoding UTF8
            Write-Host "Neue Version: $newVersion" -ForegroundColor Cyan

            # README.md: Version-Zeile aktualisieren
            $readmePath = Join-Path $projectDir 'README.md'
            if (Test-Path $readmePath) {
                $readme = Get-Content $readmePath -Raw -Encoding UTF8
                $dateForMd = (Get-Date).ToString('dd.MM.yyyy')
                $readme = [regex]::Replace(
                    $readme,
                    '\*Version: [0-9]+\.[0-9]+\.[0-9]+ \(Build: [0-9]{2}\.[0-9]{2}\.[0-9]{4}\)\*',
                    "*Version: $newVersion (Build: $dateForMd)*"
                )
                Set-Content $readmePath $readme -Encoding UTF8
                Write-Host "README.md aktualisiert." -ForegroundColor Cyan
            }

            # Weitere Docs: Versionsnummern ersetzen (currentVersion -> newVersion)
            $enc = [Text.UTF8Encoding]::new($false)
            $docFiles = @(
                'docs/DOKUMENTATION_ANWENDER.md',
                'docs/INSTALLATION.md',
                'docs/DOKUMENTATION_TECHNIK.md'
            )
            foreach ($f in $docFiles) {
                $fp = Join-Path $projectDir $f
                if (Test-Path $fp) {
                    $c = [IO.File]::ReadAllText($fp, $enc)
                    $u = $c.Replace($currentVersion, $newVersion)
                    if ($c -ne $u) {
                        [IO.File]::WriteAllText($fp, $u, $enc)
                        Write-Host "$f aktualisiert." -ForegroundColor Cyan
                    }
                }
            }
        }
    } else {
        Write-Host "Konnte Versionsnummer nicht erkennen in build_info.py!" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "src/build_info.py nicht gefunden!" -ForegroundColor Red
    exit 1
}

Write-Host "`nTN-Doku-Ersteller-Portable Build-Prozess" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

# ---------------------------------------------------------------------------
# Schritt 1: PyInstaller Build
# ---------------------------------------------------------------------------
$folderName = "TN-Doku-Ersteller-Portable-v$newVersion"
$distPath   = Join-Path $projectDir "dist\$folderName"
$oneFileExePath = Join-Path $projectDir 'dist\TN-Doku-Ersteller-Portable.exe'

# Alte Build-Artefakte ggf. entfernen
if (Test-Path $distPath) {
    Write-Host "`nEntferne alten Build-Ordner: $distPath" -ForegroundColor Yellow
    try {
        Remove-Item $distPath -Recurse -Force -ErrorAction Stop
    } catch {
        Write-Host "Konnte alten Build-Ordner nicht entfernen: $_" -ForegroundColor Red
        exit 1
    }
}
if (Test-Path $oneFileExePath) {
    Write-Host "Entferne alte Onefile-EXE: $oneFileExePath" -ForegroundColor Yellow
    try {
        Remove-Item $oneFileExePath -Force -ErrorAction Stop
    } catch {
        Write-Host "Konnte alte Onefile-EXE nicht entfernen: $_" -ForegroundColor Red
        exit 1
    }
}

Write-Host "`n1. PyInstaller Build ..." -ForegroundColor Yellow
$pyInstallerLog = Join-Path $projectDir 'build\last-pyinstaller.log'
New-Item -ItemType Directory -Path (Split-Path $pyInstallerLog -Parent) -Force | Out-Null

$specPath = Join-Path $PSScriptRoot 'TN-Doku-Ersteller-Portable.spec'
if ($Quiet) {
    & py -m PyInstaller $specPath --noconfirm *> $pyInstallerLog
} else {
    & py -m PyInstaller $specPath --noconfirm
}

if ($LASTEXITCODE -ne 0) {
    Write-Host "PyInstaller Build fehlgeschlagen!" -ForegroundColor Red
    if ($Quiet -and (Test-Path $pyInstallerLog)) {
        Write-Host "Details siehe: $pyInstallerLog" -ForegroundColor Yellow
        Get-Content $pyInstallerLog -Tail 30
    }
    exit 1
}

if (-not (Test-Path $oneFileExePath)) {
    Write-Host "Onefile-EXE wurde nicht erstellt: $oneFileExePath" -ForegroundColor Red
    exit 1
}

New-Item -ItemType Directory -Path $distPath -Force | Out-Null
Copy-Item -Path $oneFileExePath -Destination (Join-Path $distPath 'TN-Doku-Ersteller-Portable.exe') -Force

Write-Host "  EXE erstellt in: $distPath" -ForegroundColor Green

# ---------------------------------------------------------------------------
# Schritt 2: Zusätzliche Dateien in dist kopieren
# ---------------------------------------------------------------------------
Write-Host "`n2. Verteilungsdateien kopieren ..." -ForegroundColor Yellow

$dataDestRoot = Join-Path $distPath 'data'
New-Item -ItemType Directory -Path $dataDestRoot -Force | Out-Null

# Ablagesystem (Template-Ordner)
$listenSrc = Join-Path $projectDir 'data\Ablagesystem'
if (Test-Path $listenSrc) {
    $listenDest = Join-Path $distPath 'data\Ablagesystem'
    Copy-Item -Path $listenSrc -Destination $listenDest -Recurse -Force
    Write-Host "  data\\Ablagesystem kopiert." -ForegroundColor DarkGray
} else {
    Write-Host "  Hinweis: data\\Ablagesystem-Ordner nicht gefunden - wird nicht mitkopiert." -ForegroundColor Yellow
}

# Teilnehmer-CSV (Beispiel/Vorlage)
$csvSrc = Join-Path $projectDir 'data\Teilnehmer_Beginn.CSV'
if (Test-Path $csvSrc) {
    Copy-Item -Path $csvSrc -Destination (Join-Path $distPath 'data\Teilnehmer_Beginn.CSV') -Force
    Write-Host "  data\\Teilnehmer_Beginn.CSV kopiert." -ForegroundColor DarkGray
}

# Dokumentation und Lizenz
foreach ($file in @('README.md')) {
    $src = Join-Path $projectDir $file
    if (Test-Path $src) {
        Copy-Item -Path $src -Destination (Join-Path $distPath $file) -Force
        Write-Host "  $file kopiert." -ForegroundColor DarkGray
    }
}

# docs/-Ordner (für integrierte Doku-Buttons in der GUI)
$docsSrc = Join-Path $projectDir 'docs'
if (-not (Test-Path $docsSrc)) {
    Write-Host "Pflichtordner fehlt: '$docsSrc'" -ForegroundColor Red
    Write-Host "Abbruch, da Release ohne Dokumentation nicht erstellt werden soll." -ForegroundColor Red
    exit 1
}

$docsDest = Join-Path $distPath 'docs'
Copy-Item -Path $docsSrc -Destination $docsDest -Recurse -Force
Write-Host "  docs/ kopiert." -ForegroundColor DarkGray

# Pflicht-Dokumente validieren
$requiredDocs = @(
    'DOKUMENTATION_ANWENDER.md',
    'DOKUMENTATION_TECHNIK.md',
    'INSTALLATION.md'
)
foreach ($doc in $requiredDocs) {
    $docPath = Join-Path $docsDest $doc
    if (-not (Test-Path $docPath)) {
        Write-Host "Pflichtdokument fehlt im Release: '$docPath'" -ForegroundColor Red
        Write-Host "Abbruch, damit kein unvollständiges Release erzeugt wird." -ForegroundColor Red
        exit 1
    }
}
Write-Host "  docs/ validiert." -ForegroundColor DarkGray

# ---------------------------------------------------------------------------
# Schritt 3: ZIP erstellen
# ---------------------------------------------------------------------------
if (-not $SkipZip) {
    Write-Host "`n3. ZIP-Archiv erstellen ..." -ForegroundColor Yellow
    $releaseDir = Join-Path $projectDir 'release'
    New-Item -ItemType Directory -Path $releaseDir -Force | Out-Null

    $zipName = "TN-Doku-Ersteller-Portable_$newVersion.zip"
    $zipPath = Join-Path $releaseDir $zipName

    if (Test-Path $zipPath) { Remove-Item $zipPath -Force }

    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::CreateFromDirectory($distPath, $zipPath)
        $sizeMb = [math]::Round((Get-Item $zipPath).Length / 1MB, 1)
        Write-Host "ZIP: $zipName ($sizeMb MB)" -ForegroundColor Green
    } catch {
        Write-Host "ZIP-Erstellung fehlgeschlagen: $_" -ForegroundColor Red
        exit 1
    }
}

# ---------------------------------------------------------------------------
# Zusammenfassung
# ---------------------------------------------------------------------------
Write-Host "`nBuild erfolgreich abgeschlossen!" -ForegroundColor Green
Write-Host "Ergebnis: $distPath" -ForegroundColor Cyan
$exePath = Join-Path $distPath 'TN-Doku-Ersteller-Portable.exe'
if (Test-Path $exePath) {
    $sizeMb = [math]::Round((Get-Item $exePath).Length / 1MB, 1)
    Write-Host "EXE: TN-Doku-Ersteller-Portable.exe ($sizeMb MB)" -ForegroundColor Cyan
}
