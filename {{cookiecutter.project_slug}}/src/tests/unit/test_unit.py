from {{ cookiecutter.package_name }}.hello import hello


def test_hello() -> None:
    assert hello('World') == 'Hello, World!'
