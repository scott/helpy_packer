# Helpy Packer
Provisions the Helpy one-click image using Packer.  To use, add your DO key to variables.json and run

```
packer build -var-file=variables.json install.json
```