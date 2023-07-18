/* -*- Mode: C; tab-width: 4; indent-tabs-mode: t; c-basic-offset: 4 -*- */
/* nm-openvpn-service - openvpn integration with NetworkManager
 *
 * Copyright (C) 2005 - 2008 Tim Niemueller <tim@niemueller.de>
 * Copyright (C) 2005 - 2008 Dan Williams <dcbw@redhat.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 */

#ifndef NM_OPENVPN_SERVICE_H
#define NM_OPENVPN_SERVICE_H

#define NM_DBUS_SERVICE_OPENVPN    "org.freedesktop.NetworkManager.openvpn"
#define NM_DBUS_INTERFACE_OPENVPN  "org.freedesktop.NetworkManager.openvpn"
#define NM_DBUS_PATH_OPENVPN       "/org/freedesktop/NetworkManager/openvpn"

#define NM_OPENVPN_KEY_AUTH "auth"
#define NM_OPENVPN_KEY_CA "ca"
#define NM_OPENVPN_KEY_CERT "cert"
#define NM_OPENVPN_KEY_CIPHER "cipher"
#define NM_OPENVPN_KEY_KEYSIZE "keysize"
#define NM_OPENVPN_KEY_COMP_LZO "comp-lzo"
#define NM_OPENVPN_KEY_CONNECTION_TYPE "connection-type"
#define NM_OPENVPN_KEY_FLOAT "float"
#define NM_OPENVPN_KEY_FRAGMENT_SIZE "fragment-size"
#define NM_OPENVPN_KEY_KEY "key"
#define NM_OPENVPN_KEY_LOCAL_IP "local-ip" /* ??? */
#define NM_OPENVPN_KEY_MSSFIX "mssfix"
#define NM_OPENVPN_KEY_NS_CERT_TYPE "ns-cert-type"
#define NM_OPENVPN_KEY_PING "ping"
#define NM_OPENVPN_KEY_PING_EXIT "ping-exit"
#define NM_OPENVPN_KEY_PING_RESTART "ping-restart"
#define NM_OPENVPN_KEY_PORT "port"
#define NM_OPENVPN_KEY_PROTO_TCP "proto-tcp"
#define NM_OPENVPN_KEY_PROXY_TYPE "proxy-type"
#define NM_OPENVPN_KEY_PROXY_SERVER "proxy-server"
#define NM_OPENVPN_KEY_PROXY_PORT "proxy-port"
#define NM_OPENVPN_KEY_PROXY_RETRY "proxy-retry"
#define NM_OPENVPN_KEY_HTTP_PROXY_USERNAME "http-proxy-username"
#define NM_OPENVPN_KEY_REMOTE "remote"
#define NM_OPENVPN_KEY_REMOTE_RANDOM "remote-random"
#define NM_OPENVPN_KEY_REMOTE_IP "remote-ip"
#define NM_OPENVPN_KEY_STATIC_KEY "static-key"
#define NM_OPENVPN_KEY_STATIC_KEY_DIRECTION "static-key-direction"
#define NM_OPENVPN_KEY_TA "ta"
#define NM_OPENVPN_KEY_TA_DIR "ta-dir"
#define NM_OPENVPN_KEY_TUNNEL_MTU "tunnel-mtu"
#define NM_OPENVPN_KEY_USERNAME "username"
#define NM_OPENVPN_KEY_TAP_DEV "tap-dev"
#define NM_OPENVPN_KEY_DEV "dev"
#define NM_OPENVPN_KEY_DEV_TYPE "dev-type"
#define NM_OPENVPN_KEY_TUN_IPV6 "tun-ipv6"
#define NM_OPENVPN_KEY_TLS_CIPHER "tls-cipher"
#define NM_OPENVPN_KEY_TLS_CRYPT "tls-crypt"
#define NM_OPENVPN_KEY_TLS_REMOTE "tls-remote"
#define NM_OPENVPN_KEY_VERIFY_X509_NAME "verify-x509-name"
#define NM_OPENVPN_KEY_REMOTE_CERT_TLS "remote-cert-tls"
#define NM_OPENVPN_KEY_MAX_ROUTES "max-routes"

#define NM_OPENVPN_KEY_PASSWORD "password"
#define NM_OPENVPN_KEY_CERTPASS "cert-pass"
#define NM_OPENVPN_KEY_HTTP_PROXY_PASSWORD "http-proxy-password"
/* Internal auth-dialog -> service token indicating that no secrets are
 * required for the connection.
 */
#define NM_OPENVPN_KEY_NOSECRET "no-secret"

#define NM_OPENVPN_KEY_RENEG_SECONDS "reneg-seconds"

#define NM_OPENVPN_AUTH_NONE "none"
#define NM_OPENVPN_AUTH_RSA_MD4 "RSA-MD4"
#define NM_OPENVPN_AUTH_MD5  "MD5"
#define NM_OPENVPN_AUTH_SHA1 "SHA1"
#define NM_OPENVPN_AUTH_SHA224 "SHA224"
#define NM_OPENVPN_AUTH_SHA256 "SHA256"
#define NM_OPENVPN_AUTH_SHA384 "SHA384"
#define NM_OPENVPN_AUTH_SHA512 "SHA512"
#define NM_OPENVPN_AUTH_RIPEMD160 "RIPEMD160"

#define NM_OPENVPN_CONTYPE_TLS          "tls"
#define NM_OPENVPN_CONTYPE_STATIC_KEY   "static-key"
#define NM_OPENVPN_CONTYPE_PASSWORD     "password"
#define NM_OPENVPN_CONTYPE_PASSWORD_TLS "password-tls"

/* arguments of "--remote-cert-tls" */
#define NM_OPENVPN_REM_CERT_TLS_CLIENT "client"
#define NM_OPENVPN_REM_CERT_TLS_SERVER "server"

/* arguments of "--ns-cert-type" */
#define NM_OPENVPN_NS_CERT_TYPE_CLIENT "client"
#define NM_OPENVPN_NS_CERT_TYPE_SERVER "server"

/* possible types for verify-x509-name */
#define NM_OPENVPN_VERIFY_X509_NAME_TYPE_SUBJECT     "subject"
#define NM_OPENVPN_VERIFY_X509_NAME_TYPE_NAME        "name"
#define NM_OPENVPN_VERIFY_X509_NAME_TYPE_NAME_PREFIX "name-prefix"

#endif /* NM_OPENVPN_SERVICE_H */
