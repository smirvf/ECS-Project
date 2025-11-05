ARG NODE_VERSION=24.7.0-alpine
FROM node:${NODE_VERSION} AS builder
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile # using frozen-lockfile to make sure that versioning is consistent
COPY . .
RUN yarn build

FROM node:${NODE_VERSION} AS runtime
WORKDIR /app
COPY --from=builder /app/build /app/build
RUN yarn global add serve
EXPOSE 3000
CMD ["serve", "-s", "build"]
# Testing local prehooks
