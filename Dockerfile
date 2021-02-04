FROM debian:10

ENV DEBIAN_FRONTEND=noninteractive

# Install NSS
RUN apt-get update && \
  apt-get install -y libnss-ldap samba slapd ldap-utils winbind samba smbldap-tools && \
  rm -rf /var/lib/apt/lists/*

# /etc/nsswitch.conf
RUN file="/etc/nsswitch.conf" && \
	echo 'passwd:         files ldap' > $file && \
	echo 'group:          files ldap' >> $file && \
	echo 'shadow:         files ldap' >> $file && \
	echo 'gshadow:        files' >> $file && \
	echo '' >> $file && \
	echo 'hosts:          files dns' >> $file && \
	echo 'networks:       files' >> $file && \
	echo '' >> $file && \
	echo 'protocols:      db files' >> $file && \
	echo 'services:       db files' >> $file && \
	echo 'ethers:         db files' >> $file && \
	echo 'rpc:            db files' >> $file && \
	echo '' >> $file && \
	echo 'netgroup:       nis' >> $file

COPY pam.d_samba /etc/pam.d/samba

COPY libnss-ldap.conf /config/libnss-ldap.conf

COPY smb.conf /config/smb.conf

COPY start.sh /usr/bin/

RUN chmod 755 /usr/bin/start.sh

EXPOSE 137/udp 138/udp 139 445

CMD start.sh
