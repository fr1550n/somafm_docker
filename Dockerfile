# syntax=docker/dockerfile:1


# guides:	https://iotbytes.wordpress.com/create-your-first-docker-container-for-raspberry-pi-to-blink-an-led/
#		https://docs.docker.com/language/python/build-images/#create-a-dockerfile-for-python		
# Dockerfile	https://docs.docker.com/engine/reference/builder/
# ye olde way:	https://github.com/fr1550n/soma_fm_pi_radio/blob/master/README.md


# python arm32 buster image: https://hub.docker.com/r/arm32v7/python/
# original soma pi code runs on python 3.7.3 but 3.7.10 should be OK
# docker run -it cdec3f16b204 /bin/bash (explore the base image)
# docker build -t "somafm:v3" .
FROM arm32v7/python:3.7.10-buster

RUN curl -sS https://get.pimoroni.com/gfxhat | bash

# install the python dependencies, I ran: 
# `pip3 freeze > requirements.txt` 
# on the somafm pi, probably overkill..
# we need gfxhat and python-vlc
WORKDIR /app
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
#CMD ["/bin/bash"]

# update old gfx-hat library: git clone https://github.com/pimoroni/gfx-hat
WORKDIR /usr/local/lib/python3.7/site-packages
RUN mkdir old && mv gfxhat old
COPY gfx-hat/library/gfxhat ./gfxhat





# grab my code 
WORKDIR /app
RUN git clone https://github.com/fr1550n/soma_fm_pi_radio.git
WORKDIR soma_fm_pi_radio
CMD ["python", "./main.py"]

