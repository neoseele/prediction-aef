FROM gcr.io/google_appengine/debian

ENV USER="predictionsvc" GROUP="predictionsvc" APP="/opt/app"

RUN apt-get update --fix-missing

# Install packages
RUN apt-get install -yq --no-install-recommends \
    supervisor virtualenv \
    python python-virtualenv python-pip \
    libglib2.0-0

# Create user and group
RUN groupadd -r $GROUP && useradd -r -g $GROUP $USER

# Copy app into /opt/app/
COPY app $APP

# Change ownership
RUN chown -R $USER:$GROUP $APP

# Create python virtual environment
RUN virtualenv -p /usr/bin/python3 ${APP}/env

# Install dependencies
RUN ${APP}/env/bin/pip install -U pip
RUN ${APP}/env/bin/pip install -r ${APP}/requirements.txt

# Copy config
COPY supervisord.conf /etc/supervisor/conf.d/gunicorn.conf

# Start the service
CMD ["supervisord","-c","/etc/supervisor/supervisord.conf","-n"]

# expose port
EXPOSE 8080
