FROM alpine:3.11.3

RUN apk add curl libuuid git alpine-sdk nasm fuse-dev && \
  cd /tmp && git clone https://github.com/FreeApophis/TrueCrypt.git && \
  curl -sSL 'https://github.com/wxWidgets/wxWidgets/releases/download/v2.8.12/wxWidgets-2.8.12.tar.gz' > /tmp/wx.tar.gz && \
  cd /tmp && tar -xzvf wx.tar.gz && rm wx.tar.gz && \
  cd /tmp/TrueCrypt && \
  make NOGUI=1 WX_ROOT=/tmp/wxWidgets-2.8.12 wxbuild && \
  mv /tmp/wxWidgets-2.8.12/include/wx /usr/include/wx

RUN cp /tmp/TrueCrypt/wxrelease/lib/wx/include/base-unicode-release-static-2.8/wx/setup.h /usr/include/wx/setup.h && \
  cp /tmp/TrueCrypt/Main/CommandLineInterface.cpp /tmp/TrueCrypt/Main/CommandLineInterface.cpp.bak && \
  cat /tmp/TrueCrypt/Main/CommandLineInterface.cpp.bak | sed s/.ToStdWstring\(\)/.ToAscii\(\)/ > /tmp/TrueCrypt/Main/CommandLineInterface.cpp && \
  cp /tmp/TrueCrypt/Main/Resources.cpp /tmp/TrueCrypt/Main/Resources.cpp.bak && \
  echo '#pragma GCC diagnostic ignored "-Wnarrowing"' > /tmp/TrueCrypt/Main/Resources.cpp && cat /tmp/TrueCrypt/Main/Resources.cpp.bak >> /tmp/TrueCrypt/Main/Resources.cpp && \
  ln -s /tmp/TrueCrypt/wxrelease/wx-config /usr/bin/wx-config && \
  cd /tmp/TrueCrypt && make NOGUI=1
