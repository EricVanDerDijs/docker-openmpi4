This repo just tries to update the dependencies of the following repo: https://github.com/dispel4py/docker.openmpi
# Docker - OpenMPI 4

With the code in this repository, you can build a Docker container that provides 
the OpenMPI runtime updated to the latest version.


## Getting Started

Run 6 replicas of this container with one of them being the head node.

```
$> docker-compose up -d --scale head=1 --scale node=5
```

****Note***: If you need to modify the number of process to run, remember to modify the content of the `./src/machines` file*

Next you will need to connect to the head node using the following command

```
$> ssh -i ssh/id_rsa.mpi -p $( source echo_head_port.sh ) tutorial@localhost
```

Finally, test the OpenMPI environment running the following commands
in the head node (through the ssh session opened by the previos command).
Keep in mind that the number of processes to span is defined in the `machines` hotsfile

```
	cd src
  mpiexec -hostfile machines python3 helloworld.py
```
