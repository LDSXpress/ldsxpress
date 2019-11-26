# Stage 1
FROM node:10-alpine as builder

COPY ./ldsxpress/ldsxpress-app/package.json ./
COPY ./ldsxpress/ldsxpress-app/package-lock.json ./

## Storing node modules on a separate layer will prevent unnecessary npm installs at each build
RUN npm ci \
    && mkdir /ng-app \
    && mv ./node_modules ./ng-app

WORKDIR /ng-app

COPY ./ldsxpress/ldsxpress-app/ .

## Build the angular app in production mode and store the artifacts in dist folder
RUN npm run ng build -- --prod --output-path=dist

# Stage 2: Setup
FROM nginx:1.14.1-alpine

## Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

## From 'builder' stage copy over the artifacts in dist folder to default nginx public folder
COPY --from=builder /ng-app/dist /usr/share/nginx/html

# Copy custom nginx config
COPY ./docker/config/nginx.conf /etc/nginx/conf.d/

CMD ["nginx", "-g", "daemon off;"]
