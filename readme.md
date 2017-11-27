# Intro

This Repository holds files for setting up a pimcore installation using docker.

# Prerequisites

After cloning the repository, you have to download an unpack the pimcore
installation files. Regarding to the pimcore documentation [1] use the following
command:

    wget https://pimcore.com/download-5/pimcore-latest.zip -O pimcore-install.zip

The archive must get unpacked into a folder named pimcore-install

    unzip pimcore-install.zip -d pimcore-install

# Building the image

From the project root directory run:

    docker image build -t pimcore .

# Starting the enviroment

The container running the pimcore image needs to connect to a db-server which is
properly configured.

Create a docker network

    docker network create --driver bridge pimcore

Run the mysql container

    docker run --name pimcore-mariadb -p -p 8300:3306 --network pimcore -e MYSQL_ROOT_PASSWORD=testing -e MYSQL_DATABASE=pimcoredb mariadb --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --bind-address=0.0.0.0

Run the pimcore image

    docker run -it -p 8080:80 --network pimcore --name pimcore pimcore

In the Browser navigate to localhost:8080/admin/login.

# Notes

* Keep in mind, that pimcore is installed on every container "run". This means
you have to make sure, that the db container is also rebuild or you drop the
pimcore db manually, and create it again.

