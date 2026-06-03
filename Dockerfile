FROM node:20-alpine AS builder

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install && npm cache clean --force
COPY . .
RUN npm run build

FROM nginx:alpine

# Remove config padrão
RUN rm -rf /etc/nginx/conf.d/default.conf

# Copia config customizada
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copia arquivos buildados
COPY --from=builder /app/dist /usr/share/nginx/html

# ✅ EXPOSE a porta 80 (nginx está configurado para listen 80)
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
