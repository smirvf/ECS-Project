ARG NODE_VERSION=24.7.0-alpine
ARG NGINX_VERSION=alpine3.22.3

FROM node:${NODE_VERSION} AS builder
WORKDIR /app
COPY /app/package.json /app/yarn.lock ./
RUN yarn install --frozen-lockfile # using frozen-lockfile to make sure that versioning is consistent
COPY /app .
RUN yarn build

#FROM node:${NODE_VERSION} AS runtime
#WORKDIR /app
#COPY --from=builder /app/build /app/build
#COPY --from=builder --chown=14444:14444 /app/build /app/build
#RUN yarn global add serve
#RUN addgroup -g 14444 test && adduser -D -u 14444 -G test TestSM
#EXPOSE 3000
#USER 14444:14444
#CMD ["serve", "-s", "build"]
#test line

FROM nginxinc/nginx-unprivileged:${NGINX_VERSION} AS runner

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
