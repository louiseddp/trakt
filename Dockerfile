# docker build -t coqmaster/coqmaster:latest .
# docker run -it coqmaster/coqmaster:latest
# docker run -w /home/coq/trakt -v "/home/louise/github.com/ckeller/trakt:/home/coq/trakt" -it coqmaster/coqmaster:latest

############################################################
# Dockerfile to build SMTCoq dependencies
############################################################

ARG COQ_TAG="dev"
FROM coqorg/coq:${COQ_TAG}

USER coq

################### SYSTEM PREREQUISITES ###################

RUN sudo apt-get -y update && \
    sudo apt-get -y install wget atool bison flex

#################### OPAM PREREQUISITES ####################

WORKDIR /home/coq

RUN opam update && \
    opam upgrade -y && \
    opam repo add coq-extra-dev https://coq.inria.fr/opam/extra-dev && \
    opam install coq-elpi

######################### BINARIES #########################

WORKDIR /home/coq
