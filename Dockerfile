FROM ocaml/opam:alpine-ocaml-4.14 as builder

RUN opam repo add opam git+https://github.com/ocaml/opam-repository
RUN opam install dune

USER root
RUN apk add --no-cache libev-dev gmp-dev pkgconfig libpq-dev libressl-dev

USER opam

COPY --chown=opam muhokama.opam /build/muhokama.opam

RUN cd /build && opam install . --deps-only --with-test -y

COPY --chown=opam . /build/

RUN cd /build && opam exec -- dune build

FROM alpine:3 as final

RUN apk add --no-cache libev-dev gmp-dev libpq-dev libressl-dev

ENV LOG_LEVEL=info
ENV PGSQL_CONNECTION_POOL=20

EXPOSE 4000

WORKDIR /app

ADD assets /app/assets
ADD migrations /app/migrations

COPY --from=builder /build/bin/muhokama.exe /usr/bin/muhokama.exe

ENTRYPOINT [ "muhokama.exe" ]
CMD [ "server.launch" ]