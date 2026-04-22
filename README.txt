name: A31 Kernel Build (Auto-Patch Fix)
on: [push, workflow_dispatch]

jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: ubuntu:20.04
      options: --privileged

    steps:
    - name: Checkout Source
      uses: actions/checkout@v4

    - name: Auto-Patch Qualcomm Paths
      run: |
        # Jahan bhi <soc/qcom/...> hai use <linux/soc/qcom/...> se badal do
        echo "Patching header paths for Oppo Secure Drivers..."
        find kernel-4.9 -type f \( -name "*.c" -o -name "*.h" \) -exec sed -i 's|<soc/qcom/|<linux/soc/qcom/|g' {} +
        echo "Patching completed."

    - name: Install Build Packages (In-Container)
      run: |
        export DEBIAN_FRONTEND=noninteractive
        apt-get update
        apt-get install -y \
        python2 python-is-python2 git ccache automake flex lzop bison gperf \
        build-essential zip curl zlib1g-dev g++-multilib libxml2-utils bzip2 \
        libbz2-dev libghc-bzlib-dev squashfs-tools pngcrush schedtool dpkg-dev \
        liblz4-tool make optipng maven libssl-dev pwgen bc libc6-dev-i386 \
        libx11-dev lib32z-dev libgl1-mesa-dev xsltproc unzip \
        device-tree-compiler libncurses5 libtinfo5 wget

    - name: Download Toolchains
      run: |
        mkdir -p tools
        # KAGA-KOKO Clang 6.0.2
        git clone https://github.com/KAGA-KOKO/clang-6.0.2 -b clang --depth=1 tools/clang
        # AOSP GCC 4.9
        git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 -b ndk-release-r16 --depth=1 tools/gcc64
        git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9 -b ndk-release-r16 --depth=1 tools/gcc32

    - name: Compile Kernel
      run: |
        export PATH=$(pwd)/tools/clang/bin:$(pwd)/tools/gcc64/bin:$(pwd)/tools/gcc32/bin:$PATH
        export ARCH=arm64
        export SUBARCH=arm64
        export CLANG_TRIPLE=aarch64-linux-gnu-
        export CROSS_COMPILE=aarch64-linux-android-
        export CROSS_COMPILE_ARM32=arm-linux-androideabi-
        
        cd kernel-4.9
        make O=out mrproper
        make O=out oppo6765_19581_defconfig
        
        # Build command
        make -j$(nproc) O=out \
             CC=clang \
             CLANG_TRIPLE=$CLANG_TRIPLE \
             CROSS_COMPILE=$CROSS_COMPILE \
             CROSS_COMPILE_ARM32=$CROSS_COMPILE_ARM32 \
             Image.gz-dtb

    - name: Upload Build Artifacts
      uses: actions/upload-artifact@v4
      with:
        name: A31-Kernel-Image
        path: |
          kernel-4.9/out/arch/arm64/boot/Image.gz-dtb
          kernel-4.9/out/.config
