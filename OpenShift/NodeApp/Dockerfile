# Use an existing docker image as base 
FROM node:alpine
# Make WORKDIR (will be created)
WORKDIR /usr/app
# Add files we do want to make sure that we will not put folders to root directory
# ONLY Package.json
COPY ./package.json ./
# Install dependencies 
RUN npm install
# COPY rest of the files
COPY ./ ./
# Open Port on Docker Box (not necessary at this case)
EXPOSE 8080
EXPOSE 9999
# Run application
ENTRYPOINT ["npm", "start"]
