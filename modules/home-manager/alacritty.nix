{ ... }:
{
  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    window.opacity = 0.75;

    bell = {
      animation = "EaseOutExpo";
      duration = 0;
    };

    cursor = {
      style = "Underline";
    };

    env = {
      TERM = "alacritty";
    };

    font = {
      size = 15;

      offset = {
        x = 0;
        y = 0;
      };
    };

    keyboard = {
      bindings = [
        {
          action = "Paste";
          key = "P";
          mods = "Control|Shift";
        }
        {
          action = "Copy";
          key = "Y";
          mods = "Control";
        }
        {
          action = "IncreaseFontSize";
          key = "Equals";
          mods = "Control";
        }
        {
          action = "DecreaseFontSize";
          key = "Minus";
          mods = "Control";
        }
        {
          action = "ToggleViMode";
          key = "Space";
          mods = "Shift|Control";
        }
        {
          action = "SemanticLeft";
          key = "B";
          mode = "Vi";
        }
        {
          action = "SemanticRight";
          key = "W";
          mode = "Vi";
        }
        {
          action = "SemanticRightEnd";
          key = "E";
          mode = "Vi";
        }
        {
          action = "WordLeft";
          key = "B";
          mode = "Vi";
          mods = "Shift";
        }
        {
          action = "WordRight";
          key = "W";
          mode = "Vi";
          mods = "Shift";
        }
        {
          action = "WordRightEnd";
          key = "E";
          mode = "Vi";
          mods = "Shift";
        }
        {
          action = "SearchForward";
          key = "Slash";
          mode = "Vi";
        }
        {
          action = "SearchBackward";
          key = "Slash";
          mode = "Vi";
          mods = "Shift";
        }
        {
          action = "SearchNext";
          key = "N";
          mode = "Vi";
        }
        {
          action = "SearchPrevious";
          key = "N";
          mode = "Vi";
          mods = "Shift";
        }
      ];
    };

    mouse = {
      bindings = [
        {
          action = "Copy";
          mouse = "Right";
        }
      ];
    };

    scrolling = {
      history = 10000;
      multiplier = 1;
    };

    window = {
      title = "Alacritty";

      class = {
        general = "Alacritty";
        instance = "Alacritty";
      };

      padding = {
        x = 10;
        y = 10;
      };
    };
  };
}
