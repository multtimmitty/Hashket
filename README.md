# hashket
-----------

***this is a simple script that check the integrity of the files***, checking its integrity used
the hash *md5, sha1, sha224, sha256, sha284, sha512*.

***tested on termux and debian based distributions***

### Note

for show the help menu used the parameter -h or --help.

	./hashket.sh --help

### Use Mode

Mainly give execute permissions to the script using

	chmod u+x hashket.sh


Run the script using

	./hashket.sh

### Examples

***To generate a hashof any file use the following parameters***

	./hashket.sh -g <hash type> -f <fie path>


***To check the hash of a downloaded file***

	./hashket.sh -c <hash provided by the site> -f <file path>

##### Dependencies

*The script uses*

***md5sum, sha1sum, sha224sum, sha256sum, sha284sum, sha512sum***.
