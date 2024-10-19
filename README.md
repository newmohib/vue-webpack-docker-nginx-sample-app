
#### Make the Script Executable: Run the following command to make the script executable:

    chmod +x script.sh && ./script.sh

#### Create any new project with using React CLI follow this step
- copy and past 4 files from here 
 - .dockerignore
 - default.conf
 - Dockerfile
 - script.sh
- add this command into package.json file as script
 - "start:prod": "chmod +x script.sh && ./script.sh"
- Run the application with Docker
 - npm run start:prod
 - or
 - chmod +x script.sh && ./script.sh

#### Remove all container and image
- Remove all container
 - docker container rm -f $( docker container ls -aq )
- Remove all image
 - docker image rm -f $(docker image ls -q)
