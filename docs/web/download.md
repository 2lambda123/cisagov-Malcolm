# Downloads

## Malcolm

### Docker images

Malcolm operates as a cluster of Docker containers, isolated sandboxes which each serve a dedicated function of the system. Its Docker images can be pulled from [Docker Hub](https://hub.docker.com/u/malcolmnetsec) or built from source by following the instructions in the [Quick Start](/documentation/#QuickStart) section of the documentation.

### Installer ISO

Malcolm's Docker-based deployment model makes Malcolm able to run on a variety of platforms. However, in some circumstances (for example, as a long-running appliance as part of a security operations center, or inside of a virtual machine) it may be desirable to install Malcolm as a dedicated standalone installation.

Malcolm can be [packaged](/documentation/#ISOBuild) into an [installer ISO](/documentation/#ISO) based on the current [stable release](https://wiki.debian.org/DebianStable) of [Debian](https://www.debian.org/). This [customized Debian installation](https://wiki.debian.org/DebianLive) is preconfigured with the bare minimum software needed to run Malcolm.

While official downloads of the Malcolm installer ISO are not provided, an **unofficial build** of the ISO installer for the [latest stable release](https://github.com/idaholab/Malcolm/releases/latest) is available for download here.

| ISO | SHA256 |
|---|---|
| [malcolm-2.4.2.iso](/iso/malcolm-2.4.2.iso) (3.7GiB) |  [`bd1536d17ac1ab3b9ac57575508ed01d80f07ea71dce3d8c6a4b7a64b622d14a`](/iso/malcolm-2.4.2.iso.sha256.txt) |

## Hedgehog Linux

### Installer ISO

[Instructions are provided](/hedgehog/#ISOBuild) to generate the Hedgehog Linux ISO from source. While official downloads of the Hedgehog Linux ISO are not provided, an **unofficial build** of the ISO installer for the latest stable release is available for download here.

| ISO | SHA256 |
|---|---|
| [hedgehog-2.4.2.iso](/iso/hedgehog-2.4.2.iso) (2.0GiB) |  [`a8c735c202e20b3fa866f3b38f6c552b983747b2857125b84728eb0c848f4bca`](/iso/hedgehog-2.4.2.iso.sha256.txt) |

## Warning

Please check any files you may have downloaded from the links on this page against the SHA256 sums provided to verify the integrity of the downloads.

Read carefully the installation documentation for [Malcolm](/documentation/#ISOInstallation) and/or [Hedgehog Linux](/hedgehog/#Installation). The ISO media boot on systems that support EFI-mode booting. The installer is designed to require as little user input as possible. For this reason, there are NO user prompts and confirmations about partitioning and reformatting hard disks for use by the operating system. The installer assumes that all non-removable storage media (eg., SSD, HDD, NVMe, etc.) are available for use and ⛔🆘😭💀 ***will partition and format them without warning*** 💀😭🆘⛔.

## Disclaimer

The terms of [Malcolm's license](https://raw.githubusercontent.com/idaholab/Malcolm/master/License.txt) also apply to these unofficial builds of the Malcolm and Hedgehog Linux installer ISOs: neither the organizations funding Malcolm's development, its developers nor the maintainer of this site makes any warranty, express or implied, or assumes any legal liability or responsibility for the accuracy, completeness or usefulness of any data, apparatus or process disclosed therein.