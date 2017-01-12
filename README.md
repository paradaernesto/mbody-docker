DockerFiles
===========

All the docker files to deploy [Apache Tomcat 7](http://tomcat.apache.org/download-70.cgi) in a docker container.

### Usage

```
#
# Optionally specify JAVA_OPTS to be added to default JAVA_OPTS for tomcat
#
# Optionally specify a custom Xmx parameter to replace default setting for tomcat
#
```

Then point your browser at [http://localhost:8080/](http://localhost:8080/)

or [http://192.168.59.103:8080/](http://192.168.59.103:8080/) if you are using boot2docker

## Building

To build the image, simply invoke

    docker build https://github.com/paradaernesto/mbody-docker

## Author

  * Ernesto PArada (<ernesto.parada@patagonian.it>)

## LICENSE

Copyright 2016

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
    
