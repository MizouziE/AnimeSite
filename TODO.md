### Commands ran from the host machine
```bash
$ docker cp <path/to/root>/src <container-name>:/projects/workspace
```

### Commands ran inside the container
```bash
<container-name>:/projects/workspace# cd src
<container-name>:/projects/workspace/src# mv * ../
<container-name>:/projects/workspace/src# cd ..
<container-name>:/projects/workspace# rm -r src
```