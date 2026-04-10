# Cool Arch CLI Installation

Install into an Arch live environment without touching the system Python packages:

```bash
curl -fsSL https://raw.githubusercontent.com/AleXxi1337/caci/refs/heads/master/install.sh | bash
```

The installer keeps package-manager output quiet and links `caci` into `/usr/local/bin`, so it should be available immediately as:

```bash
caci
```
