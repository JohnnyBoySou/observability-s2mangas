"""
Sentry configuration for Railway deployment
This file handles the Redis URL parsing for Railway deployment
"""

import os
from urllib.parse import urlparse

# Parse Redis URL from Railway if provided
redis_url = os.environ.get('REDIS_PRIVATE_URL') or os.environ.get('REDIS_URL')
if redis_url:
    parsed = urlparse(redis_url)
    # Extract components from Redis URL
    REDIS_HOST = parsed.hostname
    REDIS_PORT = parsed.port or 6379
    REDIS_DB = parsed.path.lstrip('/') or '0'
    
    # Set the Redis configuration for Sentry
    SENTRY_REDIS_HOST = REDIS_HOST
    SENTRY_REDIS_PORT = REDIS_PORT
    SENTRY_REDIS_DB = REDIS_DB
    
    # Also set the legacy Docker link format as fallback
    os.environ['REDIS_PORT_6379_TCP_ADDR'] = REDIS_HOST
    os.environ['REDIS_PORT_6379_TCP_PORT'] = str(REDIS_PORT)
    
    # Set Sentry Redis config
    os.environ['SENTRY_REDIS_HOST'] = REDIS_HOST
    os.environ['SENTRY_REDIS_PORT'] = str(REDIS_PORT)
    os.environ['SENTRY_REDIS_DB'] = str(REDIS_DB)

# Default Redis configuration if no Railway URL provided
elif not os.environ.get('SENTRY_REDIS_HOST'):
    # Use default values for local development
    os.environ.setdefault('SENTRY_REDIS_HOST', 'redis')
    os.environ.setdefault('SENTRY_REDIS_PORT', '6379')
    os.environ.setdefault('SENTRY_REDIS_DB', '0')