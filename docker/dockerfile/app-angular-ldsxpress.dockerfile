# Stage 1
FROM node:8.16.2-alpine as node
ARG WORKDIR=/usr/src/app
WORKDIR ${WORKDIR}

COPY ./ldsxpress/ldsxpress-app/package.json ./

RUN npm install

COPY ./ldsxpress/ldsxpress-app/ .

RUN npm run build

# Stage 2
FROM nginx:stable-alpine

COPY --from=node /usr/src/app /usr/share/nginx/html
COPY ./docker/dockerfile/app-angular-nginx.conf /etc/nginx/conf.d/default.conf
