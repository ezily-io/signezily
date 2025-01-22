#!/bin/bash -e

# Set Environment Variables
export AWS_DEFAULT_REGION=ap-northeast-1
export AWS_REGION=ap-northeast-1
export AWS_ACCOUNT=898622234277
export BUILDKIT_PROGRESS=plain
export DOCKER_BUILDKIT=1
export CLUSTER="dev"

# Function to set up common build variables
setup_build_variables() {
    local ecr_repository="$1"

    # Get current Git SHA
    GIT_SHA=$(git rev-parse --short HEAD)
    IMAGE="$AWS_ACCOUNT.dkr.ecr.$AWS_REGION.amazonaws.com/$ecr_repository"
    THIS_TAG="$IMAGE:$GIT_SHA"
    TAGS="$IMAGE:latest,$THIS_TAG"
    COMMIT_SHA=$GIT_SHA
    BUILD_PLATFORM="amd64"

    export GIT_SHA IMAGE THIS_TAG TAGS COMMIT_SHA BUILD_PLATFORM
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

    # Set up build variables
    setup_build_variables $ECR_REPOSITORY

    # Build the Docker image
    docker build --progress=$BUILDKIT_PROGRESS --build-arg COMMIT_SHA=$COMMIT_SHA -t $THIS_TAG -t $IMAGE:latest -f ./docker/Dockerfile .
    echo "Build process for $1 completed."

    if [ "$GIT_BRANCH" = "main" ] && [ "$EVENT_NAME" = "push" ]; then
        docker push $THIS_TAG
        docker push $IMAGE:latest
        echo "Docker images pushed: $FINAL_TAGS"

        aws ecs update-service \
          --cluster "$CLUSTER" --service "$SERVICE" \
          --force-new-deployment
        echo "Service updated: $SERVICE"
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

    # Set up build variables
    setup_build_variables $ECR_REPOSITORY

    # Build the Docker image
    docker build --progress=$BUILDKIT_PROGRESS --build-arg COMMIT_SHA=$COMMIT_SHA -t $THIS_TAG -t $IMAGE:latest -f ./docker/Dockerfile.marketing .
    echo "Build process for $1 completed."

    if [ "$GIT_BRANCH" = "main" ] && [ "$EVENT_NAME" = "push" ]; then
        docker push $THIS_TAG
        docker push $IMAGE:latest
        echo "Docker images pushed: $FINAL_TAGS"

        aws ecs update-service \
          --cluster "$CLUSTER" --service "$SERVICE" \
          --force-new-deployment
        echo "Service updated: $SERVICE"
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

    # Set up build variables
    setup_build_variables $ECR_REPOSITORY

    # Build the Docker image
    docker build --progress=$BUILDKIT_PROGRESS --build-arg COMMIT_SHA=$COMMIT_SHA -t $THIS_TAG -t $IMAGE:latest -f ./docker/Dockerfile.documentation .
    echo "Build process for $1 completed."

    if [ "$GIT_BRANCH" = "main" ] && [ "$EVENT_NAME" = "push" ]; then
        docker push $THIS_TAG
        docker push $IMAGE:latest
        echo "Docker images pushed: $FINAL_TAGS"

        aws ecs update-service \
          --cluster "$CLUSTER" --service "$SERVICE" \
          --force-new-deployment
        echo "Service updated: $SERVICE"
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