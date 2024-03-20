# syntax=docker/dockerfile:1.0

## logseq

FROM cimg/clojure:1.11-node as logseq

ARG LOGSEQ_VERSION=0.10.6

RUN git clone https://github.com/logseq/logseq --branch $LOGSEQ_VERSION --depth 1 /tmp/logseq
WORKDIR /tmp/logseq
RUN yarn install --frozen-lockfile
RUN yarn gulp:build
RUN clojure -M:cljs release publishing

## logseq-publish-spa

FROM cimg/clojure:1.11-node

ARG LOGSEQ_PUBLISH_SPA_VERSION=v0.3.1

USER root

COPY --from=logseq /tmp/logseq/static /opt/logseq/static

RUN git clone https://github.com/logseq/publish-spa --branch $LOGSEQ_PUBLISH_SPA_VERSION --depth 1 /opt/logseq-publish-spa
WORKDIR /opt/logseq-publish-spa 
RUN yarn install
RUN yarn global add $(pwd)

RUN mkdir -p /tmp/refresh-cache && cd /tmp/refresh-cache && logseq-publish-spa public -s /opt/logseq/static || true

WORKDIR /home/circleci/project
