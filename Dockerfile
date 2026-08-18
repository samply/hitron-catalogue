FROM node:22-alpine AS frontend

RUN apk add --no-cache git
RUN git clone --depth 1 --branch v11.20.2 \
    https://github.com/molgenis/molgenis-emx2.git /build/emx2

COPY hitron-catalogue/ /build/emx2/apps/hitron-catalogue/
RUN sed -i '/"workspaces": \[/a\    "hitron-catalogue",' \
    /build/emx2/apps/package.json

WORKDIR /build/emx2/apps
RUN yarn install --non-interactive \
    && yarn workspace molgenis-components build \
    && yarn workspace hitron-catalogue build

FROM molgenis/molgenis-emx2:11.20.2

COPY --from=frontend /build/emx2/apps/hitron-catalogue/dist/ /tmp/public_html/apps/hitron-catalogue/
# EMX2 serves apps from its JAR; use zip because `jar --update` rejects a
# newer module descriptor embedded in the legacy 11.20.2 fat JAR.
RUN apt-get update \
    && apt-get install --yes --no-install-recommends zip \
    && cd /tmp \
    && zip -q -r /app.jar public_html/apps/hitron-catalogue \
    && rm -rf /tmp/public_html /var/lib/apt/lists/* \
    && apt-get purge --yes --auto-remove zip
