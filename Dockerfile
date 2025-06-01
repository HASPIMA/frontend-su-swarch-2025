FROM node:22.16.0-alpine

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

# Set NODE_ENV and MODE based on build arg
ENV NODE_ENV=${mode/dev/development}
ENV NODE_ENV=${NODE_ENV/prod/production}
ENV MODE=${mode}

RUN echo "Running in $mode mode with NODE_ENV=$NODE_ENV"

EXPOSE 3000

# This forces the scripts to run on build time
RUN npm run pre:${mode}:start

# Set up script selection based on mode
ENTRYPOINT ["sh", "-c", "exec npm run $MODE:start"]
