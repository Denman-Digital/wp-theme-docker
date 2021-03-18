# WP Theme Docker

A Docker setup for WordPress theme development.

## Requirements

- [Docker Desktop](https://www.docker.com/products/docker-desktop)

## Usage

1. Clone this repo next to the theme folder:
    ```sh
    cd path/to/project
    git clone https://github.com/Denman-Digital/wp-theme-docker.git docker # the folder name "docker" is optional
    ```

    This should give you a folder structure like this:
    
    ```sh
    project/
    └─┬ docker/
      └ theme/
    ```

    Make sure that your theme folder is either named `theme`, or you update the volumes in the [docker-compose file.](https://github.com/Denman-Digital/wp-theme-docker/blob/main/docker-compose.yml#L30). You'll also want to make sure that the path that it is being mapped to matches the eventual server path for the theme.

2. Build & start the docker containers:
    ```sh
    cd docker
    # THEN
    docker-compose up
    # OR
    npm start # alias
    ```

3. **(Optional, but recommended)**. Delete the `.git` folder.  
   This is just a starting point for a development environment. You'll probably need or want to tweak it for each project, or even each user. Changes you make are _probably_ going to be project-specific and wont need to be pushed upstream, and changes upstream are likely not necessary to pull down, especially if it's already working for you.

That's it. (_so far_)

> **NOTE:** If there isn't a folder named `/app` with an existing WordPress install, docker will create one.

<br>

## Commands

The following are some helpful commands for working with the Docker containers. Your docker containers may have different names, in which case you can use the `docker ps` command to see any currently running docker containers.

### WP-CLI

The WordPress Command Line Interface is installed on the Apache container. To access it, you can use the following command (assuming `project_wp_1` as the container name, change that in the [.env](https://github.com/Denman-Digital/wp-theme-docker/blob/main/.env) file):

```sh
docker exec -it --user=dev project_wp_1 bash
```

This starts an interactive bash session in the container as the "dev" user, which will stop WP-CLI from chastising you for running it as the root user.

For example, the wp-sync-db plugin sometimes breaks when `WP_DEBUG` is enabled and &mdash; as this is a development environment &mdash; `WP_DEBUG` is enabled by default. Either you can stop the servers and change the settings in `docker-compose.yml`, or just disable it from the command line:

```sh
$ docker exec -it --user=dev project_wp_1 bash
dev@<container id> wp config set WP_DEBUG false --raw
# later...
dev@<container id> wp config set WP_DEBUG true --raw
```

> **NOTE:** Actually don't use WP-CLI for this *specific* use-case, WP_DEBUG is set on the fly from the `WP_DEBUG` environment variable. Change that from the command line with
> ```sh
> dev@<container id> $WP_DEBUG = 0 # for false, 1 for true
> ```
> 

### MySQL

In the event you need to fiddle around in the database manually, there isn't a GUI set up (yet?) so you will have to execute SQL from the command line.

Access the database container much like above:

```sh
$ docker exec -it project_db_1 mysql -p
Enter password:
```

The MySQL root user password is set in [docker-compose.yml](https://github.com/Denman-Digital/wp-theme-docker/blob/main/docker-compose.yml) and defaults to `admin`.

### Rebuilding Containers

You may find you need to rebuild your containers if things go pear-shaped:

```sh
docker-compose up --force-recreate --build
# OR
npm run rebuild # alias
```

If you need to tear down everything including the database, do the following first:

```sh
docker-compose down
# OR
npm run teardown # alias
```
