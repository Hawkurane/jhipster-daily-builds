#!/bin/bash

set -e
source $(dirname $0)/00-init-env.sh

#-------------------------------------------------------------------------------
# Package UAA
#-------------------------------------------------------------------------------
if [[ "$JHI_APP" == *"uaa"* ]]; then
    cd "$JHI_FOLDER_UAA"
    ./mvnw verify -DskipTests -Pdev
    mv target/*.jar app.jar
fi

cd "$JHI_FOLDER_APP"
for local_folder in $(ls "$JHI_FOLDER_APP"); do
    if [ -d "$local_folder" ];
    then
        echo "$local_folder"
        cd $local_folder
        #-------------------------------------------------------------------------------
        # Decrease Angular timeout for Protractor tests
        #-------------------------------------------------------------------------------
        if [ "$JHI_PROTRACTOR" == 1 ] && [ -e "src/main/webapp/app/app.module.ts" ]; then
            sed -e 's/alertTimeout: 5000/alertTimeout: 1/1;' src/main/webapp/app/app.module.ts > src/main/webapp/app/app.module.ts.sed
            mv -f src/main/webapp/app/app.module.ts.sed src/main/webapp/app/app.module.ts
            cat src/main/webapp/app/app.module.ts | grep alertTimeout
        fi

        #-------------------------------------------------------------------------------
        # Package the application
        #-------------------------------------------------------------------------------
        if [ -f "mvnw" ]; then
            ./mvnw verify -DskipTests -P"$JHI_PROFILE"
            mv target/*.jar app.jar
        elif [ -f "gradlew" ]; then
            ./gradlew bootJar -P"$JHI_PROFILE" -x test
            mv build/libs/*SNAPSHOT.jar app.jar
        else
            echo "*** no mvnw or gradlew"
            exit 0
        fi
        if [ $? -ne 0 ]; then
            echo "*** error when packaging"
            exit 1
        fi

        #-------------------------------------------------------------------------------
        # Package the application as War
        #-------------------------------------------------------------------------------
        if [ "$JHI_WAR" == 1 ]; then
            if [ -f "mvnw" ]; then
                ./mvnw verify -DskipTests -P"$JHI_PROFILE",war
                mv target/*.war app.war
            elif [ -f "gradlew" ]; then
                ./gradlew bootWar -P"$JHI_PROFILE" -Pwar -x test
                mv build/libs/*SNAPSHOT.war app.war
            else
                echo "*** no mvnw or gradlew"
                exit 0
            fi
            if [ $? -ne 0 ]; then
                echo "*** error when packaging"
                exit 1
            fi
        fi

        #-------------------------------------------------------------------------------
        # Package the application as Docker image
        #-------------------------------------------------------------------------------
        # if [ "$JHI_PKG_DOCKER" == 1 ]; then
            if [ -f "mvnw" ]; then
                ./mvnw -Pprod verify jib:dockerBuild
            elif [ -f "gradlew" ]; then
                ./gradlew bootJar -Pprod jibDockerBuild
            else
                echo "*** no mvnw or gradlew"
                exit 0
            fi
            if [ $? -ne 0 ]; then
                echo "*** error when building docker images"
                exit 1
            fi

        # fi
    fi
done
docker images