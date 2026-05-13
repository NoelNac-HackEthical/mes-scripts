# mes-scripts

Scripts Bash pour Hack The Box, CTF, Linux, énumération réseau et reconnaissance web.

Ce dépôt regroupe des scripts personnels utilisés en conditions réelles pour automatiser certaines phases d’énumération et de reconnaissance dans les workflows de résolution de challenges Capture The Flag (CTF) sur la plateforme Hack The Box (HTB).

La partie « Énumération » des writeups publiés sur le site https://writeups.hackethical.be/ repose sur l’utilisation de ces scripts dans une méthodologie volontairement reproductible.

---

## Objectif du dépôt

Le projet `mes-scripts` a pour objectif de centraliser une boîte à outils Bash orientée :

- énumération réseau ;
- reconnaissance web ;
- découverte de sous-domaines et vhosts ;
- automatisation de workflows CTF ;
- support technique aux writeups Hack The Box ;
- documentation reproductible orientée Linux et sécurité offensive.

Les scripts sont conçus pour être :

- utilisés dans des environnements réels de laboratoire ;
- lisibles et compréhensibles ;
- reproductibles ;
- documentés dans des writeups techniques détaillés.

---

## Scripts disponibles

| Script              | Fonction                                             | Domaine            |
| ------------------- | ---------------------------------------------------- | ------------------ |
| `mon-nmap`          | Scan Nmap multi-phases orienté HTB/CTF               | Énumération réseau |
| `mon-recoweb`       | Reconnaissance web automatisée avec `dirb` et `ffuf` | Web Recon          |
| `mon-subdomains`    | Découverte de vhosts et sous-domaines                | VHOST / DNS        |
| `make-htb-wordlist` | Génération d’une wordlist HTB orientée DNS/VHOST     | Wordlists          |

---

## Utilisation dans les writeups Hack The Box

Ces scripts sont utilisés dans différents writeups et recettes publiés sur HackEthical.

Exemples :

- Data HTB
- Code HTB
- Artificial HTB
- Cap HTB
- Lame HTB

Writeups :
https://writeups.hackethical.be/writeups/

Recettes :
https://writeups.hackethical.be/recettes/

---

## Philosophie du projet

Le dépôt suit une approche simple et volontairement classique :

- privilégier Bash et les outils Linux standards ;
- conserver des scripts lisibles ;
- éviter les automatisations opaques ;
- maintenir des workflows reproductibles ;
- séparer clairement développement et publication ;
- documenter les méthodes réellement utilisées en CTF.

L’objectif n’est pas uniquement d’exécuter des outils, mais aussi de comprendre les résultats et de pouvoir les intégrer dans une démarche méthodique de writeup et d’analyse technique.

---

## Organisation du dépôt

```text
mes-scripts/
├── mon-nmap
├── mon-recoweb
├── mon-subdomains
├── make-htb-wordlist
├── dev/
├── bak/
├── templates/
├── tools/
└── .github/workflows/
```

### Scripts actifs

Les scripts présents à la racine du dépôt sont considérés comme actifs :

- utilisés en conditions réelles ;
- inclus dans les releases ;
- pris en compte par les workflows GitHub Actions ;
- référencés dans la documentation du site.

### Dossier `dev/`

Le dossier `dev/` sert d’espace de développement contrôlé.

Il contient les versions de travail suffixées par `-dev`.

Ces fichiers peuvent être synchronisés via Git mais ne sont pas destinés à être publiés.

### Dossier `bak/`

Le dossier `bak/` contient :

- snapshots manuels ;
- anciennes versions ;
- archives avant refonte ;
- scripts conservés à titre de référence.

------

## Workflow de développement

Le workflow recommandé suit les étapes suivantes :

1. développement dans `dev/` ;
2. tests locaux ;
3. validation manuelle ;
4. copie vers la version active ;
5. commit Git ;
6. génération automatique des releases GitHub.

Cette approche permet d’éviter la publication accidentelle de versions intermédiaires.

------

## GitHub Actions et releases

Le dépôt utilise plusieurs workflows GitHub Actions pour :

- générer automatiquement les releases ;
- publier les scripts actifs ;
- produire les checksums SHA256 ;
- synchroniser les ressources liées au site Hugo ;
- maintenir une séparation stricte entre scripts actifs et versions de développement.

Les workflows ignorent volontairement :

- `dev/`
- les fichiers `*-dev`
- certaines archives et ressources internes

afin d’éviter toute publication involontaire.

------

## Exemples d’utilisation

### Énumération réseau

```
./mon-nmap target.htb
```

Résultats typiques :

```
scans_nmap/full_tcp_scan.txt
scans_nmap/aggressive_vuln_scan.txt
scans_nmap/cms_vuln_scan.txt
```

### Reconnaissance web

```
./mon-recoweb http://target.htb
```

### Découverte de sous-domaines

```
./mon-subdomains target.htb
```

------

## Site associé : HackEthical

Le site HackEthical regroupe :

- writeups Hack The Box ;
- recettes Linux ;
- méthodes d’énumération ;
- exploitation web ;
- escalade de privilèges ;
- documentation orientée CTF.

Site principal :

https://writeups.hackethical.be/

------

## Usage éthique

Ces scripts sont fournis dans un cadre strictement éducatif et légal.

Ils sont destinés aux plateformes de laboratoire telles que :

- Hack The Box ;
- TryHackMe ;
- environnements CTF ;
- systèmes explicitement autorisés.

Toute utilisation sur des systèmes tiers sans autorisation est interdite.

------

## Auteur

Noël — HackEthical

Linux • Bash • Hack The Box • CTF • automation • writeups
