# ISCBC Docker

A Docker setup for ISCBC website development.

## Usage

1. Clone this repo
    ```sh
    $ cd path/to/project
    $ git clone <repo> .
    ```

2. Build & start the docker containers
    ```sh
    $ docker-compose up
    # OR
    $ npm start # alias
    ```

That's it. (_so far_)

> **NOTE:** If there isn't a folder named `/app` with an existing WordPress install, docker will create one.

<!-- 
1. Download submodules (in this case just the website repo)
    ```sh
    $ git submodule init
    ``` -->

## Commands

The following are some helpful commands for working with the Docker containers. Your docker containers may have different names, in which case you can use the `docker ps` command to see any currently running docker containers.

### WP-CLI

The WordPress Command Line Interface is installed on the Apache container. To access it, you can use the following command (assuming `iscbc_wp_1` as the container name):

```sh
$ docker exec -it --user=dev iscbc_wp_1 bash
```

This starts an interactive bash session in the container as the "dev" user, which will stop WP-CLI from chastising you for running it as the root user.

For example, the wp-sync-db plugin breaks when `WP_DEBUG` is enabled and &mdash; as this is a development environment &mdash; `WP_DEBUG` is enabled by default. Either you can stop the servers and change the settings in `docker-compose.yml`, or just disable it frm the command line:

```sh
$ docker exec -it --user=dev iscbc_wp_1 bash
dev@<container id> $ wp config set WP_DEBUG false --raw
# later...
dev@<container id> $ wp config set WP_DEBUG true --raw
```

> **NOTE:** Actually don't use WP-CLI for this *specific* use-case, WP_DEBUG is set on the fly from the `WP_DEBUG` environment variable. Change that with
> ```sh
> $ $WP_DEBUG = 0 # for false, 1 for true
> ```

### Rebuilding Containers

You may find you need to rebuild your containers if things go pear-shaped:

```sh
$ docker-compose up --force-recreate --build
# OR
$ npm run rebuild # alias
```

If you need to tear down everything including the database, do the following first:

```sh
$ docker-compose down
# OR
$ npm run teardown # alias
```