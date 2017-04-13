# About the Dockerfile

This is the Docker [image](https://hub.docker.com/r/greenjava/docker-fw4spl/) for [fw4spl](https://github.com/fw4spl-org/fw4spl).
This image contains all libraries, bundles and apps available in main fw4spl repository in a Ubuntu 16.04 environment.

## 1. Docker 

Docker containers wrap up a piece of software in a complete filesystem that contains everything it needs to run: code, runtime, system tools, system libraries – anything you can install on a server. 
This guarantees that it will always run the same, regardless of the environment it is running in.

So remember :

- a container is a stripped-to-basics version of a Linux operating system.
- an image is software you load into a container.
 
#### Get Docker

Get it from the website !
Follow the link and choose your platform: [Docker Community Edition](https://www.docker.com/community-edition)

And take 5 minutes [to read the doc](https://docs.docker.com/).


## 2. Usage

### 2.1 Build

- Command to build the fw4spl container:
```
docker build -t fw4spl:11.0.5 .
```

### 2.2 Build-time variable

By default, Docker build the fw4spl image in **Release** mode in version **11.0.5**.
You can change the build type and fw4spl version using Docker **build-time variable**.

- **FW4SPL_BUILDTYPE** build-time variable to change build type (**Debug** or **Release**)
- **FW4SPL_BRANCH** build-time variable to change FW4SPL version

```
docker build -t fw4spl:11.0.5 --build-arg FW4SPL_BUILDTYPE=Debug --build-arg FW4SPL_BRANCH=11.0.5 .
```

### 2.3 Run

Command to run the fw4spl image:
```
docker run -idt --name=myFW4SPL fw4spl:11.0.5
```

### 2.4 Use

Command to use your new fw4spl image:
```
docker exec -it myFW4SPL /bin/bash
```
