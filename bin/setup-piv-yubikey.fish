#!/usr/local/bin/fish

set -x mgm (dd if=/dev/random bs=1 count=24 2>/dev/null | hexdump -v -e '/1 "%02X"')
ykman piv reset
ykman piv change-management-key -m 010203040506070801020304050607080102030405060708 -n $mgm
ykman piv generate-key -m $mgm --touch-policy=always 9a -
ykman piv attest 9a /tmp/9acert.pem
ykman piv import-certificate -m $mgm 9a /tmp/9acert.pem
ykman piv set-chuid -m $mgm
ykman piv set-ccc -m $mgm
ykman piv change-puk -p 12345678 -n (openssl rand -base64 6)
ykman piv change-pin -P 123456
