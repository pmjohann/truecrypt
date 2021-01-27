FROM alpine:3.13

#ARG WX_VERSION=2.8.12
ARG WX_VERSION=2.9.5

RUN apk add --no-cache libuuid git alpine-sdk nasm fuse-dev && \
  cd /tmp && git clone https://github.com/FreeApophis/TrueCrypt.git && \
  wget -O /tmp/wx.tar.gz "https://github.com/wxWidgets/wxWidgets/archive/v${WX_VERSION}.tar.gz" && \
  cd /tmp && tar -xzvf wx.tar.gz && rm wx.tar.gz && cd /tmp/TrueCrypt && \
  make NOGUI=1 WX_ROOT=/tmp/wxWidgets-${WX_VERSION} wxbuild && \
  mv /tmp/wxWidgets-${WX_VERSION}/include/wx /usr/include/wx

RUN ls -al /tmp/TrueCrypt/wxrelease/lib/wx/include && cp /tmp/TrueCrypt/wxrelease/lib/wx/include/base-unicode-static-2.9/wx/setup.h /usr/include/wx/setup.h && \
  cp /tmp/TrueCrypt/Main/CommandLineInterface.cpp /tmp/TrueCrypt/Main/CommandLineInterface.cpp.bak && \
  cat /tmp/TrueCrypt/Main/CommandLineInterface.cpp.bak | sed s/.ToStdWstring\(\)/.utf8_str\(\)/ > /tmp/TrueCrypt/Main/CommandLineInterface.cpp && \
  cp /tmp/TrueCrypt/Main/Resources.cpp /tmp/TrueCrypt/Main/Resources.cpp.bak && \
  echo '#pragma GCC diagnostic ignored "-Wnarrowing"' > /tmp/TrueCrypt/Main/Resources.cpp && cat /tmp/TrueCrypt/Main/Resources.cpp.bak >> /tmp/TrueCrypt/Main/Resources.cpp && \
  ln -s /tmp/TrueCrypt/wxrelease/wx-config /usr/bin/wx-config && \
  cd /tmp/TrueCrypt && make NOGUI=1 && \
  cp /tmp/TrueCrypt/Main/truecrypt /usr/local/bin/truecrypt
