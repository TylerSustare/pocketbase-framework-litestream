FROM golang:1.19

WORKDIR /usr/src/app

# Copy go files
COPY go.mod go.sum main.go ./

# Build the binary
RUN go mod download && go mod verify
RUN go build -v -o /usr/local/bin/app ./...

# Set ENVs
# Alternatively, you can pass in via `-e` flag to `docker run` like https://github.com/benbjohnson/litestream-docker-example
# These are in the Dockerfile for simplicity of deploying
ENV LITESTREAM_ACCESS_KEY_ID=xxxxxxxxxxxxxxxxxxxx
ENV LITESTREAM_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
ENV REPLICA_URL="s3://YOUR_S3_BUCKET_NAME/db"

# Download the static build of Litestream directly into the path & make it executable.
# This is done in the builder and copied as the chmod doubles the size.
# Note: You will want to mount your own Litestream configuration file at /etc/litestream.yml in the container.
# Example: https://github.com/benbjohnson/litestream-docker-example or https://litestream.io/guides/docker/
ADD https://github.com/benbjohnson/litestream/releases/download/v0.3.9/litestream-v0.3.9-linux-amd64-static.tar.gz /tmp/litestream.tar.gz
RUN tar -C /usr/local/bin -xzf /tmp/litestream.tar.gz

# Notify Docker that the container wants to expose a port.
# Pocketbase serve port
# Use port 8080 for deploying to Fly.io, GCP Cloud Run, or AWS App Runner easily.
EXPOSE 8080 
# For the litestream server via Prometheus if using https://litestream.io/reference/config/#metrics
# EXPOSE 9090 

# Copy Litestream configuration file & startup script.
COPY etc/litestream.yml /etc/litestream.yml
COPY scripts/run.sh /scripts/run.sh

RUN chmod +x /scripts/run.sh
RUN chmod +x /usr/local/bin/litestream

# Start Pocketbase
CMD [ "/scripts/run.sh" ]
