from unittest import TestCase

from {{ cookiecutter.package_name }} import __version__


class TestVersion(TestCase):
    def test_version(self):
        self.assertEqual(__version__, '{{ cookiecutter.version }}')
