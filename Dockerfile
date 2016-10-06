FROM hg8496/atlassian-docker
MAINTAINER hg8496@cstolz.de

ENV CONF_VERSION 5.10.7
ENV CONFLUENCE_DOWNLOAD_URL http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-${CONF_VERSION}.tar.gz

ENV MYSQL_VERSION 5.1.38
ENV MYSQL_DRIVER_DOWNLOAD_URL http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_VERSION}.tar.gz

RUN curl -Lks "${CONFLUENCE_DOWNLOAD_URL}" -o /confluence.tar.gz 
RUN mkdir -p /opt/confluence
RUN tar zxf /confluence.tar.gz --strip=1 -C /opt/confluence

RUN curl -Lks "${MYSQL_DRIVER_DOWNLOAD_URL}" | tar -xz --directory "/opt/confluence/confluence/WEB-INF/lib" --strip-components=1 --no-same-owner "mysql-connector-java-${MYSQL_VERSION}/mysql-connector-java-${MYSQL_VERSION}-bin.jar"
RUN chown -R atlassian:atlassian /opt/confluence
RUN mv /opt/confluence/conf/server.xml /opt/confluence/conf/server-backup.xml
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /confluence.tar.gz 

ENV CONTEXT_PATH ROOT
ENV SSL_PROXY ""
ENV CONFLUENCE_HOME /opt/atlassian-home

RUN echo -e "\nconfluence.home=${CONFLUENCE_HOME}" >> "/opt/confluence/confluence/WEB-INF/classes/confluence-init.properties"
ADD launch.bash /launch

WORKDIR /opt/confluence
VOLUME ["${CONFLUENCE_HOME}"]
EXPOSE 8090
USER atlassian
CMD ["/launch"]
