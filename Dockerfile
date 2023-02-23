FROM ocaml/opam:alpine-3.17-ocaml-4.14 as builder

RUN opam repo add opam git+https://github.com/ocaml/opam-repository
RUN opam install dune

USER root
RUN apk add --no-cache libev-dev gmp-dev pkgconfig libpq-dev openssl-dev cmake

USER opam

COPY --chown=opam muhokama.opam /build/muhokama.opam

RUN cd /build && opam install . --locked --deps-only --with-test -y

COPY --chown=opam . /build/

RUN cd /build && opam exec -- dune build

FROM alpine:3.17.1 as final

RUN apk add --no-cache libev-dev gmp-dev libpq-dev openssl-dev cmake

EXPOSE 4000

WORKDIR /app

ADD assets /app/assets
ADD migrations /app/migrations

COPY --from=builder /build/bin/muhokama.exe /usr/bin/muhokama.exe

CMD muhokama.exe db.migrate && muhokama.exe server.launch
