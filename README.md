## Users - running the container

1. Create a working directory 

        mkdir ~/docker_working_dir
        cd ~/docker_working_dir 
        mkdir datastore

2. Set permissions on datastore which will hold results of workflows after they run

        chmod a+w datastore

3. Run container and login with the following (while persisting workflow run directories to datastore). 
 
        docker run --rm -h master -t -v `pwd`/datastore:/datastore  -i seqware/seqware_whitestar

4. You should now be inside the running container. Run the HelloWorld (sample) workflow with 

        seqware bundle launch --dir ~/provisioned-bundles/Workflow_Bundle_HelloWorld_1.0-SNAPSHOT_SeqWare_1.1.0-alpha.6/ --no-metadata
        
5. Exit the container

        exit

## Developers - building the image locally

1. Assuming docker is installed properly, build image with 

        docker build  -t seqware/seqware_whitestar . 
