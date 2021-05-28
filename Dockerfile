FROM node:14-slim AS build

RUN apt update && apt install -y rsync

WORKDIR /usr/build

COPY package.json yarn.lock ./
RUN yarn --frozen-lockfile

COPY . ./
RUN yarn build

FROM node:14-slim

RUN apt update && \
  apt install -y ffmpeg && \
  apt clean && apt autoclean
RUN ffmpeg -version

WORKDIR /usr/app

COPY package.json yarn.lock ./
RUN yarn --frozen-lockfile --production

COPY --from=build /usr/build/dist ./dist

CMD [ "yarn", "start:prod" ]
