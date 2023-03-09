# PowerCheck Container

The PowerCheck Container provides two methods to run the development and production containers of the PowerCheck Web portal, you can choose between **Docker compose** or the scripts in the **bin** directory.

## Docker compose

### Development
```bash
$ docker-compose -f docker-compose.yml -f docker-compose.dev.yml up
```

### Build image
```bash
$ docker-compose build
```

### Production
```bash
$ docker-compose up
```

## Bin scripts
The **bin** scripts contain Linux and Windows scripts to run a local development environment, build the image and run the container from the image.

Prior to run any of the scripts, create a copy of ```settings.default.env``` as ```settings.env``` inside the ```conf``` directory, then edit ```settings.env``` and adjust as requried.

When ready, run the desired script relative to the PowerCheck Container root path, ```bin/dev.sh``` to start the development container.

### Development Container
To start the development container run ```bin/dev.sh``` (or ```bin\dev.bat``` if on Windows)from PowerCheck Container root path.
The development container will mount the local directories below into the container allowing the development IDE to be done outside the container. The container will be automatically removed when stopped.

```
./volumes/api to /opt/api
./volumes/web to /opt/web
```

The API and WEB applications won't start automatically in development, for this it is recommended to open two sessions into the development container and start the API and WEB applications as required.

Start React App in development container
```sh
$ cd /opt/web
$ yarn dev
```

Start NodeJS app in development container
```sh
$ cd /opt/api
$ npm run dev
```

The folloing ports are exposed by the development container.
- 7080: Nginx
- 8080: Reach App, web frontend
- 8081: NodeJS API

### Build Container image
To build the container image run ```bin/build.sh``` (or ```bin\build.bat``` if on Windows)

### Run Container image
The final image can be run by running ```bin/run.sh``` (or ```bin\run.bat``` if on Windows)
