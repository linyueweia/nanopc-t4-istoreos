#!/bin/bash
# iStoreOS NanoPC-T4 本地编译脚本
# 仅编译 NanoPC-T4 固件

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="${SCRIPT_DIR}/source"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 检查系统
check_system() {
    if [[ "$OSTYPE" != "linux-gnu"* ]]; then
        log_error "仅支持 Linux 系统"
        exit 1
    fi
    log_info "系统检查通过"
}

# 安装编译依赖
install_deps() {
    log_info "安装编译依赖..."
    sudo apt-get update
    sudo apt-get -y install \
        ack antlr3 asciidoc autoconf automake autopoint binutils \
        bison build-essential bzip2 ccache cmake cpio curl \
        device-tree-compiler ecj fastjar flex gawk gettext gcc-multilib \
        g++-multilib git gnutls-dev gperf haveged help2man intltool \
        lib32gcc-s1 libc6-dev-i386 libelf-dev libglib2.0-dev libgmp3-dev \
        libltdl-dev libmpc-dev libmpfr-dev libncurses5-dev \
        libncursesw5-dev libpython3-dev libreadline-dev libssl-dev \
        libtool libz-dev lrzsz mkisofs msmtp nano ninja-build p7zip \
        p7zip-full patch pkgconf python3 python3-pip \
        python3-ply python3-pyelftools python3-setuptools \
        qemu-utils rsync scons squashfs-tools subversion swig \
        texinfo uglifyjs unzip vim wget xmlto xxd zlib1g-dev
    log_info "依赖安装完成"
}

# 克隆源码
clone_source() {
    if [ -d "$SOURCE_DIR" ]; then
        log_warn "源码目录已存在: $SOURCE_DIR"
        read -p "是否重新克隆? (y/N): " confirm
        if [[ "$confirm" != [yY] ]]; then
            log_info "使用现有源码"
            return 0
        fi
        rm -rf "$SOURCE_DIR"
    fi

    log_info "克隆 iStoreOS 源码 (istoreos-24.10)..."
    git clone --depth 1 -b istoreos-24.10 https://github.com/istoreos/istoreos.git "$SOURCE_DIR"
    log_info "源码克隆完成"
}

# 更新 feeds
update_feeds() {
    log_info "更新 feeds..."
    cd "$SOURCE_DIR"
    ./scripts/feeds update -a
    ./scripts/feeds install -a
    log_info "feeds 更新完成"
}

# 应用配置
apply_config() {
    log_info "应用 NanoPC-T4 编译配置..."
    cd "$SOURCE_DIR"
    cp "${SCRIPT_DIR}/.config" .config
    make defconfig
    log_info "配置应用完成"
}

# 下载软件包
download_packages() {
    log_info "下载软件包..."
    cd "$SOURCE_DIR"
    make download -j$(nproc) V=s
    log_info "软件包下载完成"
}

# 编译固件
build_firmware() {
    log_info "开始编译 iStoreOS for NanoPC-T4..."
    log_info "这将需要数小时，请耐心等待..."
    cd "$SOURCE_DIR"
    
    # 尝试多线程编译，失败则单线程
    make -j$(nproc) V=s || make -j1 V=s
    
    log_info "编译完成!"
}

# 显示结果
show_result() {
    log_info "编译产物:"
    cd "$SOURCE_DIR"
    find bin/targets/ -name "*.img.gz" -o -name "*.img" 2>/dev/null | head -10
    echo ""
    log_info "烧录到 SD 卡:"
    echo "  cd $SOURCE_DIR"
    echo "  gunzip bin/targets/rockchip/armv8/*NanoPC*.img.gz"
    echo "  sudo dd if=bin/targets/rockchip/armv8/*NanoPC*.img of=/dev/sdX bs=1M status=progress"
}

# 主函数
main() {
    echo "=========================================="
    echo "  iStoreOS NanoPC-T4 云编译脚本"
    echo "  仅编译 NanoPC-T4 固件"
    echo "=========================================="
    echo ""

    check_system

    case "${1:-all}" in
        deps)
            install_deps
            ;;
        clone)
            clone_source
            ;;
        feeds)
            update_feeds
            ;;
        config)
            apply_config
            ;;
        download)
            download_packages
            ;;
        build)
            build_firmware
            ;;
        result)
            show_result
            ;;
        all)
            install_deps
            clone_source
            update_feeds
            apply_config
            download_packages
            build_firmware
            show_result
            ;;
        *)
            echo "用法: $0 {deps|clone|feeds|config|download|build|result|all}"
            echo ""
            echo "命令:"
            echo "  deps     - 安装编译依赖"
            echo "  clone    - 克隆 iStoreOS 源码"
            echo "  feeds    - 更新 feeds"
            echo "  config   - 应用 NanoPC-T4 配置"
            echo "  download - 下载软件包"
            echo "  build    - 编译固件"
            echo "  result   - 显示编译结果"
            echo "  all      - 执行所有步骤"
            exit 1
            ;;
    esac
}

main "$@"
