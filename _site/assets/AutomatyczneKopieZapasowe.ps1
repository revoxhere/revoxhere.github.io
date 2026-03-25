# ------------------------------------------------------------------
# Automatyczne kopie zapasowe                      1.0 
# Robert "revox" Piotrowski, praktyki Tyco Electronics
# www.piotrowsky.dev                           02.2023
# ------------------------------------------------------------------
# Program kompresuje zawartosc folderu wskazanego w zmiennej $Pliki
# i zapisuje plik .zip w folderze wskazanym w zmiennej $Kopie.
# Stare kopie zapasowe sa automatycznie usuwane
# (maksymalna liczba kopii wskazana w zmiennej $MaxLiczba).
# ------------------------------------------------------------------

$ErrorActionPreference = "Stop"

$Pliki = "C:\Users\revox\Desktop\Pliki"
$Kopie = "C:\Users\revox\Desktop\Kopie zapasowe\"
$MaxLiczba = 10
$Dzisiaj = Get-Date -Format "dd.MM.yyyy HH-mm-ss"

echo "Automatyczne kopie zapasowe 1.0`nRobert `"revox`" Piotrowski dla Tyco Electronics 02.2023`n"

if (Test-Path -Path $Pliki) {} else {
    echo "Folder '$($Pliki)' nie istnieje - sprawdz konfiguracje!"
    return "Blad konfiguracji 1"
}
if (Test-Path -Path $Kopie ) {} else {
    echo "Folder '$($Kopie)' nie istnieje - sprawdz konfiguracje!"
    return "Blad konfiguracji 2"
}
if ($MaxLiczba -gt 0) {} else {
    echo "Liczba kopii '$($MaxLiczba)' jest nieprawidlowa - sprawdz konfiguracje!"
    return "Blad konfiguracji 3"
}

echo "Zapisywanie kopii zapasowej do: '$($Kopie)Kopia zapasowa z $($Dzisiaj).zip'..."
Compress-Archive -Path $Pliki -DestinationPath "$($Kopie)Kopia zapasowa z $($Dzisiaj).zip" -Update
if (Test-Path -Path $Pliki) {
    echo " - Kopia zapasowa pomyslnie utworzona`n"
} else {
    echo " - Nie utworzono kopii zapasowej. Sprawdz uprawnienia programu!"
    return "Blad tworzenia kopii 1"
}

cd $Kopie
$LiczbaPlikow = (Get-ChildItem -File | Measure-Object).Count
echo "Liczba kopii zapasowych w folderze: $($LiczbaPlikow)"

if ($LiczbaPlikow -gt $MaxLiczba) {
    echo " - W folderze jest wiecej kopii zapasowych niz dozwolono ($($MaxLiczba)) - usuwanie najstarszej..."

    $NajstarszyPlik = Get-ChildItem $Kopie | Sort CreationTime | Select -First 1
    $NajstarszyPlik | Remove-Item
    if (Test-Path -Path $Pliki) {
        echo " - Usunieto najstarsza kopie zapasowa: '$($NajstarszyPlik)'"
    } else {
        echo " - Nie usunieto najstarszej kopii zapasowej. Sprawdz uprawnienia programu!"
        return "Blad usuwania najstarszej kopii 1"
    }
} else {
    echo " - Nie ma potrzeby usuwania najstarszej kopii zapasowej (max: $($MaxLiczba))"
}

return "`nKoniec programu"
