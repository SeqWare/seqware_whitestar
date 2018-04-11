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

        seqware bundle launch --dir ~/provisioned-bundles/Workflow_Bundle_HelloWorld_1.0-SNAPSHOT_SeqWare_1.1.2/ --no-metadata

4. Exit the container

        exit

5. Note that you can also run commands or workflows programmatically rather than interactively.

        docker run --rm -h master -t -v `pwd`/datastore:/mnt/datastore -i seqware/seqware_whitestar:1.1.2-java8 seqware bundle launch --dir /home/seqware/provisioned-bundles/Workflow_Bundle_HelloWorld_1.0-SNAPSHOT_SeqWare_1.1.2/ --no-metadata

6. Note that the Docker client is installed in the container so you can connect the client with the host's Docker daemon in order to run workflows that use Docker calls

        docker run -h master --rm -t -i -v /var/run/docker.sock:/var/run/docker.sock seqware/seqware_whitestar:1.1.2-java8
        docker run -t -i ubuntu /bin/bash

**NOTE:** There are two versions of seqware/seqware_whitestar version "1.1.2":
  - seqware/seqware_whitestar:1.1.2 which contains Java 6.
  - seqware/seqware_whitestar:1.1.2-java8 which contains Java 8.

## Users - running your own workflows

1. Set permissions on datastore which will hold results of workflows after they run

        mkdir workflows && mkdir datastore
        chmod a+wrx workflows && chmod a+wrx datastore

2. Build your workflow and copy the unzipped workflow bundle into the `workflows` directory. Note that symlinks won't work here.

        cp -r /home/me/git/workflow-test/target/Workflow_Bundle_Test_2.0_SeqWare_1.1.0 workflows
        
3. Make sure the data you need for your workflow is either in `datastore` or otherwise accessible by the Docker container.

        cp -r /home/me/neat_5x_EX_hg19_chr21.bam datastore

4. Assess your workflow's dependencies. Many SeqWare workflows package all of their dependencies in the workflow and these workflows should work without modification. If, on the other hand, you depend on software or environment variables available on the path, you may want to wrap the `seqware bundle launch` command below in a script that imports those dependencies. Make sure you add the script to a location available in the container, e.g. `workflows` or `datastore`.

5. Launch your workflow. Use the `--override` command to set required INI parameters; for example, the following command overrides `input_file` and `output_prefix`.

        docker run --rm -h master -t -v `pwd`/datastore:/mnt/datastore -v `pwd`/workflows:/mnt/workflows \
            -i seqware/seqware_whitestar:1.1.2-java8                                    \ 
            seqware bundle launch --no-metadata                                         \
                --dir /mnt/workflows/Workflow_Bundle_Test_2.0_SeqWare_1.1.0             \
                --override output_prefix="/mnt/datastore/"                              \
                --override input_file="/mnt/datastore/neat_5x_EX_hg19_chr21.bam"


## Developers - building the image locally

1. Assuming docker is installed properly, build image with

        docker build  -t seqware/seqware_whitestar:1.1.2-java8 .
