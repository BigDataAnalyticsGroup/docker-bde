# Foreword

1. We spent a lot of time preparing the tools and the write ups below. Please read them carefully before asking questions!
2. If you are not yet familiar with terminal usage, you should spend some time to learn the basics.
3. If your terminal spits out a warning or an error, don't panic! Read the error message, it often hints at possible solutions. It is highly likely that someone else experienced the exact same problem so use the forums to get in touch with other students and tutors.

Throughout this lecture, we will make use of Jupyter notebooks. In order to execute these notebooks, we provide you with a [Docker](https://www.docker.com) container. This container is created from an image, which is configured by means of a so called `dockerfile`. A `dockerfile` is basically a script that tells Docker what commands to execute when creating the image.

# Preliminaries

## Install Docker

First, you have to download and install [Docker](https://docs.docker.com/get-docker/) for your operating system either through the downloads on the respective website or your systems package manager. With the following command, you can test if the installation was successful:
```sh
$ docker -v
Docker version 27.4.0, build bde2b89
```
Note that the version number may slightly differ.

## Clone the Repository 

Second, before starting to work on the notebooks for the first time, you have to clone [this repository](https://github.com/BigDataAnalyticsGroup/bigdataengineering) on your local machine. Make sure, that submodules are also loaded by using the `--recursive` option:
```sh
$ git clone --recursive https://github.com/BigDataAnalyticsGroup/bigdataengineering.git
```

# Workflow

In this section, we will discuss the usual workflow when using Docker in the context of this lecture. Note that the Docker engine needs to be running, e.g., by opening the Docker app, to execute the following Docker commands.

First, navigate to the directory containing the `dockerfile` and the `docker-compose.yml` file:
```sh
$ cd bigdataengineering/docker-bde
```
To create a Docker image, execute the following command:
```sh
$ docker compose build
[+] Building 1.4s (14/14) FINISHED                                                                                                                             docker:desktop-linux
 => [app internal] load build definition from dockerfile                                                                                                                       0.0s
 => => transferring dockerfile: 1.28kB                                                                                                                                         0.0s
 => [app internal] load metadata for docker.io/library/ubuntu:22.04                                                                                                            1.4s
 => [app internal] load .dockerignore                                                                                                                                          0.0s
 => => transferring context: 2B                                                                                                                                                0.0s
 => [app 1/9] FROM docker.io/library/ubuntu:22.04@sha256:1b8d8ff4777f36f19bfe73ee4df61e3a0b789caeff29caa019539ec7c9a57f95                                                      0.0s
 => [app internal] load build context                                                                                                                                          0.0s
 => => transferring context: 171B                                                                                                                                              0.0s
 => CACHED [app 2/9] RUN apt-get update && apt-get install -y software-properties-common                                                                                       0.0s
 => CACHED [app 3/9] RUN apt-get update && apt-get install -y     build-essential     git     binutils     tree     neovim     python3     python3-pip     graphviz     postg  0.0s
 => CACHED [app 4/9] RUN apt-get update && apt-get install -y docker.io                                                                                                        0.0s
 => CACHED [app 5/9] RUN useradd -s /bin/sh -d /home/bde -m bde                                                                                                                0.0s
 => CACHED [app 6/9] RUN if ! $(grep -Fxq 'export PATH="$PATH:/home/$USERNAME/.local/bin"' /etc/profile);     then         echo 'export PATH="$PATH:/home/$USERNAME/.local/bi  0.0s
 => CACHED [app 7/9] COPY requirements.txt /tmp/requirements.txt                                                                                                               0.0s
 => CACHED [app 8/9] RUN pip3 install --user -r /tmp/requirements.txt                                                                                                          0.0s
 => CACHED [app 9/9] RUN jupyter contrib nbextension install --user &&     jupyter nbextension enable varInspector/main                                                        0.0s
 => [app] exporting to image                                                                                                                                                   0.0s
 => => exporting layers                                                                                                                                                        0.0s
 => => writing image sha256:8717baff53f828e492d78147d176b899439b5a00cd990a2f2ce5f083709de6e5                                                                                   0.0s
 => => naming to docker.io/library/docker-bde                                                                                                                                  0.0s
```
When executed, this command creates the image and executes all configuration scripts. This process might take a while. Make sure to have a stable internet connection! (University Wi-Fi is not a stable internet connection.) Don't panic if you see some red output on your terminal, this is perfectly fine.

Then, the container has to be to created from the image by executing the following command:
```sh
$ docker compose up -d
[+] Running 4/4
 ✔ Container docker-bde-neo4j-1  Started                  0.2s
 ✔ Container docker-bde-db-1     Started                  0.2s
 ✔ Container docker-bde-age-1    Started                  0.2s
 ✔ Container docker-bde-app-1    Started                  0.4s
```
Note that we actually create multiple containers due to the fact that certain notebooks require the access to external services. However, you do not need to interact with these directly and can just focus on `docker-bde-app-1`, to which you can now connect using the following Docker command:
```sh
$ docker compose exec -it app bash
bde@9258c8eea558:/$
```
You have now successfully logged into your Docker container. By using the `ls` command inside the container, you will now see the shared folder `shared` (and others):
```sh
bde@9258c8eea558:/$ ls
bin  boot  dev  etc  home  lib  media  mnt  opt  proc  root  run  sbin  shared  srv  sys  tmp  usr  var
```
This shared folder is synchronized between the host (your local machine) and the guest (container). It allows to easily move files between the two systems. On the container, the folder is located in the home directory `/home/bde/shared`. On your local machine, the folder is the parent directory of the directory where your `dockerfile` is located, i.e., the directory containing the notebooks by default. Therefore, your container automatically has access to the notebooks and is ready to execute them using Jupyter.

The Jupyter notebooks are executed inside the container but can be displayed in the browser of the local machine (this is achieved by forwarding the port 8888 of the container to your local machine). First, navigate to the directory containing the notebooks you would like to execute on the container as follows:
```sh
bde@9258c8eea558:/$ cd shared
```
Then start the Jupyter notebook server on the container with the following command. Note that port forwarding only works if you provide the argument `--ip=0.0.0.0`:
```sh
bde@9258c8eea558:/$ jupyter notebook --no-browser --ip=0.0.0.0
[I 10:42:27.173 NotebookApp] [jupyter_nbextensions_configurator] enabled 0.6.4
[I 10:42:27.177 NotebookApp] Serving notebooks from local directory: /shared
[I 10:42:27.177 NotebookApp] Jupyter Notebook 6.5.3 is running at:
[I 10:42:27.177 NotebookApp] http://9258c8eea558:8888/?token=e35dc2d64ad96e17f206b66fd6b3693453602ff2dc80baec
[I 10:42:27.177 NotebookApp]  or http://127.0.0.1:8888/?token=e35dc2d64ad96e17f206b66fd6b3693453602ff2dc80baec
[I 10:42:27.177 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[C 10:42:27.179 NotebookApp]

    To access the notebook, open this file in a browser:
        file:///home/bde/.local/share/jupyter/runtime/nbserver-19-open.html
    Or copy and paste one of these URLs:
        http://9258c8eea558:8888/?token=e35dc2d64ad96e17f206b66fd6b3693453602ff2dc80baec
     or http://127.0.0.1:8888/?token=e35dc2d64ad96e17f206b66fd6b3693453602ff2dc80baec
...
```
To access the Jupyter server from your local browser, copy the link at the bottom containing the ip `127.0.0.1` (localhost) from the terminal, and paste it into the address bar of your browser. The Jupyter server opens in your browser and you see a similar page as below.
![Jupyter Notebook](https://i.imgur.com/0egNn9r.jpg)

You can now execute the notebooks from the lecture and work on them.

After you have finished working on the notebooks, you can stop the Jupyter server by pressing `Ctrl-C` in your terminal and confirming with `y` and `Enter` (or by pressing `Ctrl-C` two times):
```sh
...
[I 10:43:37.154 NotebookApp] interrupted
Serving notebooks from local directory: /shared
0 active kernels
Jupyter Notebook 6.5.3 is running at:
http://9258c8eea558:8888/?token=e35dc2d64ad96e17f206b66fd6b3693453602ff2dc80baec
 or http://127.0.0.1:8888/?token=e35dc2d64ad96e17f206b66fd6b3693453602ff2dc80baec
Shutdown this notebook server (y/[n])? y
[C 10:43:40.300 NotebookApp] Shutdown confirmed
[I 10:43:40.302 NotebookApp] Shutting down 0 kernels
[I 10:43:40.303 NotebookApp] Shutting down 0 terminals
```
To close the connection to the container again, you can use the `exit` command:
```sh
bde@9258c8eea558:/$ exit
exit
```
The container is still running in the background. To check the current status of your container, you can use the `ls` command:
```sh
$ docker container ls
CONTAINER ID   IMAGE                  COMMAND                  CREATED       STATUS         PORTS                                                      NAMES
9258c8eea558   docker-bde             "sh"                     2 weeks ago   Up 5 minutes   0.0.0.0:8000->8000/tcp, 0.0.0.0:8888->8888/tcp             docker-bde-app-1
834e401382f1   apache/age             "docker-entrypoint.s…"   2 weeks ago   Up 5 minutes   5432/tcp                                                   docker-bde-age-1
ae87bbdfe76e   postgres:latest        "docker-entrypoint.s…"   2 weeks ago   Up 5 minutes   0.0.0.0:5432->5432/tcp                                     docker-bde-db-1
a80d34e97a53   neo4j:5.18-community   "tini -g -- /startup…"   2 weeks ago   Up 5 minutes   0.0.0.0:7474->7474/tcp, 7473/tcp, 0.0.0.0:7687->7687/tcp   docker-bde-neo4j-1
```
To shutdown the container, use the command `stop`:
```sh
$ docker compose stop
[+] Stopping 4/4
 ✔ Container docker-bde-app-1    Stopped                    10.1s
 ✔ Container docker-bde-neo4j-1  Stopped                    5.3s
 ✔ Container docker-bde-age-1    Stopped                    0.2s
 ✔ Container docker-bde-db-1     Stopped                    0.2s
```

## Docker Cheat Sheet

**Starting and stopping one or multiple container(s):**
* `docker compose build`: creates the image, runs `dockerfile` (setup, configuration) on first call
* `docker compose up -d`: creates and starts the containers
* `docker compose exec -it app bash`: connects to the container
* `docker compose stop`: suspends all containers

**Other commands:**
* `docker`: displays a list of all available commands
* `docker -v`: displays the version of docker
* `docker container ls status`: lists all running containers

For more details, please visit the [official Docker documentation](https://docs.docker.com/reference/).

## TL;DR

All in all, your usual workflow after the preliminaries should look similar to this:
```sh
$ cd bigdataengineering/docker-bde
# If you deleted your image or you changed the dockerfile, you need to rebuild the image. 
# Otherwise you do not need to execute the following command again and can skip it.
$ docker compose build
$ docker compose up -d
$ docker compose exec -it app bash
$ cd shared
$ jupyter notebook --no-browser --ip=0.0.0.0
# Go to the browser on your local machine, enter the link `http://127.0.0.1:8888/?token=...`,
# and start working with the notebooks.
# Once you are finished working with the notebooks, press `Ctrl-C` and confirm with `y` and `Enter`
# to stop the Jupyter server.
$ exit
$ docker compose stop
```
