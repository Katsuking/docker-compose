
#!/bin/bash

########################
# Delete image, volume
########################
# Need to refactor
# There is so much room for improvement
#-----------------------

docker compose down

image_name="v1_dev"
container=$(docker ps -a | grep ${image_name} | awk '{print $2}')
img=$(docker images | grep ${image_name} | awk '{print $3}')

if [[ -n ${container} ]]; then
    container_id=$(docker ps -a | grep ${image_name} | awk '{print $1}')
    # docker container stop ${container_id}
    docker container rm "${container_id}"
fi

if [[ -n ${img} ]]; then
    docker image rm "${img}"
fi

read -p "Do you want to delete volume attached to ${image_name}? (y/n) " answer
if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    docker volume rm "$(basename "$(pwd)")_${image_name}" 2>/dev/null
fi

