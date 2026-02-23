FROM node:20-alpine

WORKDIR /app

# Copy workspace configuration
COPY package.json yarn.lock turbo.json ./

# Copy package.json files for all workspaces (for dependency layer caching)
COPY apps/calendar/package.json ./apps/calendar/
COPY packages/data/package.json ./packages/data/
COPY packages/schema/package.json ./packages/schema/

# Install all dependencies
RUN yarn install --frozen-lockfile

# Copy all source code
COPY apps/calendar/ ./apps/calendar/
COPY packages/data/ ./packages/data/
COPY packages/schema/ ./packages/schema/

# Build all workspaces
RUN yarn build

EXPOSE 8080

CMD ["node", "apps/calendar/dist/index.js"]
