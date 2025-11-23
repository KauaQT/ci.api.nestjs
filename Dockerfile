FROm node:24 AS build

WORKDIR usr/src/app

COPY package.json package-lock.json ./

RUN npm install
COPY . .

RUN npm run build
RUN npm ci --production && npm cache clean --force

FROM node:24-alpine3.22

WORKDIR usr/src/app

COPY --from=build usr/src/app/package.json ./package.json
COPY --from=build usr/src/app/dist ./dist
COPY --from=build usr/src/app/node_modules ./node_modules

EXPOSE 3000

CMD ["npm", "run", "start:prod"]