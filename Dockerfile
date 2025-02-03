FROM mcr.microsoft.com/playwright:v1.39.0-jammy
RUN npm install -g netlify-cli node-jq serve
RUN apt-get update && apt-get install -y jq
