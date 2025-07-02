# Migrarea Mașinilor Virtuale

Acest proiect include două scripturi batch concepute pentru a **automatiza migrarea unei mașini virtuale (VM)** între două calculatoare, folosind **Oracle VirtualBox** și un **stick USB**. Scopul principal este **simplificarea procesului** și **reducerea duratei totale de migrare**.

---

## 📁 Fișiere incluse

### `migrare_export.bat` (se rulează pe PC1 - calculatorul sursă)
Automatizează:
- Identificarea arhivatorului (WinRAR sau 7-Zip)
- Arhivarea fișierului `.ova`
- Detectarea stickului USB și copierea arhivei
- Cronometrarea fiecărei etape

### `migrare_import.bat` (se rulează pe PC2 - calculatorul destinație)
Automatizează:
- Localizarea arhivei pe stick
- Copierea și dezarhivarea pe disc
- Importul mașinii virtuale în VirtualBox
- Afișarea timpului total și al fiecărei etape

---

## 🛠️ Cerințe minime

- Windows 10 sau 11  
- Oracle VirtualBox instalat  
- WinRAR sau 7-Zip instalat pe discul `C:\`  
- Stick USB cu spațiu suficient  
- Mașină virtuală exportată în format `.ova`  

---

## 📋 Instrucțiuni de utilizare

### Pe PC1 (Sursă):
1. Rulează `migrare_export.bat` din Command Prompt.
2. Scriptul va crea arhiva și o va copia automat pe stick.

### Pe PC2 (Destinație):
1. Conectează stickul USB.
2. Rulează `migrare_import.bat`.
3. Scriptul va importa automat mașina virtuală în VirtualBox.

---

## ⏱️ Etape monitorizate

Ambele scripturi măsoară durata pentru:
- Arhivare
- Copierea pe USB
- Dezarhivare
- Import în VirtualBox
- Timpul total al migrației

---

## 🔒 Verificare integritate (opțional)

Scripturile **nu includ verificare automată** a integrității fișierului `.ova`. Totuși, poți face această verificare manual, folosind comanda CMD:

```

CertUtil -hashfile NumeFisier.ova SHA256

```
Această comandă calculează hash-ul SHA256 al fișierului și poate fi rulată pe ambele calculatoare pentru a verifica dacă fișierul a fost transferat corect.

---

>Pentru aplicații critice, se recomandă adăugarea manuală a acestei etape înainte de import.


