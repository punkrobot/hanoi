# Single stage build - use pre-built Flutter web app
# Note: Make sure to run 'flutter build web --release' in the app/ directory before building Docker image
FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    nginx \
    supervisor \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy Flask API requirements and install Python dependencies
COPY api/requirements.txt ./api/
RUN pip install --no-cache-dir -r api/requirements.txt

# Copy Flask API source code
COPY api/ ./api/

# Copy pre-built Flutter web app (must exist in app/build/web/)
COPY app/build/web /var/www/html

# Create nginx configuration
RUN echo 'server { \
    listen 80; \
    server_name _; \
    \
    # Serve Flutter web app \
    location / { \
        root /var/www/html; \
        try_files $uri $uri/ /index.html; \
        \
        # Cache static assets \
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ { \
            expires 1y; \
            add_header Cache-Control "public, immutable"; \
        } \
    } \
    \
    # Proxy API requests to Flask \
    location /api/ { \
        proxy_pass http://127.0.0.1:8080; \
        proxy_set_header Host $host; \
        proxy_set_header X-Real-IP $remote_addr; \
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; \
        proxy_set_header X-Forwarded-Proto $scheme; \
    } \
    \
    # Health check endpoint \
    location /health { \
        proxy_pass http://127.0.0.1:8080; \
        proxy_set_header Host $host; \
        proxy_set_header X-Real-IP $remote_addr; \
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; \
        proxy_set_header X-Forwarded-Proto $scheme; \
    } \
}' > /etc/nginx/sites-available/default

# Create supervisor configuration
RUN echo '[supervisord] \
nodaemon=true \
\
[program:nginx] \
command=nginx -g "daemon off;" \
autostart=true \
autorestart=true \
stderr_logfile=/var/log/nginx.err.log \
stdout_logfile=/var/log/nginx.out.log \
\
[program:flask] \
command=python /app/api/app.py \
directory=/app \
autostart=true \
autorestart=true \
stderr_logfile=/var/log/flask.err.log \
stdout_logfile=/var/log/flask.out.log \
environment=FLASK_ENV=production' > /etc/supervisor/conf.d/supervisord.conf

# Expose port 80 for nginx
EXPOSE 80

# Start supervisor to manage nginx and flask
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]