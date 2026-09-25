# シャットダウン

## BSD

FreeBSD、NetBSDなどのBSD系OSで、シャットダウンするには`-p`オプションが必要。`-p`オプションなしで実行した場合、電源が勝手に落ちない。

```sh
shutdown -p now
```
