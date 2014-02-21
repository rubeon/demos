net start w32time
w32tm /config /manualpeerlist:"time.lon.rackspace.com 1.uk.pool.ntp.org 2.uk.pool.ntp.org 3.uk.pool.ntp.org" /syncfromflags:manual /reliable:yes /update
w32tm /resync
netsh advfirewall firewall set rule group="remote administration" new enable=yes & netsh advfirewall firewall add rule name="WinRM Port" dir=in action=allow protocol=TCP localport=5985
