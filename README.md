# Proxmox Setup and VM Restore from Old Host Storage

This repository contains scripts for rebuilding a Proxmox environment and restoring virtual machines from a non-bootable or failed Proxmox host, where the original storage is still available on an old disk or LVM volume.

## Contents

### Storage Setup
- `merge-storage-volumes.sh`  
  Reconfigures storage into a single ext4 volume.

### VM Recovery
- `restore-vm-from-old-disk.sh`  
  Restores virtual machines from an old Proxmox disk or volume after host failure.

## Notes

- Designed for recovery scenarios where the original Proxmox system cannot boot
- Assumes access to the original disk or volume containing VM data
- Scripts should be reviewed before execution in production environments

