#!/usr/bin/env bash
set -x -e
SECRET="/var/lib/samba/private/secrets.tdb"

if [[ -n $SAMBA_LDAP_HOST ]] && [[ -n $SAMBA_LDAP_BASE_DN ]] && [[ -n $SAMBA_LDAP_ADMIN_DN ]] && [[ -n $SAMBA_LDAP_DOMAIN ]] ; then

    if [[ -z $SAMBA_LDAP_HOST ]] ; then
        echo "ERROR: $SAMBA_LDAP_HOST does not exists"
        exit 15
    fi
    if [[ -z $SAMBA_LDAP_BASE_DN ]] ; then
        echo "ERROR: $SAMBA_LDAP_BASE_DN does not exists"
        exit 15
    fi
    if [[ -z $SAMBA_LDAP_ADMIN_DN ]] ; then
        echo "ERROR: $SAMBA_LDAP_ADMIN_DN does not exists"
        exit 15
    fi
    if [[ -z $SAMBA_LDAP_DOMAIN ]] ; then
        echo "ERROR: $SAMBA_LDAP_DOMAIN does not exists"
        exit 15
    fi

    eval "cat <<EOF
$(</config/smb.conf)
EOF" 2>/dev/null >/etc/samba/smb.conf

    eval "cat <<EOF
$(</config/libnss-ldap.conf)
EOF" 2>/dev/null >/etc/libnss-ldap.conf

fi

if [[ -z "${SAMBA_LDAP_PASSWORD}" ]]; then
    echo "ERROR: Environment variable SAMBA_LDAP_PASSWORD not set"
    exit 17
else
    smbpasswd -w $SAMBA_LDAP_PASSWORD
fi
if [[ ! -e $SECRET ]] ; then
    echo "ERROR: $SECRET does not exists"
    exit 15
fi

if [[ $# -ge 1 && -x $(which $1 2>&-) ]]; then
    exec "$@"
elif [[ $# -ge 1 ]]; then
    echo "ERROR: command not found: $1"
    exit 13
elif ps -ef | egrep -v grep | grep -q smbd; then
    echo "Service already running, please restart container to apply changes"
else
    [[ ${NMBD:-""} ]] && ionice -c 3 nmbd -D
    exec ionice -c 3 smbd -FS </dev/null
fi
