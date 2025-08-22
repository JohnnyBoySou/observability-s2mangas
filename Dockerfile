FROM getsentry/sentry:latest

# Set working directory
WORKDIR /usr/src/sentry

# Copy environment configuration
COPY .env.example /usr/src/sentry/.env.example

# Expose the port Sentry runs on
EXPOSE 9000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --retries=3 --start-period=40s \
  CMD curl -f http://localhost:9000/api/0/ || exit 1

# Default command to run Sentry web server
CMD ["sentry", "run", "web"]