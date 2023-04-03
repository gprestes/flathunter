FROM python:3.10

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ARG PIP_NO_CACHE_DIR=1

# Install Google Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get -y update
RUN apt-get install -y google-chrome-stable

# Upgrade pip, install pipenv
RUN pip install --upgrade pip
RUN pip install pipenv

WORKDIR /usr/src/app

# Copy files that list dependencies
COPY Pipfile.lock Pipfile ./

# Generate requirements.txt and install dependencies from there
RUN pipenv requirements > requirements.txt
RUN pip install -r requirements.txt

# Copy all other files, including source files
COPY . .
