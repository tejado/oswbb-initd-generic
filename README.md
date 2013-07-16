oswbb-initd-generic
===================

oswbb-initd-generic is a startup/init.d script for Oracle OSWatcher.


#### Tested under

* Solaris 10

##  Requirements

* [Oracle OSWatcher or Oracle OSWatcher Black Box [ID 301137.1]](https://support.oracle.com/epmos/faces/DocContentDisplay?id=301137.1)

## Usage

1. Copy "oswbb" to /etc/init.d/
2. Copy oswbb.conf to /etc/
3. Adjust parameters in /etc/oswbb.conf
4. Copy oswbb-helper.sh to OSW_HOME	
5. Test /etc/init.d/oswbb start/status/stop/info

## Credits
oswbb-initd-generic ported under GPLv2 from [osw-service](https://github.com/megacoder/osw-service) written by Tommy Reynolds <Tommy.Reynolds@MegaCoder.com>

## Changelog
See commits