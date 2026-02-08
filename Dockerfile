ARG NODE_VERSION=24.7.0-alpine
ARG NGINX_VERSION=alpine3.23

# Building Stage
FROM node:${NODE_VERSION} AS builder

# Setting Work Dir
WORKDIR /app

# Copying only the package.json + yarn.lock  - this layer is unlikely to change as much
# Hence we copy this first to benefit from layer caching
COPY /app/package.json /app/yarn.lock ./

RUN yarn install --frozen-lockfile # using frozen-lockfile to make sure that versioning is consistent

# Copy the rest of the project files over
COPY /app .

# Build application
RUN yarn build

# Runner Stage
FROM nginxinc/nginx-unprivileged:${NGINX_VERSION} AS runner

# Use a built-in non-root user for security best practices
USER nginx

# Copy custom Nginx config (with /health check)
COPY /app/nginx/nginx.conf /etc/nginx/nginx.conf

# Copy the static build output from the build stage to Nginx's default HTML serving directory
# (reducing file size as we don't unnecessary files)
COPY --chown=nginx:nginx --from=builder /app/build /usr/share/nginx/html

# Expose port 8080 to allow HTTP traffic
# Note: The default NGINX container now listens on port 8080 instead of 80
EXPOSE 8080

# Start Nginx directly with custom config
ENTRYPOINT ["nginx", "-c", "/etc/nginx/nginx.conf"]
CMD ["-g", "daemon off;"]
