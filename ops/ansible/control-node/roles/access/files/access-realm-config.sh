#!/bin/bash
set -ex

/opt/jboss/keycloak/bin/kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user "$KEYCLOAK_USER" --password "$KEYCLOAK_PASSWORD" --client admin-cli

/opt/jboss/keycloak/bin/kcadm.sh create realms -s realm=access -s enabled=true -s actionTokenGeneratedByAdminLifespan=432000 -s emailTheme=access -o

/opt/jboss/keycloak/bin/kcadm.sh create clients -r access -s clientId=course-service -s bearerOnly=true -s 'redirectUris=["*"]' -i

/opt/jboss/keycloak/bin/kcadm.sh create clients -r access  -b '{ "clientId": "access-frontend", "publicClient": true, "redirectUris": ["*"], "webOrigins": ["*"], "protocolMappers": [{ "name": "Course service audience", "protocol": "openid-connect", "protocolMapper": "oidc-audience-mapper", "config": { "included.client.audience": "course-service", "id.token.claim": "false", "access.token.claim": "true" } }, { "name": "Groups", "protocol": "openid-connect", "protocolMapper": "oidc-group-membership-mapper", "config": { "full.path": "true", "id.token.claim": "true", "access.token.claim": "true", "userinfo.token.claim": "true", "claim.name": "groups" } }] }'

