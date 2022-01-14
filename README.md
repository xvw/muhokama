# Muhokama

> Muhokama (which means "_discussion_" in Uzbek) is a web application that
> powers a rudimentary forum because Slack, Discord and IRC are, in our opinion,
> not very suitable for long conversations and message tracking.

## Getting started

**Muhokama** is an [OCaml](https;//ocaml.org) application (`>= 4.13.1`), so it
needs [to be installed](https://ocaml.org/learn/tutorials/up_and_running.html).
And for lack of originality the application is based on a
[PostgreSQL](https://www.postgresql.org/) database (which must be installed and
properly configured). For the sake of comfort,
[GNU/Make](https://www.gnu.org/software/make/) is an optional but recommended
addiction. (All examples in this tutorial assume that `make` is available).

Once the repository is locally cloned, go to the root of the project. To locate
all dependencies at the root of the project (locally) rather than globally,
[creating a local switch](https://opam.ocaml.org/doc/Usage.html#opam-switch) is
recommended:

``` shellsession
opam switch create . ocaml-base-compiler.4.13.1 -y
```

When the _local switch build procedure_ is complete you can simply run the
following two commands to retrieve the project dependencies and to retrieve the
development dependencies (the second one is optional):

``` shellsession
make deps
make dev-deps
```

### Initialization of the database

Assuming a role has been created for the current user, you can simply issue the
command `make init-database` which will create a user `muhokama` and and ask for
a password to be entered in a prompter, and two databases:

- `muhokama_dev`: the database populated by the development server to test the
  application locally;
- `muhokama_test`: the database used for the integration tests.

The configuration is provisioned by environment variables: 

``` sh
export PGSQL_HOST=localhost
export PGSQL_PORT=5432
export PGSQL_DB_DEV=muhokama_dev
export PGSQL_DB_TEST=muhokama_test
export PGSQL_USER=muhokama
export PGSQL_PASS=muhokama
export LOG_LEVEL=debug
```

