# import all san enabled metal-hosts

SANM=$(host -al amana.vpn | grep '\-san' | egrep ".*(-kvm-|-storage-|-db-).*" | awk '{print $1}' | sed 's/\.$//')

for H in $SANM ; do echo $H ; sed -i '' "/${H}/d"  ~/.ssh/known_hosts ; IP=$(host $H | grep -v NXDOMAIN | awk '{print $4}') ;  if [ "${IP}" != "" ] ; then sed -i '' "/${IP}/d"  ~/.ssh/known_hosts ; fi ; done

for H in $SANM ; do echo $H ; ssh -o ConnectTimeout=1 -o ConnectionAttempts=1 -o StrictHostKeyChecking=no -o PasswordAuthentication=no $H date ; done




SANM=$(host -al amana.vpn | egrep 'es-' | grep '\-san' | egrep ".*(-kvm-|-storage-|-db-).*" | awk '{print $1}' | sed 's/\.$//')


for H in $SANM ; do echo "---- $H ----" ; ssh -l ansible -i /Users/gassi/Devel/ansible-playbooks/env/live/storage/ansible-keys/$(echo $H | sed 's/-san//') $H -C 'sudo cat /proc/net/bonding/bond0 | grep "Number of ports"  ; for I in $(cat /sys/class/net/bond0/bonding/slaves) ; do echo "interface: $I" ; sudo lldpctl $I | egrep "(SysName|PortDescr)" ; done '; done


# check bond mode 1 metal

eshelter bond mode 1 hosts

--limit=es-db-04.amana.vpn,es-db-01.amana.vpn,es-kvm-01.amana.vpn,es-kvm-04.amana.vpn,es-kvm-03.amana.vpn,es-kvm-06.amana.vpn,es-kvm-09.amana.vpn,es-kvm-08.amana.vpn

green bond mode 1 hosts

--limit=gr-kvm-02.amana.vpn,gr-kvm-03.amana.vpn,gr-kvm-04.amana.vpn,gr-kvm-05.amana.vpn,gr-db-04.amana.vpn


# Mount all (gluster) again

cd env/live

for HOST in $(host -al amana.vpn | grep '\-san' | awk '{print $1}' | sed 's/\.$//' ) ; do 
	echo -n "$HOST  "  ; ssh -o ConnectTimeout=1 -o ConnectionAttempts=1 -o StrictHostKeyChecking=no -o PasswordAuthentication=no $HOST date
done

for HOST in $(host -al amana.vpn | grep '\-san' | awk '{print $1}' | sed 's/\.$//') ; do 

	echo ""
	echo ""
	echo "----------- $(host $HOST) -----------"
	
	ssh -i storage/ansible-keys/$( echo $HOST | sed 's/\-san//' ) -l ansible $HOST -C 'sudo mount -a ; mount'
	
done

