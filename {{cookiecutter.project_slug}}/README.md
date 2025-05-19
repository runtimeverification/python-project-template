# {{ cookiecutter.project_name }}


## Installation

Prerequsites: `python >= 3.10`, [`uv`](https://docs.astral.sh/uv/).

```bash
make build
pip install dist/*.whl
```


## For Developers

Use `make` to run common tasks (see the [Makefile](Makefile) for a complete list of available targets).

* `make build`: Build wheel
* `make check`: Check code style
* `make format`: Format code
* `make test-unit`: Run unit tests
* `make test-integration`: Run integration tests

## Considerations
If you use git submodules that are not required for building the project with `nix`, then you should add these directories to the `gitignoreSourcePure` list in `nix/default.nix`, see the respective left-over `TODO` in the nix file. Otherwise, the nix build that is uploaded to the nix binary cache by CI might not match the version that is requested by `kup`, in case this project is offered as a package by `kup`. This is due to weird behaviour in regards to git submodules by `git` and `nix`, where a submodule directory might exist and be empty or instead not exist, which impacts the resulting nix hash, which is of impartance when offering/downloading cached nix derivations.
