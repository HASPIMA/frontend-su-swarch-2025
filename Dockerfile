FROM node:22-alpine

WORKDIR /app

COPY package*.json ./

# Install packages and disable Next.js telemetry
RUN npm install && \
    npx next telemetry disable

COPY . .

# The default value is `prod`
#   `prod` -> production
#   `dev` -> development
ARG mode=prod

# Set NODE_ENV based on mode
ENV NODE_ENV=${mode/dev/development}
ENV NODE_ENV=${NODE_ENV/prod/production}

RUN echo "Running in $mode mode with NODE_ENV=$NODE_ENV"

EXPOSE 3000

# Pass mode as an environment variable to be used by npm scripts
ENV MODE=${mode}
CMD ["npm", "run", "${MODE}:start"]

