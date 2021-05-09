# Generic docker systemd service deploy

Creates a systemd unit file that manages a docker image.

## Cloning this repository

Since this repository has
[git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules), after
cloning the repository you'll have to

```bash
git submodule init
git submodule update
```

Alternatively you can clone it using

```bash
git clone --recurse-submodules -j8 {repo_url}
```

## Compatibility

These are the tested GNU/Linux distributions. Maybe it works on some other
distributions too or just requieres a few changes.

* [Debian](https://www.debian.org/)
  * buster
* [Ubuntu](https://ubuntu.com/)
  * latest

## Requirements

In your local machine:

```bash
pip install -r requirements.txt
```

## Role Variables

* `enable_db`: Boolean to enable database container deployment.
* `enable_redis`: Boolean to enable Redis container deployment.
* `create_user_and_db`: Boolean to enable the creation of a DB and a user. Only
  works with `mariadb` and `mongo` database backends.
* `create_network`: Boolean to enable docker network creation for the service
   and the DB.
* `docker_service_prefix`: Prefix for the in-docker services.
   This is useful to be able to restart all of them with one command:
   `systemctl restart docker.*`
* `service_name`: Name of the systemd service.
* `method`: `pull` or `build` to get the docker image.
* `service_pre_command`: Command to run before the `docker_command` one. Pull
  or build generally. Add `-` at the beginning of the command if you don't want
  the service start up to fail if this command fails.
* `service_db_name`: Name of the systemd DB service.
* `docker_network_name`: Name of the docker network for the service and DB.
* `docker_image`: Name of the docker image to launch as a service.
* `docker_db_image`: Name of the docker image to launch as the service's DB.
  Use the debian based one for postgres.
* `docker_redis_image`: Name of the docker image to launch as the service's
  Redis.
* `docker_command`: Docker command used to launch the container.
* `docker_service_volume_name`: Name of the docker volume for the service.
* `db_type`: `mariadb` (default), `postgres` or mongo.
* `docker_service_directory_db`: Path for the postgres/mongo db data.
* `db_pass`: Root password for the DB.
* `db_user_pass`: User password for the DB.
* `db_config_port`: Host port that will be binded for the DB setup.
* `db_name`: Name of the DB that will be created.
* `db_user`: Name of the user that will own the created DB.
* `db_expose_port`: Port to be exposed of the db.
* `docker_service_directory_redis`: Path for the Redis data.

## Dependencies

`sudo` and `python` in the target host(s). Also  a directory for the database data owned by the user with **gid** and **uid**
   **1000**. Specify it in the variable `docker_service_directory_db`.

## Example Playbook

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
    docker_db_image: postgres
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

If you are using mongo:

```yaml
- name: '[Pretask] Create directories'
  hosts: all
  vars:
    db_type: mongo
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
    db_type: mongo
    docker_db_image: mongo
    docker_service_directory_db: /data/hello-world/db
    db_user_pass: 'changeme'
    db_config_port: 27017
    db_name: hello-world
    db_user: hello-world
    service_name: hello-world
    docker_image: hello-world
    docker_command: /usr/bin/docker run --rm -i --name "{{ service_name }}" "{{ docker_image }}"
  roles:
    - role: generic_docker_systemd
```

## Testing

To test the role you need [molecule](http://molecule.readthedocs.io/en/latest/),
**vagrant**, **virtualbox** and some python requirements that can be installed wwith
`pip install -r requirements-dev.txt`.

There are too scenarios depending on the posible database backend, to test both
of them use:

```bash
molecule test -s default
molecule test -s postgres
molecule test -s mongo
```

There is more documentation about the installation and configuration of the
required tools at
[Testing - Anarres documentation](https://anarres-org.github.io/anarres/testing/).

## License

GPLv3

## Author Information

* m0wer: m0wer (at) autistici (dot) org
