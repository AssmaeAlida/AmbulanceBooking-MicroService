# Étape 1 : Image de base avec Node.js
FROM node:18 AS builder

# Étape 2 : Définir le dossier de travail
WORKDIR /app

# Étape 3 : Copier uniquement les fichiers nécessaires pour npm install
COPY package*.json ./

# Étape 4 : Nettoyer le cache npm et installer les dépendances
RUN npm cache clean --force && npm install

# Étape 5 : Copier le reste des fichiers
COPY . .

# Étape 6 : Construire le projet
RUN npm run build

# Étape 7 : Image finale avec NGINX
FROM nginx:1.23
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
