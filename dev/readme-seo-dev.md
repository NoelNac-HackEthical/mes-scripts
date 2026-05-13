# mes-scripts

![Platform](https://img.shields.io/badge/platform-linux-black)
![Shell](https://img.shields.io/badge/shell-bash-blue)
![License](https://img.shields.io/badge/license-educational-lightgrey)

Scripts Bash pour Hack The Box, CTF, Linux, énumération réseau et reconnaissance web.

Ce dépôt regroupe des scripts personnels utilisés en conditions réelles pour automatiser certaines phases d’énumération et de reconnaissance dans des workflows CTF sur la plateforme Hack The Box (HTB).

La partie `Énumération` des writeups et walkthroughs publiés sur le site https://writeups.hackethical.be/ repose sur l’utilisation de ces scripts dans une méthodologie volontairement reproductible.

---

## Objectif du dépôt

Le projet `mes-scripts` centralise une boîte à outils Bash orientée :

- énumération réseau ;
- reconnaissance web ;
- découverte de sous-domaines et vhosts ;
- automatisation de workflows CTF et Hack The Box ;
- support technique aux writeups et walkthroughs ;
- documentation reproductible orientée Linux et sécurité offensive.

Les scripts sont conçus pour être :

- utilisés dans des environnements réels de laboratoire et de CTF ;
- lisibles et compréhensibles ;
- reproductibles ;
- intégrés dans des writeups techniques détaillés.

------

## Scripts disponibles

| Script              | Fonction                                                     | Domaine            |
| ------------------- | ------------------------------------------------------------ | ------------------ |
| `mon-nmap`          | Scan Nmap multi-phases orienté HTB/CTF                       | Énumération réseau |
| `mon-recoweb`       | Reconnaissance web automatisée avec `dirb`, `ffuf` et détection soft-404 | Web Recon          |
| `mon-subdomains`    | Découverte de vhosts et sous-domaines par fuzzing            | VHOST / DNS        |
| `make-htb-wordlist` | Génération d’une wordlist HTB orientée DNS/VHOST             | Wordlists          |

---

## Utilisation dans les writeups et walkthroughs Hack The Box

Ces scripts sont utilisés dans la phase `Énumération` des writeups et walkthroughs publiés sur le site https://writeups.hackethical.be/.

Exemples de writeups :

- Data HTB  
  https://writeups.hackethical.be/writeups/data/

- Valentine HTB  
  https://writeups.hackethical.be/writeups/valentine/

- Writeup HTB  
  https://writeups.hackethical.be/writeups/writeup/

- Cap HTB  
  https://writeups.hackethical.be/writeups/cap/

- Lame HTB  
  https://writeups.hackethical.be/writeups/lame/

L’ensemble des writeups du site est disponible sur :
https://writeups.hackethical.be/writeups/

---

## Philosophie du projet

Le dépôt suit une approche simple et volontairement classique :

- privilégier Bash et les outils Linux standards ;
- conserver des scripts lisibles et compréhensibles ;
- éviter les automatisations opaques ;
- maintenir des workflows reproductibles ;
- séparer clairement développement et publication ;
- documenter les méthodes réellement utilisées en CTF et Hack The Box.

L’objectif n’est pas uniquement d’exécuter des outils, mais aussi de comprendre les résultats obtenus et de pouvoir les intégrer dans une démarche méthodique de writeup, walkthrough et analyse technique.

---

## Organisation du dépôt

Le dépôt est structuré pour séparer clairement les scripts actifs, les versions de développement et les outils internes liés aux workflows GitHub et à la génération de nouveaux scripts.

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

- ### Scripts actifs

  Les scripts présents à la racine du dépôt sont considérés comme actifs :

  - utilisés en conditions réelles de CTF et Hack The Box ;
  - inclus dans les releases GitHub ;
  - pris en compte par les workflows GitHub Actions ;
  - référencés dans les writeups et walkthroughs du site.

### Dossier `dev/`

Le dossier `dev/` sert d’espace de développement contrôlé.

Il contient les versions de travail des scripts, généralement suffixées par `-dev`.

Ces fichiers peuvent être synchronisés via Git afin de sauvegarder ou transférer un état de travail entre plusieurs machines, mais ne sont pas destinés à être publiés dans les releases.

### Dossier `bak/`

Le dossier `bak/` contient des archives manuelles conservées à titre de référence :

- snapshots avant refonte ;
- anciennes versions de scripts ;
- fichiers historiques ;
- scripts abandonnés ou remplacés ;
- documents conservés pour comparaison ou restauration.

------

## Workflow de développement

Le workflow recommandé suit les étapes suivantes :

1. développement dans `dev/` ;
2. tests locaux sur Kali Linux ;
3. validation manuelle du comportement réel ;
4. copie vers la version active à la racine du dépôt ;
5. commit Git ;
6. génération automatique des releases GitHub via GitHub Actions.

Cette approche permet de séparer clairement développement et publication, tout en évitant la diffusion accidentelle de versions intermédiaires.s.

------

## GitHub Actions et releases

Le dépôt utilise le workflow GitHub Actions `release-aggregate.yml` pour :

- générer automatiquement les releases GitHub ;
- publier les scripts actifs dans les releases ;
- produire les checksums SHA256 ;
- préparer les ressources nécessaires à la publication automatique des scripts sur le site https://writeups.hackethical.be/ ;
- ignorer les versions de développement ;
- maintenir une séparation stricte entre scripts actifs et scripts en cours de développement.

Le workflow ignore volontairement :

- `dev/`
- les fichiers `*-dev`
- certaines archives et ressources internes

afin d’éviter toute publication involontaire de versions intermédiaires.

## Exemples d’utilisation

### Énumération réseau

```
mon-nmap target.htb
```

Résultats typiques :

```
scans_nmap/full_tcp_scan.txt
scans_nmap/aggressive_vuln_scan.txt
scans_nmap/cms_vuln_scan.txt
```

### Reconnaissance web

```
mon-recoweb http://target.htb
```

### Découverte de sous-domaines

```
mon-subdomains target.htb
```

------

## Site associé : HackEthical

Le site https://writeups.hackethical.be/ regroupe :

- writeups et walkthroughs Hack The Box ;
- méthodes d’énumération ;
- reconnaissance et exploitation web ;
- escalade de privilèges Linux ;
- documentation technique orientée CTF.

---

## Usage éthique

**Ces scripts sont fournis dans un cadre strictement éducatif, légal et autorisé.**

Ils sont destinés à des plateformes de laboratoire telles que :

- Hack The Box ;
- TryHackMe ;
- environnements CTF ;
- systèmes explicitement autorisés.

**Toute utilisation sur des systèmes tiers sans autorisation explicite est interdite.**

---

## Auteur

NoelNac — HackEthical

Linux • Bash • Hack The Box • CTF • writeups • walkthroughs
