FROM mcr.microsoft.com/playwright:v1.39.0-jammy
RUN apt-get update && apt-get install -y jq
