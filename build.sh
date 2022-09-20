#!/bin/bash

set -ex

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$BUILD_PREFIX/lib/pkgconfig:/usr/lib64/pkgconfig:/usr/share/pkgconfig
export PKG_CONFIG=$BUILD_PREFIX/bin/pkg-config

export C_INCLUDE_PATH=/usr/include:$C_INCLUDE_PATH

meson builddir/ \
  ${MESON_ARGS} \
  --buildtype=release \
  --prefix=$PREFIX \
  -Dplatforms=x11 \
  -Dlibdir=lib \
  -Dgles1=disabled \
  -Dgles2=disabled \
  -Dgallium-va=disabled \
  -Dgbm=disabled \
  -Degl=disabled \
  -Dgallium-xvmc=disabled \
  -Dgallium-vdpau=disabled \
  -Ddri-drivers=[] \
  -Dvulkan-drivers=[] \
  -Dllvm=true \
  -Dshared-llvm=true \
  -Dlibunwind=false \
  -Dglx=gallium-xlib \
  -Dgallium-drivers=swrast \
  -Dosmesa=true \
  -Dopengl=true \
  || { cat builddir/meson-logs/meson-log.txt; exit 1; }

ninja -C builddir/ -j ${CPU_COUNT}

ninja -C builddir/ install

# meson test -C builddir/ \
#   -t 4

