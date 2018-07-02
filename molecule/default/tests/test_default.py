import os
import pytest
import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_dummy_service_conf(host):
    service_conf = host.file("/etc/systemd/system/docker.dummy.service")
    assert service_conf.exists
    assert service_conf.contains("/bin/docker run")
    assert service_conf.user == "root"
    assert service_conf.group == "root"


def test_dummy_db_service_conf(host):
    service_conf_db = host.file("/etc/systemd/system/docker.dummy-db.service")
    assert service_conf_db.exists
    assert service_conf_db.contains("/bin/docker run")
    assert service_conf_db.user == "root"
    assert service_conf_db.group == "root"


def test_dummy_db_service(host):
    dummy_db = host.service("docker.dummy-db.service")
    assert dummy_db.is_enabled
    assert dummy_db.is_running


def test_dummy_service(host):
    dummy = host.service("docker.dummy.service")
    assert dummy.is_enabled
    assert dummy.is_running
