# This Dockerfile was inspired by https://github.com/vercel/next.js/tree/canary/examples/with-docker

# 1. Install dependencies only when needed
FROM node:18-alpine
# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat
RUN npm install -g npm@latest
WORKDIR /app
# COPY package.json package-lock.json ./
# RUN npm ci

# If using yarn comment out above and use below instead
# COPY package.json yarn.lock ./
# RUN yarn install --frozen-lockfile

# 2. Rebuild the source code only when needed
# FROM node:16-alpine AS builder
# WORKDIR /app
# COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Next.js collects completely anonymous telemetry data about general usage.
# Learn more here: https://nextjs.org/telemetry
# Comment the following line in case you want to enable telemetry during the build.
# ENV NEXT_TELEMETRY_DISABLED 1

# Use the corresponding env file for each environment
# ARG DOT_ENV_PRODUCTION_FILE=.env
# COPY ${DOT_ENV_PRODUCTION_FILE} .env

# RUN npm run build
# If using yarn comment out above and use below instead
RUN npm run build

# 3. Production image, copy all the files and run next
# FROM node:18-alpine AS runner
# WORKDIR /app

# ENV NODE_ENV production

# Comment the following line in case you want to enable telemetry during runtime.
# ENV NEXT_TELEMETRY_DISABLED 1

# Create a non-root user with an explicit UID and add permission to access the /app folder
# RUN addgroup --system --gid 1001 nodejs
# RUN adduser --system --uid 1001 nextjs

# COPY --from=builder /app ./

# USER nextjs

EXPOSE 3000

ENV PORT 3000

CMD ["npm", "start"]