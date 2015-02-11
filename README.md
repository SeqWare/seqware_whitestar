## Getting the image

There are two ways of getting the imag:
* as a developer, you can build the image using the docker file
* as a user, download the image from S3

### Building the image

1. Assuming docker is installed properly, build image with 

        docker build  -t seqware_1.1.0-alpha.6 .

### Downloading and restoring the image

1. Rather than building the image, you can also download and restore it from S3 

        aws s3 cp s3://oicr.docker.images/seqware_1.1.0-alpha.6.tar .
        docker load -i seqware_1.1.0-alpha.6.tar

## Running the Container

1. Create a working directory 

        mkdir ~/docker_working_dir
        cd ~/docker_working_dir 
        mkdir datastore

2. Set permissions on datastore which will hold results of workflows after they run

        chmod a+w datastore

3. Run container and login with the following (while persisting workflow run directories to datastore). 
 
        docker run --rm -h master -t -v `pwd`/datastore:/datastore  -i seqware_1.1.0-alpha.6

4. You should now be inside the running container. Run the HelloWorld (sample) workflow with 

        seqware bundle launch --dir ~/provisioned-bundles/Workflow_Bundle_HelloWorld_1.0-SNAPSHOT_SeqWare_1.1.0-alpha.6/ --no-metadata
        
5. Exit the container

        exit
        
## Saving the image

1. Exit the container and save the image

        exit
        docker save -o seqware_1.1.0-alpha.6.tar seqware_1.1.0-alpha.6

2. Upload the image to S3 (given proper credentials)

        aws s3 cp seqware_1.1.0-alpha.6.tar s3://oicr.docker.images
