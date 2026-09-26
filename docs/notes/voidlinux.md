# Void Linux

## `xbps-install`で`Service Unavailable`

日本のミラーを選択したら、インストール後に以下のエラーが出た。

```sh
$ sudo xbps-install -Su ncurses-term
[*] Updating repository `https://repo.jing.rocks/voidlinux/current/x86_64-repodata' ...
ERROR: [reposync] failed to fetch file `https://repo.jing.rocks/voidlinux/current/x86_64-repodata': Service Unavailable
```

別のミラーに置き換えることで修正した。

```sh
$ echo "repository=https://repo-fastly.voidlinux.org/current" > /etc/xbps.d/00-repository-main.conf
```

## `unknown terminal type.`

メインPCの`alacritty`からSSH接続したら、このエラーが出て`clear`や`ctrl+l`が使えない。
`ncurses-term`を入れても変わらない。

```sh
$ clear
'alacritty': unknown terminal type.
$ sudo xbps-install ncurses-term
$ clear
'alacritty': unknown terminal type.
```

`alacritty-terminfo`パッケージがあるので、それをインストールしたら解決した。

```sh
$ sudo xbps-install alacritty-terminfo
```

## Fishシェル

パッケージ名が`fish`ではなく、`fish-shell`。

```sh
$ sudo xbps-install fish-shell
```

## `XDG_RUNTIME_DIR`が未設定

```sh
$ sway
XDG_RUNTIME_DIR is not set in the environment. Aborting.
```

`elogind`をインストールして、`dbus`と一緒に起動したら解決した。

```sh
$ sudo xbps-install -S elogind
$ sudo ln -s /etc/sv/dbus /var/service/
$ sudo ln -s /etc/sv/elogind /var/service/ # dbusも実行
```

## GPUの取得に失敗

```log
00:00:00.006 [ERROR] [wlr] [libseat] [libseat/backend/logind.c:121] Could not take device: No such device
00:00:00.006 [ERROR] [wlr] [backend/session/session.c:340] Failed to open device: '/dev/dri/card0': No such device
00:00:00.006 [ERROR] [wlr] [backend/backend.c:245] Found 0 GPUs, cannot create backend
00:00:00.006 [ERROR] [wlr] [backend/backend.c:420] Failed to open any DRM device
00:00:00.058 [ERROR] [sway/server.c:270] Unable to create backend
```

このコマンドを実行して、`udev rules`を再適応したら解決した。

```sh
$ sudo udevadm control --reload
$ sudo udevadm trigger --subsystem-match=drm
$ sudo udevadm settle
```

## Mesa/EGLの初期化失敗

```log
00:00:00.008 [ERROR] [wlr] [render/egl.c:208] EGL_EXT_platform_base not supported
00:00:00.008 [ERROR] [wlr] [render/egl.c:563] Failed to create EGL context
00:00:00.008 [ERROR] [wlr] [render/gles2/renderer.c:499] Could not initialize EGL
00:00:00.009 [ERROR] [wlr] [render/vulkan/vulkan.c:182] Could not create instance: ERROR_INCOMPATIBLE_DRIVER (-9)
00:00:00.009 [ERROR] [wlr] [render/vulkan/renderer.c:2601] creating vulkan instance for renderer failed
00:00:00.009 [ERROR] [wlr] [render/wlr_renderer.c:279] Could not initialize renderer
00:00:00.009 [ERROR] [sway/server.c:278] Failed to create renderer
```

`mesa-dri`をインストールしたら解決した。

```sh
$ sudo xbps-install -S mesa-dri
```

## 入力デバイスの取得に失敗

GPUの時と同じように`udev rules`の再適応で解決した。

```sh
$ sudo udevadm control --reload
$ sudo udevadm trigger
$ sudo udevadm settle
```
