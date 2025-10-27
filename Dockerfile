# Use the official n8n Docker image
FROM n8nio/n8n:latest

# Set environment variables
ENV N8N_BASIC_AUTH_ACTIVE=true
ENV N8N_BASIC_AUTH_USER=admin
ENV N8N_BASIC_AUTH_PASSWORD=changeme123
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=5678
ENV N8N_PROTOCOL=http
ENV WEBHOOK_URL=https://your-app-name.onrender.com
ENV GENERIC_TIMEZONE=UTC

# Use root user for setup
USER root

# Copy and set permissions in one step
COPY --chown=node:node workflows/ /home/node/.n8n/workflows/

# Switch to node user
USER node

# Expose the port
EXPOSE 5678

# Start n8n (let the base image's default command handle it)
CMD ["n8n"]
