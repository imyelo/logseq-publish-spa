FROM cimg/clojure:1.11-node

ARG LOGSEQ_PUBLISH_SPA_VERSION=v0.3.1
ARG LOGSEQ_VERSION=0.10.6

WORKDIR /home/circleci/project

RUN cd /home/circleci \
  && git clone https://github.com/logseq/publish-spa --branch $LOGSEQ_PUBLISH_SPA_VERSION --depth 1 \
  && cd publish-spa \
  && yarn install \
  && chmod +x ./publish_spa.mjs \
  && ln -s /home/circleci/publish-spa/publish_spa.mjs /home/circleci/bin/logseq-publish-spa

RUN cd /home/circleci \
  && git clone https://github.com/logseq/logseq --branch $LOGSEQ_VERSION --depth 1 \
  && cd logseq \
  && yarn install --frozen-lockfile \
  && yarn gulp:build \
  && clojure -M:cljs release publishing
