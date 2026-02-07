FROM node:22

# create a working dir
WORKDIR /usr/src/app

# copy package.json and npm install packages
COPY package*.json ./
RUN npm install

# copy app source into the working dir
COPY . .

# open a port
EXPOSE 9080

# run the app
CMD [ "node", "server.js" ]
