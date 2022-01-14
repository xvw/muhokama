.PHONY: all build clean check-lint lint doc utop dev-deps deps init-database test

all: build

# Compiles the libraries and binaries needed to start the server.
build:
	dune build

# Run tests
test:
	dune runtest --no-buffer -j 1

# Cleans up compilation artefacts
clean:
	dune clean

# Checks that the code is properly formatted
check-lint:
	dune build @fmt


# Apply the formatter to the code
lint:
	dune build @fmt --auto-promote

# Builds documentation
doc:
	dune build @doc

# Run a REPL (UTop) with the dependencies and libraries accessible
# in the scope
utop:
	dune utop

# Retreive dependencies
deps:
	opam install . --deps-only --with-doc --with-test -y
	opam install preface -y

# Retrieves development dependencies
dev-deps:
	opam install dune merlin ocamlformat ocp-indent utop -y

# Initialize a databases
init-database:
	createuser -sPE muhokama
	createdb -O muhokama muhokama_dev
	createdb -O muhokama muhokama_test
