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

# Create directories for n8n data
RUN mkdir -p /home/node/.n8n

# Copy the workflow file
COPY workflows/ /home/node/.n8n/workflows/

# Set proper permissions
RUN chown -R node:node /home/node/.n8n

# Expose the port
EXPOSE 5678

# Switch to node user
USER node

# Start n8n
CMD ["n8n", "start"]
