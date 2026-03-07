FROM node:20-alpine

WORKDIR /app

# Copy workspace configuration
COPY package.json yarn.lock turbo.json ./

# Copy package.json files for all workspaces (for dependency layer caching)
COPY apps/calendar/package.json ./apps/calendar/
COPY packages/data/package.json ./packages/data/
COPY packages/schema/package.json ./packages/schema/

# Install all dependencies, skipping post-install scripts to avoid
# turbo binary installation issues in Docker build environment
RUN yarn install --frozen-lockfile --ignore-scripts

# Copy all source code
COPY apps/calendar/ ./apps/calendar/
COPY packages/data/ ./packages/data/
COPY packages/schema/ ./packages/schema/

# Build each workspace directly without turbo
RUN yarn workspace @tt-calendar/schema build && \
    yarn workspace @tt-calendar/data build && \
    yarn workspace tt-calendar build

EXPOSE 8080

CMD ["node", "apps/calendar/dist/index.js"]
