#!/bin/bash

set -ex

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$BUILD_PREFIX/lib/pkgconfig
export PKG_CONFIG=$BUILD_PREFIX/bin/pkg-config

meson builddir/ \
  ${MESON_ARGS} \
  --buildtype=release \
  --prefix=$PREFIX \
  -Dplatforms=x11 \
  -Dgles1=false \
  -Dgles2=false \
  -Dgallium-va=disabled \
  -Dgbm=disabled \
  -Dgallium-xvmc=disabled \
  -Dgallium-vdpau=disabled \
  -Dshared-glapi=enabled \
  -Ddri3=disabled \
  -Ddri-drivers=[] \
  -Dglx=gallium-xlib \
  -Dgallium-drivers=swrast \
  -Degl=disabled \
  -Dllvm=false \
  -Dshared-llvm=false \
  -Dlibdir=lib \
  -Dosmesa=true \
  -Dvulkan-drivers=[] \
  -Dopengl=true \
  || { cat builddir/meson-logs/meson-log.txt; exit 1; }

ninja -C builddir/ -j ${CPU_COUNT}

ninja -C builddir/ install

# meson test -C builddir/ \
#   -t 4
