FROM python:3.6.5-stretch
MAINTAINER Sandeep Srinivasa "sss@lambdacurry.com"
ENV DEBIAN_FRONTEND noninteractive


RUN pip install Cython
RUN pip install Pillow
RUN apt-get update && apt-get install -y \
    autoconf automake libtool \
    rsync \
    libpng-dev \
    libjpeg-dev \
    libtiff-dev \
    zlib1g-dev
RUN wget http://www.leptonica.org/source/leptonica-1.73.tar.gz -O /tmp/leptonica.tar.gz && tar -xvf /tmp/leptonica.tar.gz --directory /tmp
ARG CACHE_DATE=2016-01-01
WORKDIR /tmp/leptonica-1.73
RUN ./configure && make &&  make install
WORKDIR /tmp
RUN wget https://github.com/tesseract-ocr/tesseract/archive/3.04.01.tar.gz -O /tmp/tesseract.tar.gz && tar -xvf /tmp/tesseract.tar.gz --directory /tmp
WORKDIR /tmp/tesseract-3.04.01
RUN ./autogen.sh && ./configure && LDFLAGS=\"-L/usr/local/lib\" CFLAGS=\"-I/usr/local/include\" make &&  make install &&  ldconfig
WORKDIR /tmp
RUN wget https://github.com/tesseract-ocr/tessdata/archive/3.04.00.tar.gz -O /tmp/tessdata.tar.gz && tar -xvf /tmp/tessdata.tar.gz --directory /tmp
RUN  mkdir -p /usr/local/share/tessdata/ &&  rsync -a tessdata-3.04.00/ /usr/local/share/tessdata
RUN git clone https://github.com/sirfz/tesserocr.git 
WORKDIR /tmp/tesserocr
RUN python setup.py bdist_wheel
RUN python setup.py install
