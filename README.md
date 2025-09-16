# mes-scripts

Collection de scripts personnels destinés à faciliter mes reconnaissances et automatisations lors de CTF (HackTheBox, TryHackMe, etc.).

⚠️ Ces outils sont conçus **à des fins éducatives et de pentest en environnement contrôlé**.  
N'utilisez jamais ces scripts sur des systèmes dont vous n'avez pas l'autorisation.

---

## 📂 Scripts inclus

### 🔹 mon-nmap
- **But** : Automatiser mes scans Nmap (TCP, UDP, détection OS/services, résumé).
- **Exemple** :
  ```bash
  mon-nmap 10.129.148.164
  ```
- **Résultat** :
  - Dossiers structurés `nmap_<cible>/`
  - Fichiers `summary.md` pour intégration dans mon site Hugo.

---

### 🔹 mon-recoweb
- **But** : Lancer un WhatWeb + fuzzing FFUF (répertoires et extensions ciblées).
- **Exemple** :
  ```bash
  mon-recoweb planning.htb
  ```
- **Résultat** :
  - Rapport WhatWeb
  - Résultats FFUF (dirs/files)
  - `summary.txt` (texte) et `summary.md` (Markdown pour Hugo).

---

### 🔹 mon-subdomains
- **But** : Enumération simple des sous-domaines (wordlist + DNS resolve).
- **Exemple** :
  ```bash
  mon-subdomains example.com
  ```
- **Résultat** :
  - Liste des sous-domaines valides
  - Fichier `subdomains.txt`

---

### 🔹 make-htb-wordlist.sh
- **But** : Générer une wordlist optimisée pour HackTheBox, destinée surtout aux énumérations DNS virtuelles et web fuzzing.
- **Sources utilisées** :
  - `subdomains-top1million-5000.txt` (SecLists DNS Top 5000)
  - `raft-small-words.txt` (SecLists Web Content)
  - (optionnel) `raft-medium-words.txt` pour enrichir la liste
  - Une mini seed interne « FAST » (admin, test, dev, api, login, etc.) toujours prioritaire
- **Règles de filtrage** :
  - minuscules uniquement `[a-z0-9-]`
  - pas de `--`, ni de `-` en début/fin
  - longueur 3 à 24 caractères
  - suppression des doublons, ordre préservé
- **Exemple** :
  ```bash
  # Générer la wordlist par défaut (5000 entrées max)
  make-htb-wordlist.sh
  
  # Générer une liste personnalisée
  make-htb-wordlist.sh --out /tmp/wordlist.txt --maxlen 16 --allow-digit-start
  ```
- **Résultat** :
  - Par défaut : `/usr/share/wordlists/htb-dns-vh-5000.txt`
  - Fichier limité aux 5000 premières entrées, déjà filtré et prêt à l’emploi avec `ffuf`, `gobuster`, etc.
  - Affiche un résumé et les 10 premiers mots générés.

---

## 📦 Installation

Cloner le dépôt et ajouter les scripts au `$PATH` :
```bash
git clone https://github.com/NoelNac-HackEthical/mes-scripts.git
cd mes-scripts
chmod +x mon-*
ln -sf "$PWD/mon-*" ~/.local/bin/
```

Vérifier :
```bash
mon-nmap -h
```

---

## 🔖 Versions & Releases

- Des **tags** sont créés régulièrement (`mes-scripts-YYYY-MM-DD-HHMMSS`) pour figer l'état du dépôt.
- Les versions stables sont disponibles dans la section [Releases](../../releases).

---

## 📌 Licence

Usage **strictement éducatif et légal**.  
Aucune garantie de bon fonctionnement ni de sécurité.

---

## ✍️ Auteur

- Noël ([@NoelNac-HackEthical](https://github.com/NoelNac-HackEthical))
