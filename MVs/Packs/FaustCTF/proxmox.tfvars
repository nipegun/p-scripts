pve-node     = "ctfgameserver"
pve-vm-ds    = "local-lvm"
team-count   = 5

gameserver-instance-user-path     = ""
gameserver-instance-username      = "root"
gameserver-priv-ip-CIDR           = "10.255.254.200/24"
gameserver-priv-ip                = "10.255.254.200"
gameserver-priv-gw                = "10.255.254.1"

gameserver-sub-instance-user-path = ""
gameserver-sub-instance-username  = "root"
gameserver-sub-priv-ip-CIDR       = "10.255.254.210/24"
gameserver-sub-priv-ip            = "10.255.254.210"
gameserver-sub-priv-gw            = "10.255.254.1"

openvpn-install-script-location = ""
openvpn-instance-user-path      = ""
openvpn-instance-username       = "root"
openvpn-port                    = 1194
ovpn-users                      = []

pve-templ-ds = "local-lvm"

service-instance-user-path = ""
service-instance-username  = "root"
service-priv-ip-CIDR       = "10.255.254.220/24"
service-priv-ip            = "10.255.254.220"
service-priv-gw            = "10.255.254.1"

pve-endpoint  = "https://10.5.0.210:8006/api2/json"
pve-username  = "root@pam"
pve-password  = "P@ssw0rd"
pve-insecure  = true
pve-tmppath   = "/tmp"
