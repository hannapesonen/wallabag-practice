# Wallabag DevOps practice setup

This repo contains a Docker Compose setup for running Wallabag with SQLite

##
Prerequisites
- Docker
- Docker Compose
- VSCode
- Git

##
Instructions for running on Win 11. Run commands in PowerShell or CMD

- Install Docker desktop
    - check Use WSL 2 instead of Hyper-V
- Update WSL if needed
    wsl.exe --update
- Verify Docker works 
    docker version
    (check that Context: desktop-linux)
    docker info 
    (check that OSType: linux)
    docker run hello-world

##
- make directory for SQLite DB
    .\data
- start Wallabag
    docker compose -f compose-wallabag.yml up -d

##
- Clone original Wallabag repo (in cmd) (optional)
    cd C:\dev
    git clone https://github.com/wallabag/wallabag.git
    cd .\wallabag