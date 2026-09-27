# シャットダウン

## `poweroff`コマンド

BSD系OSやほとんどLinuxディストリビューションで、`poweroff`コマンドを使用すると、OSを正常にシャットダウンした上で、マシンの電源を切ることができる。

`shutdown`コマンドはOSによってオプションの扱いが異なるため、単に電源を切りたい場合は`poweroff`を使うと分かりやすい。

```sh
poweroff
```

## BSD

FreeBSDやNetBSDなどのBSD系OSでは、`shutdown now`だけで、シャットダウン後に電源が自動で切れない。

電源まで切るには`-p`オプションを指定する。

```sh
shutdown -p now
```

## Void Linux (runit)

Void Linuxでは、`shutdown now`を実行すると電源を切るのではなく、シングルユーザモードへ移行する。

シャットダウンするには`-h`オプションを指定する。

```sh
shutdown -h now
```
