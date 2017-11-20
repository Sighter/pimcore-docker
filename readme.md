
# Building the image

From the project root directory run:

    docker image build -t pimcore .


# Starting the enviroment

The container running the pimcore image needs to connect to a db-server which is
properly configured.

Create a docker network

    docker network create --driver bridge pimcore

Run the pimcore image

    docker run --rm -it -p 8080:80 --network pimcore --name pimcore pimcore

Run the mysql container

    docker run --name pimcore-mariadb --rm --network pimcore -e MYSQL_ROOT_PASSWORD=testing -e MYSQL_DATABASE=pimcoredb mariadb --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --bind-address=0.0.0.0

In the Browser go to localhost:8080 and install pimcore.


b1|G6^l4^d2[f5)