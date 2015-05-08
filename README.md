## Users - running the container

1. Set permissions on datastore which will hold results of workflows after they run

        mkdir workflows && mkdir datastore
        chmod a+wrx workflows && chmod a+wrx datastore

2. Run container and login with the following (while persisting workflow run directories to datastore). 
 
        docker run --rm -h master -t -v `pwd`/datastore:/datastore  -i seqware/seqware_whitestar:1.1.1

3. You should now be inside the running container. Run the HelloWorld (sample) workflow with 

        seqware bundle launch --dir ~/provisioned-bundles/Workflow_Bundle_HelloWorld_1.0-SNAPSHOT_SeqWare_1.1.1/ --no-metadata
        
4. Exit the container

        exit

5. Note that you can also run commands or workflows programmatically rather than interactively.

        docker run --rm -h master -t -v `pwd`/datastore:/mnt/datastore -i seqware/seqware_whitestar:1.1.1 seqware bundle launch --dir /home/seqware/provisioned-bundles/Workflow_Bundle_HelloWorld_1.0-SNAPSHOT_SeqWare_1.1.1/ --no-metadata

6. Note that the Docker client is installed in the container so you can connect the client with the host's Docker daemon in order to run workflows that use Docker calls

        docker run -h master --rm -t -i -v /var/run/docker.sock:/var/run/docker.sock seqware/seqware_whitestar:1.1.1
        docker run -t -i ubuntu /bin/bash

## Developers - building the image locally

1. Assuming docker is installed properly, build image with 

        docker build  -t seqware/seqware_whitestar:1.1.1 . 
