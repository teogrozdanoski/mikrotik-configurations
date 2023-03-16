# Initial configuration file for MiktroTik RB962-UiGS-5HacT2HnT , hAP ac , MIPSBE
# model = RB962UiGS-5HacT2HnT
# wan port = ether1
# dhcp client enabled = ether1
# lan bridge name = bridge1
# lan ip address = 192.168.1.0/24
# lan ip pool = 192.168.1.2-192.168.1.254
# lan ports = ether2, ether3, ether4, ether5, wlan1, wlan2
# wlan1, wlan2 SSID = mtwifi
# wlan1, wlan2 security profile = dynamic keys, wpa2psk , key = wifipass
# dns servers = 81.17.233.5, 81.17.225.5
# ip Services = ssh-2219, winbox-8291 , available via 81.17.232.22
# router os version = routeros 7.7

# start of config

/interface bridge add name=bridge1
/interface ethernet set [ find default-name=ether1 ] comment=uplink
/interface wireless set [ find default-name=wlan1 ] band=2ghz-b/g/n disabled=no mode=ap-bridge ssid=mtwifi
/interface wireless set [ find default-name=wlan2 ] band=5ghz-a/n/ac disabled=no frequency=5240 mode=ap-bridge ssid=mtwifi
/interface wireless security-profiles set [ find default=yes ] authentication-types=wpa2-psk mode=dynamic-keys supplicant-identity=MikroTik wpa2-pre-shared-key=wifipass
/ip hotspot profile set [ find default=yes ] html-directory=hotspot
/ip pool add name=dhcp_pool0 ranges=192.168.1.2-192.168.1.254
/ip dhcp-server add address-pool=dhcp_pool0 interface=bridge1 name=dhcp1
/snmp community set [ find default=yes ] name= # snmp name
/interface bridge port add bridge=bridge1 interface=ether2
/interface bridge port add bridge=bridge1 interface=ether3
/interface bridge port add bridge=bridge1 interface=ether4
/interface bridge port add bridge=bridge1 interface=ether5
/interface bridge port add bridge=bridge1 interface=wlan1
/interface bridge port add bridge=bridge1 interface=wlan2
/ip address add address=192.168.1.1/24 interface=bridge1 network=192.168.1.0
/ip dhcp-client add interface=ether1
/ip dhcp-server network add address=192.168.1.0/24 dns-server=81.17.233.5,81.17.225.5 gateway=192.168.1.1
/ip dns set servers=81.17.233.5,81.17.225.5
/ip firewall address-list add address=192.168.1.2-192.168.1.254 list=allowed_to_router
/ip firewall address-list add address=81.17.232.22 list=allowed_to_router
/ip firewall address-list add address=0.0.0.0/8 comment=RFC6890 list=not_in_internet
/ip firewall address-list add address=172.16.0.0/12 comment=RFC6890 list=not_in_internet
/ip firewall address-list add address=192.168.0.0/16 comment=RFC6890 list=not_in_internet
/ip firewall address-list add address=10.0.0.0/8 comment=RFC6890 list=not_in_internet
/ip firewall address-list add address=169.254.0.0/16 comment=RFC6890 list=not_in_internet
/ip firewall address-list add address=127.0.0.0/8 comment=RFC6890 list=not_in_internet
/ip firewall address-list add address=224.0.0.0/4 comment=Multicast list=not_in_internet
/ip firewall address-list add address=198.18.0.0/15 comment=RFC6890 list=not_in_internet
/ip firewall address-list add address=192.0.0.0/24 comment=RFC6890 list=not_in_internet
/ip firewall address-list add address=192.0.2.0/24 comment=RFC6890 list=not_in_internet
/ip firewall address-list add address=198.51.100.0/24 comment=RFC6890 list=not_in_internet
/ip firewall address-list add address=203.0.113.0/24 comment=RFC6890 list=not_in_internet
/ip firewall address-list add address=100.64.0.0/10 comment=RFC6890 list=not_in_internet
/ip firewall address-list add address=240.0.0.0/4 comment=RFC6890 list=not_in_internet
/ip firewall address-list add address=192.88.99.0/24 comment="6to4 relay Anycast [RFC 3068]" list=not_in_internet
/ip firewall filter add action=accept chain=input comment="default configuration" connection-state=established,related
/ip firewall filter add action=accept chain=input src-address-list=allowed_to_router
/ip firewall filter add action=accept chain=input protocol=icmp
/ip firewall filter add action=accept chain=input comment="allow akton snmp server" port=161 protocol=udp src-address=82.214.118.218
/ip firewall filter add action=drop chain=input
/ip firewall filter add action=fasttrack-connection chain=forward comment=FastTrack connection-state=established,related hw-offload=yes
/ip firewall filter add action=accept chain=forward comment="Established, Related" connection-state=established,related
/ip firewall filter add action=drop chain=forward comment="Drop invalid" connection-state=invalid log=yes log-prefix=invalid
/ip firewall filter add action=drop chain=forward comment="Drop incoming packets that are not NAT`ted" connection-nat-state=!dstnat connection-state=new in-interface=ether1 log=yes log-prefix=!NAT
/ip firewall filter add action=jump chain=forward comment="jump to ICMP filters" jump-target=icmp protocol=icmp
/ip firewall filter add action=drop chain=forward comment="Drop incoming from internet which is not public IP" in-interface=ether1 log=yes log-prefix=!public src-address-list=not_in_internet
/ip firewall filter add action=accept chain=icmp comment="echo reply" icmp-options=0:0 protocol=icmp
/ip firewall filter add action=accept chain=icmp comment="net unreachable" icmp-options=3:0 protocol=icmp
/ip firewall filter add action=accept chain=icmp comment="host unreachable" icmp-options=3:1 protocol=icmp
/ip firewall filter add action=accept chain=icmp comment="host unreachable fragmentation required" icmp-options=3:4 protocol=icmp
/ip firewall filter add action=accept chain=icmp comment="allow echo request" icmp-options=8:0 protocol=icmp
/ip firewall filter add action=accept chain=icmp comment="allow time exceed" icmp-options=11:0 protocol=icmp
/ip firewall filter add action=accept chain=icmp comment="allow parameter bad" icmp-options=12:0 protocol=icmp
/ip firewall filter add action=drop chain=icmp comment="deny all other types"
/ip firewall nat add action=masquerade chain=srcnat out-interface=ether1 src-address=192.168.1.0/24
/ip service set telnet disabled=yes
/ip service set ftp disabled=yes
/ip service set www disabled=yes
/ip service set ssh address=81.17.232.22/32 port=2219
/ip service set api disabled=yes
/ip service set winbox address=81.17.232.22/32
/ip service set api-ssl disabled=yes
/snmp set enabled=yes
/system clock set time-zone-name=Europe/Skopje
/system identity set name=Akt-Client-RB962
/user set admin password=pass2023

# end of config
