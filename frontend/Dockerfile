# Build stage
FROM node:24-alpine AS build

WORKDIR /app
COPY . .
RUN npm install && npm run build

# Production stage
FROM httpd:2.4-alpine

# Copy build output to Apache's web root
COPY --from=build /app/dist/ /usr/local/apache2/htdocs/

EXPOSE 80

CMD ["httpd-foreground"]
