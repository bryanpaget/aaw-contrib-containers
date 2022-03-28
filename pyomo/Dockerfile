FROM ubuntu:latest

RUN conda install -c conda-forge pyomo matplotlib networkx \
	numpy openpyxl pandas pint pymysql pyodbc pyro4 scipy \
	sympy xlrd pyomo.solvers ipopt glpk coincbc coinbonmin 


USER root

RUN apt install coinor-cbc coinor-libcbc3 \
	coinor-libcoinmp-dev coinor-libdylp1 \
	coinor-libipopt1v5 coinor-libsymphony3 \
	coinor-clp coinor-libcgl-dev coinor-libcoinmp1v5 \
	coinor-libflopc++-dev coinor-libipopt1v5-dbg coinor-libvol-dev \
	coinor-csdp coinor-libcgl-doc coinor-libcoinutils-dev \
	coinor-libflopc++-doc coinor-libosi-dev \
	coinor-libvol-doc coinor-csdp-dbg coinor-libcgl1 \
	coinor-libcoinutils-doc coinor-libflopc++0v5 \
	coinor-libosi-doc coinor-libvol1 coinor-csdp-doc \
	coinor-libclp-dev coinor-libcoinutils3v5 \
	coinor-libflopc++0v5-dbg coinor-libosi1v5 \
	coinor-symphony coinor-libcbc-dev coinor-libclp-doc \
	coinor-libdylp-dev coinor-libipopt-dev coinor-libsymphony-dev \
	coinor-libcbc-doc coinor-libclp1 coinor-libdylp-doc \
	coinor-libipopt-doc coinor-libsymphony-doc   

RUN apt install python3-pip
RUN apt install git

USER $NB_UID

RUN pip3 install 'pyomo[optional]'

RUN git clone https://github.com/coin-or/Couenne

WORKDIR Couenne

RUN mkdir build

WORKDIR build

RUN ../configure -C
RUN make
RUN make install
