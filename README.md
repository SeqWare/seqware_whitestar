[![](https://badge.imagelayers.io/seqware/seqware_whitestar:latest.svg)](https://imagelayers.io/?images=seqware/seqware_full:latest 'Get your own badge on imagelayers.io')
[![Docker Automated build](https://img.shields.io/docker/automated/seqware/seqware_whitestar.svg?maxAge=2592000)](https://hub.docker.com/r/seqware/seqware_whitestar/)

## Users - running the container

These steps take place in a temporary directory that you create for playing around with this container.

1. Set permissions on datastore which will hold results of workflows after they run

        mkdir workflows && mkdir datastore
        chmod a+wrx workflows && chmod a+wrx datastore

The workflows directory can be used later to store additional workflows that you wish to run. Datastore will contain the results of your workflow. This tutorial will use the HelloWorld workflow which is pre-built into the container and does not need to be installed in /datastore .

2. Run container and login with the following (while persisting workflow run directories to datastore).

        docker run --rm -h master -t -v `pwd`/datastore:/datastore  -i seqware/seqware_whitestar:1.1.2-java8

3. You should now be inside the running container. Run the HelloWorld (sample) workflow with

        seqware bundle launch --dir ~/provisioned-bundles/Workflow_Bundle_HelloWorld_1.0-SNAPSHOT_SeqWare_1.1.2-java8/ --no-metadata

4. Exit the container

        exit

5. Note that you can also run commands or workflows programmatically rather than interactively.

        docker run --rm -h master -t -v `pwd`/datastore:/mnt/datastore -i seqware/seqware_whitestar:1.1.2-java8 seqware bundle launch --dir /home/seqware/provisioned-bundles/Workflow_Bundle_HelloWorld_1.0-SNAPSHOT_SeqWare_1.1.2-java8/ --no-metadata

6. Note that the Docker client is installed in the container so you can connect the client with the host's Docker daemon in order to run workflows that use Docker calls

        docker run -h master --rm -t -i -v /var/run/docker.sock:/var/run/docker.sock seqware/seqware_whitestar:1.1.2-java8
        docker run -t -i ubuntu /bin/bash

**NOTE:** There are two versions of seqware/seqware_whitestar version "1.1.2":
  - seqware/seqware_whitestar:1.1.2 which contains Java 6.
  - seqware/seqware_whitestar:1.1.2-java8 which contains Java 8.

## Developers - building the image locally

1. Assuming docker is installed properly, build image with

        docker build  -t seqware/seqware_whitestar:1.1.2-java8 .
