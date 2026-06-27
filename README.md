# iStoreOS for NanoPC-T4

自动编译 [iStoreOS](https://github.com/istoreos/istoreos) 固件，**仅支持 NanoPC-T4 (RK3399)**。

## 🎯 支持设备

| 设备 | SoC | 状态 |
|------|-----|------|
| **FriendlyARM NanoPC-T4** | RK3399 | ✅ 仅此设备 |

> ⚠️ 本仓库 **仅编译 NanoPC-T4 固件**，不支持其他设备。

## 🚀 云编译 (GitHub Actions)

### 自动编译
- 每周一凌晨 2:00 自动检查更新并编译
- 推送到 main 分支时自动编译

### 手动触发
1. 打开 [Actions](../../actions) 页面
2. 选择 "Build iStoreOS for NanoPC-T4"
3. 点击 "Run workflow"

### 下载固件
1. 打开 [Actions](../../actions) 页面
2. 点击最近的编译任务
3. 在 "Artifacts" 部分下载 `iStoreOS-NanoPC-T4-firmware`

## 💻 本地编译

### 系统要求
- Ubuntu 20.04/22.04 (推荐)
- 16GB+ 内存
- 100GB+ 可用磁盘空间
- 稳定的网络连接

### 快速开始
```bash
# 克隆仓库
git clone https://github.com/linyueweia/nanopc-t4-istoreos.git
cd nanopc-t4-istoreos

# 一键编译 (安装依赖 + 克隆源码 + 编译)
chmod +x build.sh
./build.sh all
```

### 分步编译
```bash
# 1. 安装依赖
./build.sh deps

# 2. 克隆源码
./build.sh clone

# 3. 更新 feeds
./build.sh feeds

# 4. 应用配置
./build.sh config

# 5. 下载软件包
./build.sh download

# 6. 编译固件
./build.sh build

# 7. 查看结果
./build.sh result
```

### 使用 menuconfig 自定义
```bash
cd source
make menuconfig
# 选择 Target System → Rockchip ARMv8
# 选择 Target Profile → FriendlyARM NanoPC T4
# 保存退出
make -j$(nproc) V=s
```

## 🔧 烧录固件

### SD 卡启动
```bash
# 解压固件
gunzip bin/targets/rockchip/armv8/*NanoPC*.img.gz

# 写入 SD 卡 (替换 /dev/sdX 为你的 SD 卡设备)
sudo dd if=bin/targets/rockchip/armv8/*NanoPC*.img of=/dev/sdX bs=1M status=progress
sync
```

### eMMC 启动
1. 先从 SD 卡启动系统
2. 登录后执行:
```bash
cd /root
mkimage -T script -n boot.scr.uIMG -d boot.cmd boot.scr
# 或使用官方刷机工具
```

## 📁 仓库结构

```
nanopc-t4-istoreos/
├── .github/
│   └── workflows/
│       └── build-nanopc-t4.yml  # GitHub Actions 编译工作流
├── .config                       # NanoPC-T4 编译配置
├── build.sh                      # 本地编译脚本
└── README.md                     # 本文档
```

## 🔗 相关链接

- [iStoreOS 官方仓库](https://github.com/istoreos/istoreos)
- [NanoPC-T4 Wiki](https://wiki.friendlyelec.com/wiki/index.php/NanoPC-T4/zh)
- [OpenWrt 编译文档](https://openwrt.org/docs/guide-developer/build-system/start)

## ❓ 常见问题

### Q: 编译失败怎么办？
A: 检查磁盘空间是否充足（需要 100GB+），内存是否足够（16GB+）。可以在 Actions 页面查看详细日志。

### Q: 如何添加自定义软件包？
A: 编辑 `.config` 文件，添加对应的 `CONFIG_PACKAGE_xxx=y` 配置项。

### Q: 编译太慢怎么办？
A: OpenWrt 编译通常需要 2-6 小时，取决于机器性能。GitHub Actions 限制 6 小时，本地编译无此限制。

---

**仅编译 NanoPC-T4，其他设备一律不编译**
