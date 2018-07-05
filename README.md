Generic docker systemd service deploy
=====================================

Creates a systemd unit file that manages a docker image.

Requirements
------------

* Pip installed on host
* Docker installed on the host
* `python-mysqldb`

Role Variables
--------------

* `enable_db`: Boolean to enable database container deployment.
* `create_user_and_db`: Boolean to enable the creation of a DB and a user.
* `create_network`: Boolean to enable docker network creation for the service
and the DB.
* `create_volume`: Boolean to enable the creation of a volume for the service
container.
* `docker_service_prefix`: Prefix for the in-docker services.
	This is usuful to be able to restart all of them with one command:
	`systemctl restart docker.*`
* `service_name`: Name of the systemd service.
* `service_db_name`: Name of the systemd DB service.
* `docker_network_name`: Name of the docker network for the service and DB.
* `docker_image`: Name of the docker image to launch as a service.
* `docker_db_image`: Name of the docker image to launch as the service's DB.
* `docker_command`: Docker command used to launch the container.
* `docker_service_volume_name`: Name of the docker volume for the service.
* `docker_service_db_volume_name`: Name of the docker volume for the DB.
* `db_pass`: Root password for the DB.
* `db_user_pass`: User password for the DB.
* `db_config_port`: Host port that will be binded for the DB setup.
* `db_name`: Name of the DB that will be created.
* `db_user`: Name of the user that will own the created DB.

Dependencies
------------

None.

Example Playbook
----------------

```yaml
- name: Deploy the docker image managed by a systemd service
  hosts: all
  vars:
    docker_data_directories:
      - "/root/docker/hello-world/data"
    service_name: hello-world
    docker_image: hello-world
    docker_command: /usr/bin/docker run --rm -i --name "{{ service_name }}" "{{ docker_image }}"
  roles:
    - role: generic_docker_systemd
```

Testing
-------

To test the role you need [molecule](http://molecule.readthedocs.io/en/latest/).

And vagrant installed with VirtualBox.

```bash
molecule test
```

License
-------

GPLv3

Author Information
------------------

m0wer [ at ] autistici.org
