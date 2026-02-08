# Frontend Dockerfile using nginx
FROM nginx:alpine

# Copy frontend HTML file to nginx default location
COPY frontend.html /usr/share/nginx/html/index.html

# Copy nginx configuration with reverse proxy setup
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
