FROM gcr.io/google_appengine/debian

RUN apt-get update --fix-missing

# Install packages
RUN apt-get install -yq \
    build-essential supervisor \
    python python-virtualenv python-pip \
    libffi-dev libssl-dev libglib2.0-0

RUN groupadd -r predictionsvc && useradd -r -g predictionsvc predictionsvc

# Copy app into /opt/app/
COPY app /opt/app/

# Change ownership
RUN chown -R predictionsvc:predictionsvc /opt/app/

# Copy config
COPY supervisord.conf /etc/supervisor/conf.d/gunicorn.conf

# Create python virtual environment
RUN virtualenv -p /usr/bin/python3 /opt/app/env

# Install dependencies
RUN /opt/app/env/bin/pip install -U pip
RUN /opt/app/env/bin/pip install -r /opt/app/requirements.txt

# Start the service
CMD supervisord -c /etc/supervisor/supervisord.conf -n

# expose port
EXPOSE 8080
