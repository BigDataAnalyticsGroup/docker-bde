# Foreword

1. We spent a lot of time preparing the tools and the write ups below. Please read them carefully before asking questions!
2. If you are not yet familiar with terminal usage, you should spend some time to learn the basics.
3. If your terminal spits out a warning or an error, don't panic! Read the error message, it often hints at possible solutions. It is highly likely that someone else experienced the exact same problem so use the forums to get in touch with other students and tutors.
4. The usage of Docker is highly recommended for users of an Apple Silicon chips since VirtualBox and thus our Vagrant VM won't work on these architectures.


# Docker

Throughout this lecture, we will make use of Jupyter notebooks. In order to execute these notebooks, we provide you with a [Docker](https://www.docker.com) container. This container is created from an image, which is configured by means of a so called `dockerfile`. A `dockerfile` is basically a script that tells Docker what commands to execute when first booting up the image.

## Preliminary

First, you have to download and install [Docker](https://docs.docker.com/get-docker/) for your operating system either through the downloads on the respective website or your systems package manager. With the following command, you can test if the installation was successful. Note that the version number may slightly differ:
```sh
$ docker -v
Docker version 26.0.0, build 2ae903e
```


## Basic Usage

Next, we explain the main functionality and usage of Docker.

To create a Docker image, execute the following command in the directory containing the `dockerfile` (how to get our `dockerfile` is explained below in the section `Workflow`):
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
When executed for the first time, this command creates the image and executes all configuration scripts. This process might take a while. Make sure to have a stable internet connection! (University Wifi is not a stable internet connection.) Don't panic if you see some red output on your terminal, this is perfectly fine.

Then, a container has to be created from the image by executing the following command:
```sh
$ docker compose up -d
[+] Running 4/4
 ✔ Container docker-bde-neo4j-1  Running                                                                                                                                       0.0s
 ✔ Container docker-bde-age-1    Running                                                                                                                                       0.0s
 ✔ Container docker-bde-db-1     Running                                                                                                                                       0.0s
 ✔ Container docker-bde-app-1    Started                                                                                                                                      10.2s
```

Afterwards, the container is running on your machine and you can connect to it. For this, use the following Docker command:
```sh
$ docker compose exec -it app bash
bde@118ca5f4b8a3:/$
```
You have now successfully logged into your Docker container. By using the `ls` command inside the container, you will now see the shared folder (and others):
```sh
bde@118ca5f4b8a3:/$ ls
bin  boot  dev  etc  home  lib  media  mnt  opt  proc  root  run  sbin  shared  srv  sys  tmp  usr  var
```

To close the connection to the container you can use the `exit` command:
```sh
bde@118ca5f4b8a3:/$ exit
exit
```
The container is still running in the background. To check the current status of your container, you can use the `ls` command:
```sh
$ docker container ls
CONTAINER ID   IMAGE                  COMMAND                  CREATED             STATUS             PORTS                                                      NAMES
118ca5f4b8a3   docker-bde             "sh"                     4 minutes ago       Up 4 minutes       0.0.0.0:8000->8000/tcp, 0.0.0.0:8888->8888/tcp             docker-bde-app-1
f7b54a2ef9c7   apache/age             "docker-entrypoint.s…"   58 minutes ago      Up 49 minutes      5432/tcp                                                   docker-bde-age-1
33bd6ec75150   postgres:latest        "docker-entrypoint.s…"   58 minutes ago      Up 49 minutes      0.0.0.0:5432->5432/tcp                                     docker-bde-db-1
8c77daecff44   neo4j:5.18-community   "tini -g -- /startup…"   About an hour ago   Up About an hour   0.0.0.0:7474->7474/tcp, 7473/tcp, 0.0.0.0:7687->7687/tcp   docker-bde-neo4j-1
```
To shutdown the container, use the command `stop`:
```sh
$ docker compose stop
[+] Stopping 4/4
 ✔ Container docker-bde-app-1    Stopped                                                                                                                                      10.1s
 ✔ Container docker-bde-neo4j-1  Stopped                                                                                                                                       5.3s
 ✔ Container docker-bde-age-1    Stopped                                                                                                                                       0.2s
 ✔ Container docker-bde-db-1     Stopped                                                                                                                                       0.2s
```

## Shared Folder

The container sets up a shared folder called `shared`. This folder is synchronized between the host (your local machine) and the guest (container). It allows to easily move files between the two systems. On the container, the folder is located in the home directory `/home/bde/shared`. On your local machine, the folder is the parent directory of the directory where your `dockerfile` is located.

## Cheat Sheet

**Starting and stopping a container**
* `docker compose build`: creates the image, runs `dockerfile` (setup, configuration) on first call
* `docker compose up -d`: creates and starts the container
* `docker compose exec -it app bash`: connects to the container
* `docker compose stop`: suspends the container

**Other commands**
* `docker`: displays a list of all available commands
* `docker -v`: displays the version of docker
* `docker container ls status`: lists all containers

For more details, please visit the [official Docker documentation](https://docs.docker.com/reference/).

# Workflow

In this section, we will discuss the usual workflow when using Docker in the context of this lecture.

## Clone the Repository

On the host, clone [this repository](https://github.com/BigDataAnalyticsGroup/bigdataengineering). Make sure, that submodules are also loaded by using the `--recursive` option.
```sh
$ git clone --recursive https://github.com/BigDataAnalyticsGroup/bigdataengineering.git
```

Then, create the container contained in a submodule and connect to it as described above, e.g.
```sh
$ cd bigdataengineering/docker-bde
$ docker compose build
$ docker compose up -d
$ docker compose exec -it app bash
```

Your container automatically has access to the notebooks and is ready to execute them using Jupyter.

## Jupyter

The Jupyter notebooks are executed inside the container but can be displayed in the browser of the local machine (this is achieved by forwarding the port 8888 of the container to your local machine). First, navigate to the directory containing the notebooks you would like to execute on the container, e.g. as follows:
```sh
[vagrant@archlinux ~]$ cd shared
```
Then start the Jupyter notebook server on the container with the following command. Note that port forwarding only works if you provide the argument `--ip=0.0.0.0`.
```sh
[vagrant@archlinux bigdataengineering]$ jupyter notebook --no-browser --ip=0.0.0.0
[I 14:17:27.944 NotebookApp] [jupyter_nbextensions_configurator] enabled 0.4.1
[I 14:17:27.945 NotebookApp] Serving notebooks from local directory: /home/vagrant/shared/bigdataengineering
[I 14:17:27.945 NotebookApp] Jupyter Notebook 6.4.10 is running at:
[I 14:17:27.945 NotebookApp] http://archlinux:8888/?token=f2b2c5ea93d4d293b7ea7c208092da3b8abf2c08e93ffedb
[I 14:17:27.945 NotebookApp]  or http://127.0.0.1:8888/?token=f2b2c5ea93d4d293b7ea7c208092da3b8abf2c08e93ffedb
[I 14:17:27.945 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[C 14:17:27.949 NotebookApp]

    To access the notebook, open this file in a browser:
        file:///home/bde/.local/share/jupyter/runtime/nbserver-633-open.html
    Or copy and paste one of these URLs:
        http://archlinux:8888/?token=f2b2c5ea93d4d293b7ea7c208092da3b8abf2c08e93ffedb
     or http://127.0.0.1:8888/?token=f2b2c5ea93d4d293b7ea7c208092da3b8abf2c08e93ffedb
...
```
To access the Jupyter server from your local browser, copy the link at the bottom containing the ip `127.0.0.1` (localhost) from the terminal, and paste it into the address bar of your browser. The Jupyter server opens in your browser and you see a similar page as below.
![Jupyter Notebook](https://i.imgur.com/0egNn9r.jpg)
You can now execute the notebooks from the lecture. Note that you have to change one line of code each in the notebooks `Graphs in Cypher.ipynb`, `Paradise Papers.ipynb`, `SQL Injection and Password Security.ipynb`, `SQL Injection.ipynb`, and `Transactions.ipynb` to work with the Docker setup (these lines are currently commented out but indicated with a comment).
To stop the Jupyter server, you can press `Ctrl-C` in your terminal and afterwards, confirm with `y` and `Enter` (or press `Ctrl-C` two times).
```sh
...
[[I 10:43:52.825 NotebookApp] interrupted
Serving notebooks from local directory: /home/bde/notebooks
0 active kernels
The Jupyter Notebook is running at:
http://archlinux:8888/?token=6585ef8be9a9c58f17953e725450909d62051515e0b0da1a
 or http://127.0.0.1:8888/?token=6585ef8be9a9c58f17953e725450909d62051515e0b0da1a
Shutdown this notebook server (y/[n])? y
[C 10:43:53.906 NotebookApp] Shutdown confirmed
[I 10:43:53.907 NotebookApp] Shutting down 0 kernels
```

## Summary
All in all, your usual workflow after the initial setup should look similar to this.
```sh
$ cd /path/to/docker
$ docker compose build
$ docker compose up -d
$ docker compose exec -it app bash
$ cd shared
$ jupyter notebook --no-browser --ip=0.0.0.0
# Go to the browser on your host machine,
# enter the link `http://127.0.0.1:8888/?token=...`,
# and start working with the notebooks.
$ exit # exit the container once you are finished working with the notebooks
$ docker compose stop
```
