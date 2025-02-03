FROM mcr.microsoft.com/playwright:v1.39.0-jammy

# Update package lists and install jq
RUN apt-get update && apt-get install -y --no-install-recommends jq && rm -rf /var/lib/apt/lists/*

# Install required npm packages globally
RUN npm install -g netlify-cli node-jq serve
