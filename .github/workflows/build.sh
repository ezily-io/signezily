#!/bin/bash -e

# Set Environment Variables
export AWS_DEFAULT_REGION=ap-northeast-1
export AWS_REGION=ap-northeast-1
export AWS_ACCOUNT=898622234277
export BUILDKIT_PROGRESS=plain
export DOCKER_BUILDKIT=1
export CLUSTER="dev"

# Global version variable extracted from package.json
getVersion(){
    version=$(jq -r .version package.json)
    echo "$version"
}

# Function to set up common build variables
setup_build_variables() {
    local ecr_repository="$1"
    local app_name="$2"

    # Get current Git SHA
    GIT_SHA=$(git rev-parse --short HEAD)
    IMAGE="$AWS_ACCOUNT.dkr.ecr.$AWS_REGION.amazonaws.com/$ecr_repository"
    APP_VERSION=$(getVersion)
    THIS_TAG="$IMAGE:${app_name}_${GIT_SHA}"
    APP_VERSION_TAG="${IMAGE}:${app_name}_${APP_VERSION}"
    LATEST="${APP_NAME}_latest"
    TAGS="$IMAGE:$LATEST $THIS_TAG $APP_VERSION_TAG"
    COMMIT_SHA=$GIT_SHA
    BUILD_PLATFORM="amd64"

    export GIT_SHA IMAGE THIS_TAG TAGS APP_VERSION_TAG LATEST COMMIT_SHA BUILD_PLATFORM
}

# Build Base
check_dev_build() {

    # Set up variables
    DOCKERFILE="Dockerfile"
    IMAGE_TAG="build-base:latest"
    CONTEXT="."

    # Build the Docker image
    docker build -t $IMAGE_TAG -f $DOCKERFILE $CONTEXT
}

# Build Base
build_base() {
    echo "Building base..."

    # Set up variables
    DOCKERFILE="Dockerfile"
    IMAGE_TAG="build-base:latest"
    CONTEXT="."

    # Build the Docker image
    docker build -t $IMAGE_TAG -f $DOCKERFILE $CONTEXT
}

# WEB APP
build_web() {

    echo "Building Documenso Web..."

    # Environment Variables
    ECR_REPOSITORY="signezily"
    SERVICE="documenso-app-dev"
    BUILDKIT_PROGRESS="plain"
    DOCKER_BUILDKIT=1
    APP_NAME="app"

    # Set up build variables
    setup_build_variables $ECR_REPOSITORY $APP_NAME

    # Build the Docker image
    docker build --progress=$BUILDKIT_PROGRESS --build-arg COMMIT_SHA=$COMMIT_SHA -t $THIS_TAG -t $APP_VERSION_TAG -t $IMAGE:$LATEST -f ./docker/Dockerfile .
    echo "Build process for $1 completed."

    if [ "$GIT_BRANCH" = "main" ] && [ "$EVENT_NAME" = "push" ] ; then
        for tag in $TAGS; do
          docker push "$tag"
        done
        echo "Docker images pushed: $TAGS"

    else
        echo "Push skipped. Conditions not met: Event=$EVENT_NAME, Branch=$GIT_BRANCH"
    fi
}

# Marketing Site
build_marketing_site() {

    echo "Building Documenso Docs..."

    # Environment Variables
    ECR_REPOSITORY="signezily"
    SERVICE="documenso-app-dev"
    BUILDKIT_PROGRESS="plain"
    DOCKER_BUILDKIT=1
    APP_NAME="maketing"

    # Set up build variables
    setup_build_variables $ECR_REPOSITORY $APP_NAME

    # Build the Docker image
    docker build --progress=$BUILDKIT_PROGRESS --build-arg COMMIT_SHA=$COMMIT_SHA -t $THIS_TAG -t $APP_VERSION_TAG -t $IMAGE:$LATEST -f ./docker/Dockerfile.marketing .
    echo "Build process for $1 completed."

    if [ "$GIT_BRANCH" = "main" ] && [ "$EVENT_NAME" = "push" ] || [ "$EVENT_NAME" = "pull_request" ]; then
        for tag in $TAGS; do
          docker push "$tag"
        done
        echo "Docker images pushed: $TAGS"

    else
        echo "Push skipped. Conditions not met: Event=$EVENT_NAME, Branch=$GIT_BRANCH"
    fi
}

#  DOCS Site
build_documentation_site() {

    echo "Building Documenso Docs..."

    # Environment Variables
    ECR_REPOSITORY="signezily"
    SERVICE="documenso-app-dev"
    BUILDKIT_PROGRESS="plain"
    DOCKER_BUILDKIT=1
    APP_NAME="docs"

    # Set up build variables
    setup_build_variables $ECR_REPOSITORY $APP_NAME

    # Build the Docker image
    docker build --progress=$BUILDKIT_PROGRESS --build-arg COMMIT_SHA=$COMMIT_SHA -t $THIS_TAG -t $APP_VERSION_TAG -t $IMAGE:$LATEST -f ./docker/Dockerfile.documentation .
    echo "Build process for $1 completed."

    if [ "$GIT_BRANCH" = "main" ] && [ "$EVENT_NAME" = "push" ] ; then
        for tag in $TAGS; do
          docker push "$tag"
        done
        echo "Docker images pushed: $TAGS"

    else
        echo "Push skipped. Conditions not met: Event=$EVENT_NAME, Branch=$GIT_BRANCH"
    fi
}

# Main execution flow based on parameter
case $1 in
  "build_web")
    build_web
    ;;
  "build_marketing")
    build_marketing_site
    ;;
  "build_documentation")
    build_documentation_site
    ;;
  *)
    echo "Invalid function name: $1"
    exit 1
    ;;
esac
