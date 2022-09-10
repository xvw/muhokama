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
opam update
opam switch create . ocaml-base-compiler.4.14.0 --deps-only -y
eval $(opam env)
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
export POSTGRESQL_ADDON_HOST=localhost
export POSTGRESQL_ADDON_PORT=5432
export POSTGRESQL_ADDON_DB=muhokama_dev
export POSTGRESQL_ADDON_USER=muhokama
export POSTGRESQL_ADDON_PASSWORD=muhokama
export LOG_LEVEL=debug
export POSTGRESQL_ADDON_CONNECTION_POOL=5
```

### Running integration test

Running integration tests (with the `make test-integration` command) requires
the presence of a `.test_env` file at the root of the project which exports
environment variables specific to running integration tests.


### Interaction using `muhokama.exe`

The main actions are orchestrable via the `muhokama.exe` binary. Once the
project is compiled (using, for example, `make build`) it is impossible to
invoke the tool with `./bin/muhokama.exe PARAMS` or `dune exec bin/muhokama.exe
-- PARAMS`. The second invocation recompiles (if needed) the binary. Each
subcommand can display its `man` page using the `--help` flag.

| Invocation | Description
| -- | -- |
| `./bin/muhokama.exe` | Displays the `man` page of the binary |
| `./bin/muhokama.exe db.migrate` | Builds a migration context and performs missing migrations. (For example, if the migration context is 2 and there are migrations 3, 4, and 5, the invocation will execute migration 3, 4, and 5 if migration 2 has the same hash as migration 2 that was executed.) |
| `./bin/muhokama.exe db.migrate --to N` | Replaces the migration state according to the given parameter `N`. If for example the current state is `5`, `./bin/muhokama.exe db.migrate --to 2` will play `5.down`, `4.down` and `3.down`. If, on the other hand, the current state is `0`, `1.up`, and `2.up` will be played. If no error has occurred, the state must be the argument given to `--to`. |
| `./bin/muhokama.exe db.migrate.reset` | Removes the migration context (in database). . |
| `./bin/muhokama.exe server.launch`| Starts the application on the default port (`4000`). It is possible to add the `--port X` flag to change this value. |
| `./bin/muhokama.exe user.list` | Lists all registered users (regardless of their status) |
| `./bin/muhokama.exe user.set-state -U USER_ID -S USER_STATE` | Changes the status (`inactive`, ` member`,  `moderator` `admin`) of a user via its ID ( `UUID` ). |

### Deploy on clever cloud

1. Create a docker application with a postgreSQL add-on
2. Add the following environment variable to the docker application
  - CC_DOCKER_EXPOSED_HTTP_PORT="4000"
  - PGSQL_CONNECTION_POOL="5"

> "5" is the maximum connections for free databases, you can adapt `PGSQL_CONNECTION_POOL` in accordance to the [pool of your plan](https://www.clever-cloud.com/doc/deploy/addon/postgresql/postgresql/#plans)

3. In **Information** of the docker application, check the following options:
  - Zero downtime deployment
  - Enable dedicated build instance (Must be minimum S)
  - Cancel ongoing deployment on new push
  - Force HTTPS

4. Add a git remote `git remote add clever <Deployment URL>`

5. Push your first deployment `git push clever main:master`