# mes-scripts

Collection de scripts personnels orientés **CTF / Hack The Box (HTB)**, utilisés en conditions réelles pour l’énumération, la reconnaissance et l’automatisation, dans un cadre strict de **hacking éthique**.

## 🔗 Writeups & documentation

Ces scripts sont utilisés et documentés dans mes writeups et recettes sur [HackEthical](https://writeups.hackethical.be/).

👉 Writeup récent — Data (HTB Easy)  
https://writeups.hackethical.be/writeups/data/

👉 Recette — analyser rapidement un fichier texte, une sortie --help ou un fichier de configuration par mots-clés  
https://writeups.hackethical.be/recettes/analyse-mots-cles/

👉 Accès au site complet HackEthical  
https://writeups.hackethical.be/

Ce dépôt est volontairement structuré pour distinguer clairement :

- les **scripts actifs** (utilisés, versionnés, publiés),
- les **versions de travail** servant au développement et à la synchronisation.

------

## 🎯 Objectif du dépôt

- Centraliser des scripts Bash utilisés en conditions réelles de CTF Hack The Box (HTB), notamment pour l’énumération et la prise pied.
- Garantir une approche **reproductible**, lisible et contrôlée.
- Éviter toute publication accidentelle de versions intermédiaires.

Les scripts sont conçus pour être **lus autant qu’exécutés**, et s’intègrent dans une démarche de documentation via writeups et recettes.

------

## 📁 Organisation du dépôt

### Scripts actifs (racine du dépôt)

Les scripts situés **à la racine** du dépôt sont considérés comme **actifs** :

- versions stabilisées ou validées,
- pris en compte par les workflows GitHub Actions,
- inclus dans les releases,
- référencés côté documentation (site Hugo / Netlify).

Exemple d’utilisation — phase **Enumération** dans un writeup HTB :  
https://writeups.hackethical.be/writeups/data/

Les versions des scripts sont gérées via les releases GitHub associées à ce dépôt.

Scripts actuellement actifs :

- **mon-nmap** — scan Nmap multi-phases pour CTF (pré-check HTB, TCP complet, agressif, CMS, UDP)

- **mon-recoweb** — reconnaissance web automatisée en 3 phases (dirb + ffuf directories + ffuf files), détection soft-404 et résumé agrégé

- **mon-subdomains** — découverte de vhosts / sous-domaines par vhost-fuzzing (ffuf) avec baselines robustes, anti-wildcard et parsing JSON

- **make-htb-wordlist** — génération et installation d’une wordlist DNS/VHOST orientée HTB (5000 entrées) à partir de SecLists

------

### 🧪 Dossier dev/ — workdir de développement

Le dossier dev/ est un **espace de travail contrôlé**, destiné aux versions en cours de développement.

Caractéristiques :

- scripts en cours de modification ou d’expérimentation,
- fichiers suffixés par -dev,
- commits volontaires servant à :
  - sauvegarder des états intermédiaires,
  - synchroniser le travail entre plusieurs machines.

Exemples :

- dev/mon-nmap-dev
- dev/mon-recoweb-dev
- dev/mon-subdomains-dev

Ces scripts **ne sont ni publiés ni destinés à un usage direct**.

------

### 🗃️ Dossier bak/ — archives manuelles

Le dossier bak/ contient des **copies de sauvegarde ponctuelles** :

- snapshots avant refonte,
- scripts abandonnés ou renommés,
- tests isolés conservés à des fins de référence.

Ces fichiers ne participent ni aux releases ni aux workflows.

------

### 🛠️ Outillage du dépôt

- tools/
   Scripts utilitaires liés au dépôt (ex. création de nouveaux scripts).
- templates/
   Modèles servant de base à l’écriture de nouveaux scripts Bash.

------

## 🔁 Workflow recommandé (dev → publication)

### 1️⃣ Développement

Le développement se fait exclusivement dans dev/*-dev.

Exemple :
 dev/mon-recoweb-dev

------

### 2️⃣ Sauvegarde / synchronisation

Les versions intermédiaires peuvent être commitées afin d’assurer la continuité du travail entre machines.

Exemple de commit :

- wip(dev) : instantané de travail

Ces commits n’ont **aucune vocation de publication**.

------

### 3️⃣ Activation d’un script

Une fois le développement validé :

1. Copier manuellement les modifications vers le script actif à la racine.
2. Vérifier le comportement réel du script.
3. Committer de manière classique (feat, fix, chore, etc.).
4. Créer si besoin un **tag de sauvegarde**.

Seuls les scripts actifs déclenchent une release.

------

## 🛡️ CI / Releases — garde-fous

Les workflows GitHub Actions sont configurés pour :

- ignorer le dossier dev/,
- ignorer les fichiers suffixés -dev,
- empêcher toute publication accidentelle de versions de travail.

Un commit ne concernant que dev/ :

- peut déclencher un workflow,
- mais **ne génère aucune release**.

Les scripts actifs restent les **seuls artefacts publiés**.

------

## 🧭 Conventions de nommage

- nom-script → script actif, publiable
- nom-script-dev → version de travail
- dev/ → espace de développement contrôlé
- bak/ → archives manuelles

------

## 📜 Licence et usage

Ces scripts sont fournis à des fins **éducatives et personnelles**, dans un cadre de **sécurité offensive légale**.

Toute utilisation sur des systèmes sans autorisation explicite est interdite.

------

## ✍️ Auteur

Noël — HackEthical
 CTF / Hack The Box / automatisation & documentation technique
