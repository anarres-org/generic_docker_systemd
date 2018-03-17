Generic docker systemd service deploy
=====================================

Creates a systemd unit file that manages a docker image.

Requirements
------------

* Pip installed on host
* Docker installed on the host

Role Variables
--------------

* `docker_data_directories`: List of directories where the data is going to be
  saved on the host.
* `service_name`: Name of the systemd service.
* `docker_image`: Name of the docker image to launch.
* `docker_command`: Docker command used to launch the container.

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
