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

# EXPOSE a porta 3000 (Padrão esperado por muitas ferramentas PaaS)
EXPOSE 3000

CMD ["nginx", "-g", "daemon off;"]
