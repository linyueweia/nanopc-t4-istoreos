# iStoreOS for NanoPC-T4

自动编译 [iStoreOS](https://github.com/istoreos/istoreos) 固件，**仅支持 NanoPC-T4 (RK3399)**。

## 🎯 支持设备

| 设备 | SoC | 状态 |
|------|-----|------|
| **FriendlyARM NanoPC-T4** | RK3399 | ✅ 仅此设备 |

> ⚠️ 本仓库 **仅编译 NanoPC-T4 固件**，不支持其他设备。

## 🚀 云编译 (GitHub Actions)

### 自动编译
- 每天自动检查 iStoreOS 官方源码是否有更新
- 有更新时自动编译并发布到 Release

### 手动触发
1. 打开 [Actions](../../actions) 页面
2. 选择 "Build iStoreOS NanoPC-T4"
3. 点击 "Run workflow"（强制编译，不检查更新）

### 下载固件
1. 打开 [Releases](../../releases) 页面
2. 下载最新版本的 `*.img.gz` 文件

## 🔧 烧录固件（USB 线刷）

### 方法1: USB 线刷到 eMMC（推荐）

NanoPC-T4 支持通过 Type-C USB 线刷入系统，**无需先安装其他系统**。

**准备工作：**
1. 下载固件 `*.img.gz` 并解压得到 `*.img` 文件
2. 下载 [RKDevTool](https://dl.friendlyelec.com/rkdevtool)（Windows 工具）
3. 安装 USB 驱动

**刷机步骤：**
1. NanoPC-T4 按住 **Recovery 按钮** 不放，用 Type-C USB 线连接电脑
2. 打开 RKDevTool，设备会显示 "Found One LOADER Device"
3. 在 RKDevTool 中选择 "Upgrade Firmware" 标签页
4. 选择解压后的 `*.img` 文件
5. 点击 "Upgrade" 开始刷入
6. 等待刷入完成，设备自动重启

### 方法2: SD 卡启动
```bash
# 解压固件
gunzip *.img.gz

# 写入 SD 卡 (替换 /dev/sdX 为你的 SD 卡设备)
sudo dd if=*.img of=/dev/sdX bs=1M status=progress
sync
```

### 方法3: 在线升级
如果系统已经可以运行 iStoreOS：
1. 登录 iStoreOS 后台
2. 进入 系统 → 升级
3. 上传 `sysupgrade.img.gz` 文件即可升级

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

# 一键编译
chmod +x build.sh
./build.sh all
```

## 📁 仓库结构

```
nanopc-t4-istoreos/
├── .github/workflows/
│   └── build-nanopc-t4.yml  # GitHub Actions 编译工作流
├── .config                   # NanoPC-T4 编译配置
├── last_commit.txt           # 记录上次编译的官方 commit
├── build.sh                  # 本地编译脚本
└── README.md
```

## 🔗 相关链接

- [iStoreOS 官方仓库](https://github.com/istoreos/istoreos)
- [NanoPC-T4 Wiki](https://wiki.friendlyelec.com/wiki/index.php/NanoPC-T4/zh)
- [RKDevTool 刷机工具](https://dl.friendlyelec.com/rkdevtool)

## ❓ 常见问题

### Q: 固件多大？解压后 138MB 正常吗？
A: 正常。sysupgrade.img.gz 压缩后约 12-13MB，解压后约 138MB，这是 iStoreOS 标准大小。

### Q: 编译失败怎么办？
A: 检查磁盘空间是否充足（需要 100GB+），内存是否足够（16GB+）。可以在 Actions 页面查看详细日志。

### Q: 有更新时会自动编译吗？
A: 是的。每天自动检查 iStoreOS 官方源码，有新 commit 就自动编译并发布到 Release。

---

**仅编译 NanoPC-T4，其他设备一律不编译**
