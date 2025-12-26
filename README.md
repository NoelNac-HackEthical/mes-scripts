# mes-scripts

Collection de scripts personnels orientés **CTF / Hack The Box / reconnaissance / automatisation**, utilisés et maintenus dans un cadre de **hacking éthique**.

Ce dépôt distingue volontairement :
- les **scripts actifs** (publiés et distribués),
- des **versions de travail** servant au développement et à la synchronisation entre machines.

---

## 📁 Organisation du dépôt

### Scripts actifs (racine du dépôt)

Les scripts situés **à la racine** du dépôt sont considérés comme **actifs** :

- ils sont stables ou en voie de stabilisation,
- ils sont pris en compte par les workflows GitHub Actions,
- ils sont inclus dans les releases,
- ils sont référencés côté site Hugo / Netlify.

Exemples :
```
mon-recoweb
mon-nmap
mon-subdomains
```

---

### 🧪 Dossier `dev/` — workdir de développement

Le dossier `dev/` est un **workdir de développement** destiné aux versions temporaires des scripts.

Caractéristiques :

- scripts en cours de modification ou de test,
- fichiers suffixés par `-dev`,
- versions **commitées volontairement** pour :
  - sauvegarder des états intermédiaires,
  - synchroniser le travail entre plusieurs machines (desktop / laptop).

Exemples :
```
dev/mon-recoweb-dev
dev/mon-nmap-dev
```

⚠️ Ces scripts **ne sont pas destinés à être utilisés directement** ni à être publiés.

---

## 🔁 Workflow recommandé (dev → publication)

### 1️⃣ Développement
Le travail se fait dans `dev/*-dev`.

```bash
dev/mon-recoweb-dev
```

---

### 2️⃣ Sauvegarde / synchronisation (work in progress)

Lorsque nécessaire, un instantané du travail peut être sauvegardé :

```bash
git commit -m "wip(dev) : instantané des scripts de travail"
git push
```

Ces commits servent uniquement à la **continuité du travail** et non à la publication.

---

### 3️⃣ Publication d’un script

Une fois le développement terminé :

1. Reporter manuellement les modifications vers le script actif à la racine.
2. Vérifier le script.
3. Committer normalement (`feat`, `fix`, `chore`, etc.).

👉 **Seuls les scripts actifs déclenchent une release.**

---

## 🛡️ CI / Releases — garde-fous

Les workflows GitHub Actions sont configurés pour :

- ignorer le dossier `dev/`,
- ignorer les fichiers suffixés `-dev`,
- empêcher toute publication accidentelle de versions de travail.

Un commit ne concernant que `dev/` :
- peut déclencher un workflow,
- **mais n’entraîne aucune release**.

Les scripts actifs restent les **seuls artefacts publiés**.

---

## 🧭 Conventions de nommage

- `nom-script` → script actif, publiable
- `nom-script-dev` → version de travail
- `dev/` → espace de développement contrôlé

---

## 📜 Licence et usage

Ces scripts sont fournis à des fins **éducatives et personnelles**, dans un cadre de **sécurité offensive légale**.

L’utilisation sur des systèmes sans autorisation explicite est interdite.

---

## ✍️ Auteur

Noël — *HackEthical*  
CTF / Hack The Box / automatisation & documentation technique
