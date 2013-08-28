#!/bin/sh
dir="/tmp/"
update=""
proxy="antizapret.prostovpn.org:3128"
repo="https://github.com/zapret-info/z-i.git"

cd $dir

if [ ! -d $dir"z-i/.git" ]; then
	git clone "$repo"
else
	update=$(git pull)
fi

cd z-i/

if [ "$update" != "Already up-to-date." ]; then
	cat << "EOF" > proxy.pac
function FindProxyForURL(url, host) {
	blockedarray = [
EOF
	for i in $(cut -d ";" -s -f1 dump.csv | sort | uniq);
	do
		echo "\t\""$i"\"," >> proxy.pac
	done
	cat << "EOF" >> proxy.pac
	];
	if (blockedarray.indexOf(dnsResolve(host)) != -1) {
		return "PROXY $proxy";
	}
	return "DIRECT";
}
EOF
fi	





