FROM python:3.9.21

RUN useradd -m myuser -d /var/app
#RUN mkdir /var/app

# Set the working directory
WORKDIR /var/app

# Copy app files (before switching user)
COPY . .

# Install dependencies as root
RUN apt update -y
RUN pip3 install --upgrade pip
RUN pip install --no-cache-dir -r requirement.txt

RUN chown -R myuser /var/app
RUN chmod +x ./entrypoint.sh
# Switch to non-root user
USER myuser

# Collect static files
ENTRYPOINT ["/bin/sh", "-c", "/var/app/entrypoint.sh"]
