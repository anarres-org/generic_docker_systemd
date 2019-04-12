Generic docker systemd service deploy
=====================================

Creates a systemd unit file that manages a docker image.

Requirements
------------

* Pip installed on host
* Docker installed on the host
* `python-mysqldb`
* If you use postgres as a database (not the default mariadb), create a
  directory of the database data owned by the user with **gid** and **uid**
  **1000**. Specify it in the variable `docker_service_directory_db`.

Role Variables
--------------

* `enable_db`: Boolean to enable database container deployment.
* `create_user_and_db`: Boolean to enable the creation of a DB and a user.
* `create_network`: Boolean to enable docker network creation for the service
   and the DB.
* `create_volume`: Boolean to enable the creation of a volume for the service
   container.
* `docker_service_prefix`: Prefix for the in-docker services.
   This is useful to be able to restart all of them with one command:
   `systemctl restart docker.*`
* `service_name`: Name of the systemd service.
* `service_pre_command`: Command to run before the `docker_command` one. Pull
  or build generally. Add `-` at the beginning of the command if you don't want
  the service start to fail if this command fails.
* `service_db_name`: Name of the systemd DB service.
* `docker_network_name`: Name of the docker network for the service and DB.
* `docker_image`: Name of the docker image to launch as a service.
* `docker_db_image`: Name of the docker image to launch as the service's DB.
  Use the debian based one for postgres.
* `docker_command`: Docker command used to launch the container.
* `docker_service_volume_name`: Name of the docker volume for the service.
* `docker_service_db_volume_name`: Name of the docker volume for the DB.
* `db_type`: `mariadb` (default) or `postgres`.
* `docker_service_directory_db`: Path for the postgres db data.
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
    db_type: mariadb
    db_pass: 'changeme'
    db_user_pass: 'changeme'
    db_config_port: 3306
    db_name: hello-world
    db_user: hello-world
    service_name: hello-world
    docker_image: hello-world
    docker_command: /usr/bin/docker run --rm -i --name "{{ service_name }}" "{{ docker_image }}"
  roles:
    - role: generic_docker_systemd
```

If you are using postgres, you can use the following task to create the
required directory:

```yaml
- name: '[Pretask] Create directories'
  hosts: all
  vars:
    db_type: postgres
    docker_service_directory_db: /data/hello-world/db
  tasks:
    - name: Create db data directory
      file:
        path: "{{ docker_service_directory_db }}"
        state: directory
        owner: [user with uid 1000]
        group: [group with gid 1000]
        mode: 0700

- name: Deploy the docker image managed by a systemd service
  hosts: all
  vars:
    db_type: postgres
    docker_service_directory_db: /data/hello-world/db
    db_user_pass: 'changeme'
    db_config_port: 5432
    db_name: hello-world
    db_user: hello-world
    service_name: hello-world
    docker_image: hello-world
    docker_command: /usr/bin/docker run --rm -i --name "{{ service_name }}" "{{ docker_image }}"
  roles:
    - role: generic_docker_systemd
```

Testing
-------

To test the role you need
[molecule](http://molecule.readthedocs.io/en/latest/). And vagrant installed
with VirtualBox.

There are too scenarios depending on the posible database backend, to test both
of them use:

```bash
molecule test -s default
molecule test -s postgres
```

License
-------

GPLv3

Author Information
------------------

m0wer (at) autistici.org
