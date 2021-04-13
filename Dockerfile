############################################################
# Dockerfile to build Nginx Installed Containers
# Based on Ubuntu
############################################################


# Set the base image to Ubuntu
FROM ubuntu

# File Author / Maintainer
MAINTAINER Karthik Gaekwad

# Install Nginx

# Add application repository URL to the default sources
# RUN echo "deb http://archive.ubuntu.com/ubuntu/ raring main universe" >> /etc/apt/sources.list

# Update the repository
RUN apt-get update

# Install necessary tools
RUN apt-get install -y vim wget dialog net-tools

RUN apt-get install -y nginx

# Remove the default Nginx configuration file
RUN chgrp -R 0 /etc/nginx && chmod -R g=u /etc/nginx && rm -v /etc/nginx/nginx.conf

# Copy a configuration file from the current directory
ADD nginx.conf /etc/nginx/

RUN mkdir /etc/nginx/logs && chgrp -R 0 /etc/nginx/logs && chmod -R g=u /etc/nginx/logs

# Add a sample index file
ADD index.html /www/data/
RUN chgrp -R 0 /www/data/ && chmod -R g=u /www/data/

# Append "daemon off;" to the beginning of the configuration
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Create a runner script for the entrypoint
COPY runner.sh /runner.sh
RUN chgrp 0 /runner.sh && chmod g=u /runner.sh && chmod +x /runner.sh

# Expose ports
EXPOSE 8088

ENTRYPOINT ["/runner.sh"]

USER 1001

# Set the default command to execute
# when creating a new container
CMD ["nginx"]
