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
    docker compose up
    # OR
    npm start # alias
    ```

3. **(Optional, but recommended)**. Delete the `.git` folder.  
   This is just a starting point for a development environment. You'll probably need or want to tweak it for each project, or even each user. Changes you make are _probably_ going to be project-specific and wont need to be pushed upstream, and changes upstream are likely not necessary to pull down, especially if it's already working for you.

That's it. (_so far_)

The dev site will be served at [localhost:8000](http://localhost:8000).
A database admin GUI is available at [localhost:8080](http://localhost:8080).

> **NOTE:** If there isn't a folder named `/app` with an existing WordPress install, docker will create one.

<br>

## Scripts

There are 2 bash scripts included to help get a dev environment up and running.

Both scripts require that the containers be up and running when they are called.

### Database Restore (`bin/restore_db.sh`)

```sh
npm run db:restore $file
# - OR -
bash ./bin/restore_db.sh $file
```

`$file` must be the path to an sql file. Typically this is stored in the `/data` folder:

```sh
npm run db:restore ./data/export.sql
```

This script will replace the current db with the contents of a database SQL dump, then search and replace the production URL with a local development URL as defined by the `PROD_URL` and `DEV_URL` environment variables respectively. These variables are set in [docker-compose.yml](https://github.com/Denman-Digital/wp-theme-docker/blob/main/docker-compose.yml) and must be quoted strings.

| Variable   | Default Value             |
| ---------- | ------------------------- |
| `PROD_URL` | `"https://project1.com"`  |
| `DEV_URL`  | `"http://localhost:8000"` |

> **NOTE:** if you want to set up a different local url, update this to match.

### Plugins (`bin/plugins.sh`)

```sh
npm run wp:plugins
# - OR -
bash ./bin/plugins.sh
```

This script will uninstall Hello Dolly, deactivate any production specific plugins (as defined in by the `PROD_PLUGINS` environment variable), and install and activate any development specific plugins (as defined in by the `DEV_PLUGINS` environment variable). These variables are set in [docker-compose.yml](https://github.com/Denman-Digital/wp-theme-docker/blob/main/docker-compose.yml) and should be quoted strings with space-separated plugin IDs.

| Variable       | Default Value                                                  |
| -------------- | -------------------------------------------------------------- |
| `PROD_PLUGINS` | `"better-wp-security really-simple-ssl breeze"`                                         |
| `DEV_PLUGINS`  | `"debug-bar debug-bar-actions-and-filters-addon health-check"` |

<br>

## Commands

The following are some helpful commands for working with the Docker containers. Your docker containers may have different names, in which case you can use the `docker ps` command to see any currently running docker containers.

### WP-CLI

The WordPress Command Line Interface is installed on the Apache container. To access it, you can use the following script:

```sh
npm run db:bash
```

> **NOTE:** This is just an alias for this command
> ```sh
> docker exec -it --user=dev project_wp_1 bash
> ```
> Where `project_wp_1` is the container name, as generated from the `COMPOSE_PROJECT_NAME` variable in the [.env](https://github.com/Denman-Digital/wp-theme-docker/blob/main/.env) file.

This starts an interactive bash session in the container as the "dev" user, which will stop WP-CLI from chastising you for running it as the root user.

For example, the wp-sync-db plugin sometimes breaks when `WP_DEBUG` is enabled and &mdash; as this is a development environment &mdash; `WP_DEBUG` is enabled by default. Either you can stop the servers and change the settings in `docker-compose.yml`, or just disable it from the command line:

```sh
$ npm run wp:bash
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

In the event you need to fiddle around in the database manually, you can use [Adminer](https://www.adminer.org/) by going to [localhost:8080](localhost:8080) or you can execute SQL from the command line by accessing the database container much like above:

```sh
$ docker exec -it project_db_1 mysql -p
Enter password:
```

This has also been aliased to:

```sh
$ npm run db:mysql
```

For either method, the MySQL root user password is set in [docker-compose.yml](https://github.com/Denman-Digital/wp-theme-docker/blob/main/docker-compose.yml) and defaults to `admin`, and the database name is `wordpress`.

### Rebuilding Containers

You may find you need to rebuild your containers if things go pear-shaped:

```sh
docker compose up --force-recreate --build
# OR
npm run rebuild # alias
```

If you need to tear down everything, do the following first:

```sh
docker compose down
# OR
npm run teardown # alias
```

If you need to burn everything down to the ground, **including the database**:

```sh
docker compose down --volumes
```
