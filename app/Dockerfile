ARG NODE_VERSION=24.7.0-alpine
FROM node:${NODE_VERSION} AS builder
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile # using frozen-lockfile to make sure that versioning is consistent
COPY . .
RUN yarn build

FROM node:${NODE_VERSION} AS runtime
WORKDIR /app
COPY --from=builder --chown=14444:14444 /app/build /app/build
RUN yarn global add serve
RUN addgroup -g 14444 test && adduser -D -u 14444 -G test TestSM
EXPOSE 3000
USER 14444:14444
CMD ["serve", "-s", "build"]
