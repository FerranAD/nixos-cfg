{
  lib,
  ...
}:
{
  programs.kitty = lib.mkForce {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
      enable_audio_bell = false;
      mouse_hide_wait = "-1.0";
      window_padding_width = 5;
      background_opacity = "0.8";
      background_blur = 5;
      font_size = 11;
    };
  };
}
