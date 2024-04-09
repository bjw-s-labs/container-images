ARG VERSION
FROM ghcr.io/paperless-ngx/paperless-ngx:$VERSION as paperless

COPY scripts/settings_ldap.py /usr/src/paperless/src/paperless/settings_ldap.py

ENV DJANGO_SETTINGS_MODULE "paperless.settings_ldap"
ENV PAPERLESS_LDAP_PIP_INSTALL "true"

ENV PAPERLESS_LDAP_AUTH_ENABLED "false"
ENV PAPERLESS_LDAP_AUTH_URL "ldap://ldap.example.com:389"
ENV PAPERLESS_LDAP_AUTH_CONNECTION_USERNAME ""
ENV PAPERLESS_LDAP_AUTH_CONNECTION_PASSWORD ""
ENV PAPERLESS_LDAP_AUTH_SEARCH_BASE "ou=people,dc=example,dc=com"
ENV PAPERLESS_LDAP_UID_FORMAT "uid=%s,ou=people,dc=example,dc=com"
ENV PAPERLESS_LDAP_USER_GROUP "cn=paperless_user,ou=groups,dc=example,dc=com"
ENV PAPERLESS_LDAP_ADMIN_GROUP "cn=paperless_admin,ou=groups,dc=example,dc=com"
ENV PAPERLESS_LDAP_LLDAP_FIX "false"
