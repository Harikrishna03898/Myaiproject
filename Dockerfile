# Python version
FROM python:3.11.7-slim as Base

# Healthcheck
RUN apt-get Update && apt-get install -y --no-install-recommends curl

# working directory
WORKDIR /app

# Copying only requirements file first for better caching
COPY requirements.txt /app

# Installing dependencies and also for reducing caching
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application files
COPY . /app/

# Use a non-root user for security
RUN groupadd -r Pythonapp && useradd --no-log-init -r -g flask flask
USER flask

# Expose the application's port
EXPOSE 5000

# Start the Flask application using Gunicorn
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "chatapp.py:app"]
