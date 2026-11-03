{ pkgs, ... }: {
  systemd.services.minecraft = {
    description = "Minecraft Server";

    after = [ "network.target" ];

    serviceConfig = {
      Type = "simple";

      User = "minecraft";
      Group = "minecraft";
      WorkingDirectory = "/srv/minecraft";

      ExecStart = "${pkgs.jdk25}/bin/java -Xms2G -Xmx4G -jar server.jar nogui";

      ExecStop = pkgs.writeShellScript "minecraft-stop" ''
        password="$(${pkgs.coreutils}/bin/cat /run/secrets/minecraft-rcon-password)"

        exec ${pkgs.mcrcon}/bin/mcrcon \
          -H 127.0.0.1 \
          -P 25575 \
          -p "$password" \
          stop
      '';

      Restart = "on-failure";
      RestartSec = 5;
      TimeoutStopSec = 60;
    };
  };

  users.users.minecraft = {
    isSystemUser = true;
    group = "minecraft";
  };

  users.groups.minecraft = { };
}
