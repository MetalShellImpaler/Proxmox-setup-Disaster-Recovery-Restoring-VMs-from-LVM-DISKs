# Proxmox Disaster Recovery: Restoring VMs from Legacy LVM disks

# Storage Discovery & LVM Conflict Resolution
# identify the drive
lsblk
# check UUID
vgs -o +vg_uuid

# if needed Rename the old Volume to avoid conflict with the current OS:
vgrename [UUID] old_pve
vgchange -ay old_pve

ls /mnt/old_ssd/var/lib/vz/images



# List and View VM Configs

sqlite3 /mnt/old_ssd/var/lib/pve-cluster/config.db "SELECT name FROM tree WHERE name LIKE '%.conf';"

sqlite3 /mnt/old_ssd/var/lib/pve-cluster/config.db "SELECT data FROM tree WHERE name = '100.conf';"

# Restore VMS manually [ Example with 100.conf and vm-100-disk-0.qcow2 ]
# On the new system, create a new configuration file and paste the data retrieved from the SQLite query.
touch /etc/pve/qemu-server/100.conf

# Paste the data from the old database:
nano /etc/pve/qemu-server/100.conf
cat /etc/pve/qemu-server/100.conf

# Migrate the Virtual Disk
mkdir -p /var/lib/vz/images/100

cp /mnt/old_ssd/var/lib/vz/images/100/vm-100-disk-0.qcow2 /var/lib/vz/images/100/

#Check the file:
ls -l /var/lib/vz/images/100/

# Scan for the disk
qm rescan --vmid 100

# if even one line in your configuration mentions the old storage, it will try to "activate" it and fail.
# in the database file the info should be the info of the new install
# for example:
virtio0: local:100/vm-100-disk-0.qcow2,size=52G
ide2: none,media=cdrom


# Storage Permissions (GUI or CLI)
# CLI Method:
pvesm set local --content images,rootdir,vztmpl,iso,backup

#    In the Web GUI, go to Datacenter -> Storage.

#    Select local and click Edit.

#    In the Content dropdown, make sure Disk image is selected (it should be highlighted/checked).

#    Click OK.

