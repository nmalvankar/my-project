FROM registry.access.redhat.com/ubi8/nodejs-16:1-42 as build-stage
USER root
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY package.json /usr/src/app
RUN npm install
COPY . /usr/src/app
ENV PATH /usr/src/app/node_modules/.bin:$PATH
RUN ng build --configuration=production

FROM nginx:latest
COPY --from=build-stage /usr/src/app/dist/my-project/ /usr/share/nginx/html
COPY --from=build-stage /usr/src/app/nginx.conf /etc/nginx/conf.d/default.conf
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf
EXPOSE 8080
