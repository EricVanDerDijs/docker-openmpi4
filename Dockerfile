FROM ubuntu:20.04
MAINTAINER Eric Van Der Dijs

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y openssh-server gcc gfortran libopenmpi3 binutils \
    python3-venv python3-pip mpich iputils-ping

RUN mkdir /var/run/sshd
RUN echo 'root:tutorial' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# ------------------------------------------------------------
# Add a 'tutorial' user
# ------------------------------------------------------------

RUN adduser --disabled-password --gecos "" tutorial && \
    echo "tutorial ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
ENV HOME /home/tutorial

# ------------------------------------------------------------
# Set-Up SSH
# ------------------------------------------------------------

WORKDIR /home/tutorial
RUN mkdir .ssh
ADD ssh/config .ssh/config
ADD ssh/id_rsa.mpi .ssh/id_rsa
ADD ssh/id_rsa.mpi.pub .ssh/id_rsa.pub
ADD ssh/id_rsa.mpi.pub .ssh/authorized_keys

RUN chmod -R 600 .ssh/* && \
    chown -R tutorial:tutorial .ssh


#-------------------------------------------------------------
# Install mpi4py
#-------------------------------------------------------------
RUN pip install mpi4py

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

ADD src src
RUN chown tutorial:tutorial src
