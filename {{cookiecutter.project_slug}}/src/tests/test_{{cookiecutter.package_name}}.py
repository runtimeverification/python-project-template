from {{ cookiecutter.package_name }} import __version__


def test_version() -> None:
    assert __version__ == '{{ cookiecutter.version }}'
