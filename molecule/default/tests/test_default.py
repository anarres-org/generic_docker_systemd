import os
import pytest
import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


@pytest.mark.parametrize("package", [
    ("docker-ce"),
    ("python-pip"),
])
def test_required_packages_exist(host, package):
    pkg = host.package(package)
    assert pkg.is_installed


@pytest.mark.parametrize("pip_package", [
    ("docker-py"),
])
def test_required_pip_packages_exist(host, pip_package):
    pip_packages = host.pip_package.get_packages()
    assert pip_package in pip_packages


@pytest.mark.parametrize("directories", [
    ("/root/docker/hello-world/data"),
])
def test_check_directories(host, directories):
    with host.sudo():
        directory = host.file(directories)
        assert directory.exists
        assert directory.user == 'root'
        assert directory.group == 'root'
        assert oct(directory.mode) == '0700'


def test_image_nginx_is_enabled_and_running(host):
    service = host.service('hello-world')
    assert service.is_enabled
    assert service.is_running
