"""
csv_reader.py – Liest die Teilnehmer-CSV (Semikolon-getrennt, Windows-1252)
"""
import csv
import os


EXPECTED_COLUMNS = {'Name', 'Maßnahme', 'Maßnahmekürzel'}


def read_participants(csv_path: str) -> list[dict]:
    """
    Liest die Teilnehmer-CSV und gibt eine Liste von Dicts zurück.
    Unterstützt Windows-1252, UTF-8 (mit/ohne BOM) und Latin-1.
    Gibt eine ValueError aus, wenn die Datei nicht gelesen werden kann.
    """
    if not os.path.isfile(csv_path):
        raise FileNotFoundError(f"CSV-Datei nicht gefunden: {csv_path}")

    encodings = ['windows-1252', 'utf-8-sig', 'utf-8', 'latin-1']
    last_error = None

    for enc in encodings:
        try:
            with open(csv_path, newline='', encoding=enc) as f:
                reader = csv.DictReader(f, delimiter=';')
                rows = [row for row in reader if any(v.strip() for v in row.values())]
            if rows:
                # Prüfe ob Pflicht-Spalten vorhanden sind
                available = set(rows[0].keys())
                missing = EXPECTED_COLUMNS - available
                if missing:
                    raise ValueError(
                        f"CSV fehlen Spalten: {', '.join(missing)}. "
                        f"Vorhanden: {', '.join(available)}"
                    )
                return rows
        except (UnicodeDecodeError, UnicodeError) as e:
            last_error = e
            continue

    raise ValueError(
        f"CSV konnte mit keiner bekannten Zeichenkodierung gelesen werden. "
        f"Letzter Fehler: {last_error}"
    )
