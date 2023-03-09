## Multistage build


FROM node:17-alpine as base
# Stage 1: Install dependencies
FROM base AS deps
WORKDIR /app
COPY package*.json .
ENV NODE_ENV production
RUN npm install


FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY src ./src
COPY public ./public
COPY package.json next.config.js tsconfig.json ./
RUN npm run build


FROM base
WORKDIR /app
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./
CMD ["npm", "run", "start"]