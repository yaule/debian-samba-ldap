# run

**使用默认配置**

默认配置效果：

   - 用户个人存储目录

   - 共享存储目录访问

   - 关闭访客访问


```sh

docker run --rm -it -p 445:445 -p 139:139 --name samba \
    -e SAMBA_LDAP_HOST=127.0.0.1 \
    -e SAMBA_LDAP_BASE_DN='dc=samba,dc=com' \
    -e SAMBA_LDAP_ADMIN_DN="cn=admin,dc=samba,dc=com" \
    -e SAMBA_LDAP_DOMAIN='samba.com' \
    -e SAMBA_LDAP_PASSWORD='password' \
    -v $(pwd)/share:/mnt/share \
    -v $(pwd)/home:/home/users kasen/samba-ldap

```

**使用自定义配置**

```sh
docker run --rm -it -p 445:445 -p 139:139 --name samba \
    -v $(pwd)/libnss-ldap.conf:/etc/libnss-ldap.conf:ro \
    -v $(pwd)/smb.conf:/etc/samba/smb.conf:ro \
    -v $(pwd)/share:/mnt/share \
    -v $(pwd)/home:/home/users \
    -e SAMBA_LDAP_PASSWORD='password' kasen/samba-ldap
```
