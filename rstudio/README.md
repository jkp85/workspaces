# R IDE

R IDE Images with Deep Learning for use with [IllumiDesk](https://www.illumidesk.com).

## What it Gives You

* Everything in [rocker/rstudio](https://hub.docker.com/r/rocker/rstudio/)

## Basic Use

The following commands start a container with the R IDE listening for HTTP connections on port 8888. User ID and password are set to `rstudio`.

```
docker run -it --rm -p 8888:8888 illumidesk/rstudio-notebook
```
