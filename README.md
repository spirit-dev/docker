spiritdev-docker-mongodb
====================

Base docker image to run a MongoDB database server


Usage
-----

To create the image `spiritdev/mongodb`, execute the following command on the spiritdev-mongodb folder:

        docker build -t spiritdev/mongodb .


Running the MongoDB server
--------------------------

Run the following command to start MongoDB:

        docker run -d -p 27017:27017 -p 28017:28017 spiritdev/mongodb

The first time that you run your container, a new random password will be set.
To get the password, check the logs of the container by running:

        docker logs <CONTAINER_ID>

You will see an output like the following:

        ========================================================================
        You can now connect to this MongoDB server using:

            mongo admin -u admin -p 57fR15Zedn --host <host> --port <port>

        Please remember to change the above password as soon as possible!
        ========================================================================

In this case, `57fR15Zedn` is the password set. 
You can then connect to MongoDB:

         mongo admin -u admin -p 57fR15Zedn

Done!

Running the MongoDB Server with an external volume
--------------------------------------------------

You can start MongoDB Server with an external volume like this:

        docker run -d -p 27017:27017 -p 28017:28017 -v ~/mongostore/:/data/db/ spiritdev/mongodb


Setting a specific password for the admin account
-------------------------------------------------

If you want to use a preset password instead of a randomly generated one, you can
set the environment variable `MONGODB_PASS` to your specific password when running the container:

        docker run -d -p 27017:27017 -p 28017:28017 -e MONGODB_PASS="mypass" spiritdev/mongodb

You can now test your new admin password:

        mongo admin -u admin -p mypass
        curl --user admin:mypass --digest http://localhost:28017/

Run MongoDB without password
----------------------------

If you want run MongoDB without password you can set tge environment variable `AUTH` to specific if you want password or not when running the container:

        docker run -d -p 27017:27017 -p 28017:28017 -e AUTH=no spiritdev/mongodb

By default is "yes".
