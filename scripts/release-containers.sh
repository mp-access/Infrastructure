if [ "$#" -ne 2 ]; then
    echo "[Usage]: ./release-containers <image> <version>"
    exit 1
fi
IMAGE=$1
VERSION=$2

TAG1="latest"
TAG2="$VERSION"
TAG3="$VERSION-master"

echo "Pulling master container of $IMAGE and tagging as follows: '$TAG1', '$TAG2', '$TAG3'"

read -p "Confirm? [Y/n] " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

docker pull "$IMAGE:master"

echo "\nPlease verify on https://hub.docker.com/repository/docker/$IMAGE that the digest matches with the version you want to release"

IMAGE_ID=$(docker images "$IMAGE:master" -q)
echo "$IMAGE_ID"
docker tag "$IMAGE_ID" "$IMAGE:$TAG1"
docker tag "$IMAGE_ID" "$IMAGE:$TAG2"
docker tag "$IMAGE_ID" "$IMAGE:$TAG3"

echo "Push to docker hub images '$IMAGE:$TAG1' '$IMAGE:$TAG2' '$IMAGE:$TAG3'"
read -p "Push to docker hub? [Y/n] " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

docker push "$IMAGE:$TAG1"
docker push "$IMAGE:$TAG2"
docker push "$IMAGE:$TAG3"