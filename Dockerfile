FROM osixia/light-baseimage:1.1.1
ARG LDAP_OPENLDAP_GID
ARG LDAP_OPENLDAP_UID

RUN if [ -z "${LDAP_OPENLDAP_GID" ];  then groupadd -r openldap; else groupadd -r -g ${LDAP_OPENLDAP_GID} openldap; fi && if [ -z "${LDAP_OPENLDAP_UID}" ]; then useradd -r -g openldap openldap; else useradd -r -g openldap -u ${LDAP_OPENLDAP_UID} openldap; fi

RUN echo "path-include /usr/share/doc/krb5*" >> /etc/dpkg/dpkg.cfg.d/docker && apt-get -y update && /container/tool/add-service-available :ssl-tool \
	&& LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
ldap-utils \
libsasl2-modules \
libsasl2-modules-db \
libsasl2-modules-gssapi-mit \
libsasl2-modules-ldap \
libsasl2-modules-otp \
libsasl2-modules-sql \
openssl \
slapd \
krb5-kdc-ldap \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD service /container/service
RUN /container/tool/install-service
ADD environment /container/environment/99-default
EXPOSE 389 636
