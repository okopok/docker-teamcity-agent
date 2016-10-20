### TeamCity Build Agent
[![](https://badge.imagelayers.io/dlisin/teamcity-agent:latest.svg)](https://imagelayers.io/?images=dlisin/teamcity-agent:latest 'Get your own badge on imagelayers.io')

[TeamCity Build Agent](https://www.jetbrains.com/teamcity/) image with a number of preinstalled build tools:
 - [Ansible 1.9.4](https://www.ansible.com/)
 - [Git](https://git-scm.com/)
 - [Gradle 2.14.1](https://gradle.org)
 - [Google Protobuf](https://developers.google.com/protocol-buffers/)
 - [Node.JS 4.x](https://nodejs.org/)

### Usage

#### Prerequisites
You should have a TeamCity server up and running.

#### Configuration
Following environment variables are available:
 - `TEAMCITY_SERVER`: The address of the TeamCity server. Default value: `http://localhost:8111/`
 - `TEAMCITY_AGENT_NAME`: The unique name of the agent used to identify this agent on the TeamCity server. 
 - `TEAMCITY_AGENT_PORT`: A port that TeamCity server will use to connect to the agent. Default value: `9090`

#### Create build agent
Use following example to create new container:
```
docker pull dlisin/teamcity-agent
docker run -d --restart=always --name my-build-agent \
   -e TEAMCITY_SERVER=http://localhost:8111 \
   -e TEAMCITY_AGENT_NAME=my-build-agent \
   dlisin/teamcity-agent
```

If you need `git push` with SSH key authentication:
```
docker run -d --restart=always --name my-build-agent \
   -e TEAMCITY_SERVER=http://localhost:8111 \
   -e TEAMCITY_AGENT_NAME=my-build-agent \
   -v ~/.ssh/id_rsa:/root/.ssh/id_rsa \
   -v ~/.ssh/known_hosts:/root/.ssh/known_hosts \
   -v ~/.gitconfig:/root/.gitconfig \
   dlisin/teamcity-agent
```
##### Maven repository
The Local Maven repository created in `/root/.m2/repository`. This directory can be shared between severals agents with a [data container](https://docs.docker.com/engine/userguide/dockervolumes/)

Example: 
```
docker run -d --name maven-repository -v /root/.m2/repository busybox

docker run -d --restart=always --name agent-01 \
   -e TEAMCITY_SERVER=http://localhost:8111 \
   -e TEAMCITY_AGENT_NAME=agent-01 \
   --volumes-from maven-repository \
   dlisin/teamcity-agent
  
docker run -d --restart=always --name agent-02 \
   -e TEAMCITY_SERVER=http://localhost:8111 \
   -e TEAMCITY_AGENT_NAME=agent-02 \
   --volumes-from maven-repository \
   dlisin/teamcity-agent
```

#### Start build agent
```
docker start my-build-agent
```

#### Stop build agent
```
docker stop my-build-agent
```

#### Upgrade
Pull updated image, stop and remove existing build agent, then create new one:
```
docker pull dlisin/teamcity-agent
docker stop my-build-agent
docker rm my-build-agent
docker run -d --restart=always --name my-build-agent \
   -e TEAMCITY_SERVER=http://localhost:8111 \
   -e TEAMCITY_AGENT_NAME=my-build-agent \
   dlisin/teamcity-agent
```

#### Troubleshooting
To view container stdout:
```
docker logs my-build-agent
```

To open SSH session to running container:
```
docker exec -i -t my-build-agent bash
```

### Build
```
docker build -t dlisin/teamcity-agent .
```
