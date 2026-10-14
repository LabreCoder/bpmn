# syntax=docker/dockerfile:1

# ---- Build stage ----
FROM node:22-alpine AS build
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY webpack.config.js ./
COPY src ./src
COPY diagrams ./diagrams
RUN npx webpack --config webpack.config.js --mode production

# ---- Runtime stage ----
FROM nginx:alpine

# Mesmo layout do dev server: src/ e diagrams/ servidos na raiz
COPY --from=build /app/src/index.html /app/src/viewer.html /app/src/diagram.bpmn /usr/share/nginx/html/
COPY --from=build /app/src/themes /usr/share/nginx/html/themes
COPY --from=build /app/diagrams /usr/share/nginx/html/
COPY --from=build /app/dist /usr/share/nginx/html/

EXPOSE 80
