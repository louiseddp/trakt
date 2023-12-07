# docker build -t trakt/trakt:latest .
# docker run -it trakt/trakt:latest
# docker run -w /home/coq/trakt -v "/home/louise/github.com/ckeller/trakt:/home/coq/trakt" -it trakt/trakt:latest

############################################################
# Dockerfile to build SMTCoq dependencies
############################################################

ARG COQ_TAG="dev"
FROM coqorg/coq:${COQ_TAG}

USER coq

################### SYSTEM PREREQUISITES ###################

RUN sudo apt-get -y update

#################### OPAM PREREQUISITES ####################

WORKDIR /home/coq

RUN opam update && \
    opam upgrade -y && \
    opam repo add coq-released https://coq.inria.fr/opam/released && \
    opam install coq-elpi -y

######################### BINARIES #########################

WORKDIR /home/coq
