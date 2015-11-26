FROM ubuntu:14.04

ENV deps \
    build-essential \
    libtool \
    autoconf \
    pkg-config \
    libssl-dev \
    git \
    python \
    perl

WORKDIR /tmp/ovs
RUN \
apt-get update \
&& apt-get install -y python-flask \
&& apt-get install -y ${deps} \
&& git clone https://github.com/openvswitch/ovs /tmp/ovs \
&& ./boot.sh \
&& ./configure --localstatedir="/var" --sysconfdir="/etc" --prefix="/usr" --enable-ssl \
&& make install \
&& apt-get remove --purge -y $deps \
&& apt-get autoremove -y --purge \
&& rm -rf /var/lib/apt/lists/* \
&& rm -rf /tmp/ovs \
&& ovsdb-tool create /etc/openvswitch/conf.db /usr/share/openvswitch/vswitch.ovsschema \
&& ovsdb-tool create /etc/openvswitch/ovnnb.db /usr/share/openvswitch/ovn-nb.ovsschema \
&& ovsdb-tool create /etc/openvswitch/ovnsb.db /usr/share/openvswitch/ovn-sb.ovsschema

VOLUME ["/var/log/openvswitch", "/var/lib/openvswitch", "/var/run/openvswitch", "/etc/openvswitch"]
