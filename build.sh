#!/bin/bash

# Color
green='\033[0;32m'
echo -e "$green"

# Clone depedencies
git clone --depth=1 https://github.com/kdrag0n/proton-clang -b master ~/ether/clang
git clone --depth=1 https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 -b android-10.0.0_r20 ~/ether/gcc64
git clone --depth=1 https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9 -b android-10.0.0_r14 ~/ether/gcc32

# Main Environment
KERNEL_DIR=$(pwd)
PARENT_DIR="$(dirname "$KERNEL_DIR")"
KERN_IMG=$KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb
CONFIG_PATH=$KERNEL_DIR/arch/arm64/configs/etherious_defconfig

# Paths Setup
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER="SonalSingh18"
export KBUILD_BUILD_HOST="Etherious"
export PATH="/home/ubuntu/ether/clang/bin:$PATH"
export LD_LIBRARY_PATH="/home/ubuntu/ether/clang/lib:/home/ubuntu/ether/clang/lib64:$LD_LIBRARY_PATH"
export CROSS_COMPILE=/home/ubuntu/ether/gcc64/bin/aarch64-linux-android-
export CROSS_COMPILE_ARM32=/home/ubuntu/ether/gcc32/bin/arm-linux-androideabi-
export KBUILD_COMPILER_STRING="$(/home/ubuntu/ether/clang/bin/clang --version | head -n 1 | perl -pe 's/\((?:http|git).*?\)//gs' | sed -e 's/ */ /g' -e 's/[[:space:]]*$//' -e 's/^.*clang/clang/')"

mkdir -p out

make O=out ARCH=arm64 etherious_defconfig

make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      CC="/home/ubuntu/ether/clang/bin/clang" \
                      CLANG_TRIPLE="aarch64-linux-gnu-" \
                      LLVM="llvm-" \
                      AR=llvm-ar \
                      NM=llvm-nm \
                      OBJCOPY=llvm-objcopy \
                      OBJDUMP=llvm-objdump \
                      STRIP=llvm-strip
