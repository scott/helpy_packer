# Helpy Packer scripts for DigitalOcean Marketplace and One Click Install

This repo contains scripts used to create the DO marketplace and one-click install images. These images can be used to stand up a fully configured Helpy droplet.

### Building the image

First, you will need to install Packer on your workstation.  On a Mac, use 

```
brew install packer
```

To use, copy `variables.json.sample` to `variables.json` add your DO api key and run

```
packer build -var-file=variables.json install.json
```

This will automatically create a build droplet of the size specified in the `install.json` script, run the scripts in order to build up the server, install Helpy and then run the `cleanup.sh` and `img_check.sh` scripts.  Finally the build droplet will be powered down, a snapshot created and the build droplet destroyed.
