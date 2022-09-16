from unittest import TestCase

from {{ cookiecutter.package_name }} import __version__


class VersionTest(TestCase):
    def test_version(self) -> None:
        self.assertEqual(__version__, '{{ cookiecutter.version }}')
