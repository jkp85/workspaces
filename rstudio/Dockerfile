# FROM illumidesk/core-server:build-119 AS core
FROM illumidesk/core-server:build-5 AS core
FROM rocker/rstudio:3.5.1

# Install R packages
RUN su - -c "R -e \"install.packages('devtools')\""

ENV ROOT TRUE

EXPOSE 8080

RUN echo "www-port=8888" > /etc/rstudio/rserver.conf
RUN echo "session-default-working-dir=/resources" > /etc/rstudio/rsession.conf
WORKDIR /resources

# Copy runner to end to avoid cache busting
COPY --from=core runner /runner
