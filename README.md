# PocketBase & Litestream Example

This repo is a starting spot to use PocketBase as a framework with custom Go code that is backed up and restored via Litestream.

## Why does this exist?

I think that PocketBase is an amazing project that can accomplish 99% of what a side-hustle, POC, and even startup needs. However, when using as a framework, we need to be able update code without needing to manually back up the DB file. I wanted to deploy my code in a container to [Fly.io](https://fly.io), [GCP Cloud Run](https://cloud.google.com/run), or [AWS App Runner](https://aws.amazon.com/apprunner/) but still utilize the magic of Litestream. This repo allows you to copy/paste the starting files to do just that.

## Usage

### Prerequisites

You'll need to have an S3-compatible store to connect to. Please see the [Litestream Guides](https://litestream.io/guides/) to get set up on your preferred object store.

## Local Development

Since this is using PocketBase as a Go framework, you can run this locally with `go run main.go serve --http "localhost:8080"`

You will want to do this to not use your Litestream backed up DB in development.

## Deploying to production

### Cavitate

You'll notice that in this repo, the Dockerfile has these 3 `env` variables hard-coded

```docker
ENV LITESTREAM_ACCESS_KEY_ID=xxxxxxxxxxxxxxxxxxxx
ENV LITESTREAM_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
ENV REPLICA_URL="s3://YOUR_S3_BUCKET_NAME/db"
```

This is just for ease of deployment to get your container running in the cloud of your choice. You can deploy directly as-is if you want to keep the `ENV` variables in the Dockerfile.

However, if you want to replace the 3 hardcoded `ENV` variables in the Dockerfile, you can in a few ways.

1. For Fly.io you can use the `[env]` block in the `fly.toml`. [Reference page](https://fly.io/docs/languages-and-frameworks/dockerfile/#config-first).
2. For Google Cloud Run, you can set environment variables for your container See [this page on configuration info](https://cloud.google.com/run/docs/configuring/environment-variables).
3. For AWS App runner see [this page on configuring ENVs](https://docs.aws.amazon.com/apprunner/latest/dg/manage-configure.html) for your continer.
