IMAGE=$1
VERSION=$2

echo "Pulling master container of $IMAGE and tagging as follows: 'latest', '$VERSION', '$VERSION-master'"
read -p "Confirm [Y/n] " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

docker pull "$IMAGE:master"
IMAGE_ID=$(docker images "$IMAGE:master" -q)
echo "$IMAGE_ID"
docker tag "$IMAGE_ID" "$IMAGE:latest"
docker tag "$IMAGE_ID" "$IMAGE:$VERSION"
docker tag "$IMAGE_ID" "$IMAGE:$VERSION-master"