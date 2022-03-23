FROM intersystemsdc/iris-community

USER root

ENV DEBIAN_FRONTEND noninteractive

# install libraries required by Pillow to process images
RUN apt-get -y update \
    && apt-get -y install apt-utils \
    && apt-get install -y build-essential unzip pkg-config wget \
    && apt-get install -y python3-pip 
    
# use pip3 (the python zpm) to install Pillow dependencies
RUN pip3 install --upgrade pip setuptools wheel
RUN pip3 install --target /usr/irissys/mgr/python Pillow

USER root   
WORKDIR /opt/irisbuild
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisbuild
USER ${ISC_PACKAGE_MGRUSER}

WORKDIR /opt/irisbuild
COPY  src src
RUN mkdir -p /opt/irisbuild/input
RUN mkdir -p /opt/irisbuild/output
RUN chmod -R 777 /opt/irisbuild/input
RUN chmod -R 777 /opt/irisbuild/output
COPY Installer.cls Installer.cls
COPY module.xml module.xml
COPY iris.script iris.script

USER ${ISC_PACKAGE_MGRUSER}

RUN iris start IRIS \
	&& iris session IRIS < iris.script \
    && iris stop IRIS quietly
