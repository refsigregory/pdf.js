# ── Build stage ─────────────────────────────────────────────────────────────
FROM node:22-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npx gulp generic

# ── Production stage ─────────────────────────────────────────────────────────
FROM nginx:stable-alpine

# Remove nginx default files then copy pdfjs build
RUN rm -rf /usr/share/nginx/html/* \
    && sed -i 's|application/javascript.*js;|application/javascript js mjs;|' /etc/nginx/mime.types
COPY --from=builder /app/build/generic /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
