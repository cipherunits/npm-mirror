---
title: "NPM Mirror — Offline NPM Registry Cache"
description: "Self-hosted Verdaccio-based npm registry that mirrors and caches npm, pnpm, and yarn packages for faster installs and offline development during network outages."
---

# NPM Mirror

The **NPM Mirror** service is an internal Registry based on **Verdaccio** that acts as a Mirror and Cache for the main npm Registry.

The goal of this project is to reduce dependency on the internet, increase package installation speed, and enable package installation during internet outages.

## Benefits

- Reduced internet usage
- Increased package installation speed
- Ability to install cached packages during internet outages
- A shared Cache across all developers
- No need to change existing projects

## Ultimate Goal

All developers in the company use only a single internal Registry.

```
Developer
      │
      ▼
NPM Mirror
      │
      ├── Cache
      │
      └── npmjs.org
```

As a result, installation speed increases, internet usage decreases, and during internet outages, cached packages can still be installed.