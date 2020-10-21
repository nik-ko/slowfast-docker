nvidia-docker run --shm-size 40G --rm -it -d -v $(pwd)/data/:/data -p 22:22 -p 8888:8888 -p 6006:6006 --name slowfast hnko/slowfast
