{ lib, pkgs, ... }:
let
  groups = [
    {
      name = "Japanese";
      layout = "jp";
      im = "mozc";
    }
    {
      name = "Korean";
      layout = "kr";
      im = "hangul";
    }
    {
      name = "Chinese";
      layout = "cn";
      im = "pinyin";
    }
  ];
in
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-hangul
      qt6Packages.fcitx5-chinese-addons
      fcitx5-gtk
      fcitx5-tokyonight
    ];
    fcitx5.settings = {
      globalOptions = {
        Hotkey = {
          "TriggerKeys/0" = "Zenkaku_Hankaku";
          "EnumerateGroupForwardKeys/0" = "Muhenkan";
          "EnumerateGroupBackwardKeys/0" = "Shift+Muhenkan";
        };
      };
      addons = {
        classicui.globalSection = {
          Theme = "Tokyonight-Storm";
        };
      };
      inputMethod = lib.mkMerge (
        lib.imap0 (
          i: group:
          let
            id = toString i;
          in
          {
            GroupOrder.${id} = group.name;

            "Groups/${id}" = {
              Name = group.name;
              "Default Layout" = group.layout;
            }
            // lib.optionalAttrs (group ? im) {
              DefaultIM = group.im;
            };

            "Groups/${id}/Items/0".Name = "keyboard-${group.layout}";
          }
          // lib.optionalAttrs (group ? im) {
            "Groups/${id}/Items/1".Name = group.im;
          }
        ) groups
      );
    };
  };
}
