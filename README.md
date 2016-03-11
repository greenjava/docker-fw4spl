# About the Dockerfile

This is the Docker image for [fw4spl](https://github.com/fw4spl-org/fw4spl).
This image contains all libraries, bundles and apps available in main fw4spl repository in a Debian sid environment.

## 1. Docker 

Docker containers wrap up a piece of software in a complete filesystem that contains everything it needs to run: code, runtime, system tools, system libraries – anything you can install on a server. 
This guarantees that it will always run the same, regardless of the environment it is running in.

So remember :

- a container is a stripped-to-basics version of a Linux operating system.
 
- an image is software you load into a container.
 
#### Get Docker

Get it from the website !
Follow the link, choose your platform : 

- [mac](https://docs.docker.com/mac/)
- [linux](https://docs.docker.com/linux/)
- [windows](https://docs.docker.com/windows/)

And take 5 minutes to follow the tutorial.


## 2. Usage

### 2.1 Environment variable

By default, Docker build the fw4spl image in **Release** mode in version **0.11.0**.

- You can specify build type with **FW4SPL_BUILDTYPE** environment variable
```
export FW4SPL_VERSION=Release
```

- You can specify fw4spl version with **FW4SPL_VERSION** environment variable
```
export FW4SPL_VERSION=0.11.0
```

### 2.2 Build

Command to build the fw4spl container:
```
docker build -t fw4spl:0.11.0 .
```

### 2.2 Run

Command to run the fw4spl image:
```
docker run -idt --name=myFW4SPL fw4spl:0.11.0
```

### 2.3 Use

Command to use your new fw4spl image:
```
docker exec -it myFW4SPL /bin/bash
```

## 3. Windows issue

When you try to run an interactive shell on a Docker container via the Windows Docker client, you might receive the following error message:
```
docker exec -it myFW4SPL /bin/bash
cannot enable tty mode on non tty input
```
This error is caused by the Windows Git/PowerShell/MinGW/Cygwin Bash terminal, because it does not have full/correct support for TTY.

### 3.1 CMD

CMD is the standard Windows shell.
Command to load a Docker environment in CMD:        
```
docker-machine env default --shell cmd
```

### 3.2 PowerShell

Command to load a Docker environment in PowerShell:        
```
docker-machine env default --shell powershell | Invoke-Expression
```

### 3.3 Bash

Bash is a UNIX shell installed with Git for Windows (included with Docker Toolbox).
If you are using Bash from another source, such as Cygwin or MinGW, the Docker environment setup remains the same.
Command to load a Docker environment in Bash:
```
eval $(docker-machine env default --shell bash)
```