# I Use the Node.js 14 base image for building the application
FROM node:14 As build


# Set the working directory inside the container
WORKDIR /muthu


# Copy package.json and package-lock.json to the working directory
COPY *.json .


# Install the application dependencies
RUN npm install


# Copy the rest of the application source code
COPY . ./


# Build the application
RUN npm run build


# Use the Nginx Alpine for the production container
FROM nginx:alpine


# Copy the built application files to the Nginx HTML directory
COPY --from=build /muthu/build/ /usr/share/nginx/html


# Start the Nginx server
CMD ["nginx", "-g", "daemon off;"]