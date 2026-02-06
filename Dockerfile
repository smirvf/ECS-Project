ARG NODE_VERSION=dhi.io/node:24-alpine3.22-dev
ARG NGINX_VERSION=dhi.io/nginx:1.28.0-alpine3.21-dev

FROM ${NODE_VERSION} AS builder

WORKDIR /app

COPY /app/package.json /app/yarn.lock ./

RUN yarn install --frozen-lockfile # using frozen-lockfile to make sure that versioning is consistent

COPY /app .

RUN yarn build

FROM ${NGINX_VERSION} AS runner

# Use a built-in non-root user for security best practices
USER nginx

# Copy custom Nginx config
COPY /app/nginx/nginx.conf /etc/nginx/nginx.conf

# Copy the static build output from the build stage to Nginx's default HTML serving directory
COPY --chown=nginx:nginx --from=builder /app/build /usr/share/nginx/html

# Expose port 8080 to allow HTTP traffic
# Note: The default NGINX container now listens on port 8080 instead of 80
EXPOSE 8080

# Start Nginx directly with custom config
ENTRYPOINT ["nginx", "-c", "/etc/nginx/nginx.conf"]
CMD ["-g", "daemon off;"]
