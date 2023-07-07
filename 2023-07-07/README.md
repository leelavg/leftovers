# Dotfiles

### Configs
---

Symlinks for files are created upon running ```chmod +x setup.sh && ./setup.sh```. Current repo consists of below configs:
```ansible, bashrc, gitconfig, init.vim, tmux.conf```

Each config only span a single file and separated using fold markers (easy to maintain with nvim).

### Backups
---

Currently **no** backups are provided, all configs are symlinked to ```~/.dotfiles/```and individiual configs are symlinked based on this directory. Only a log is created and the ouput on running `setup.sh` is mirrored in this log.


### Compatibility
---

- [x] Fedora 32
- [x] RHEL 8
- [x] CentOS 8

### ToDo
---
- [ ] Backup of existing dotfiles

---
## **PS:** Please raise an issue for any info and **Use at your own risk**
---
