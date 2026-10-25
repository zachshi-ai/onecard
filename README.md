# 一日一笺

每天只留一句话的手机小应用。打开是今天的笺，翻过去是卡池，往后是回响。

- 包名 `com.stepx.onecard`，版本 1.1，minSdk 21 / targetSdk 34
- 安装包：`dist/onecard.apk`（约 33 KB）

## 三个页面

- **今日**：当天的那一笺，连续记录会显示天数
- **卡池**：往池子里丢一句话，一句话就够，越短越容易回看
- **回响**：从池子里被再次抽到的旧句

## 设计取舍

- **本地优先**：卡池只存在这台手机上，不联网、不注册、不上传
- **一屏一句**：主界面不放列表，避免变成又一个笔记应用
- **输入即存**：没有保存按钮，写完退出就是存了
- **视觉克制**：白底、一种主色（#3370FF）、无阴影堆叠

## 工程

```
app/
  AndroidManifest.xml
  java/com/stepx/onecard/OneCardActivity.java   全屏 WebView + 软键盘自适应
  assets/index.html                            全部界面与逻辑（无外部依赖）
build.sh
dist/onecard.apk
```

```bash
bash build.sh   # SDK 路径在脚本顶部改
```

签名用 `app/debug.keystore`（口令 `android`），仓内不含密钥，自行生成：

```bash
keytool -genkeypair -keystore app/debug.keystore -alias androiddebugkey \
  -storepass android -keypass android -keyalg RSA -keysize 2048 -validity 10000 \
  -dname "CN=Android Debug,O=Android,C=US"
```

MIT License。
