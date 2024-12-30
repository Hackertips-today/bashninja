function chkASN() (echo;echo "checking announced prefixes for ASN$1";curl "https://www.whatismyip.com/asn/$1/" -A "x" -s |html2text | grep '\/' )
