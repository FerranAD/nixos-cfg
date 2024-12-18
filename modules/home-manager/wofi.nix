{ ... }:
let
  wofiStyle = ''
    window {
    	font-size: 13px;
      margin: 0px;
      border: 5px solid #94e2d5;
      background-color: #1e1e2e;
      border-radius: 16px;
    }

    #input {
      all: unset;
      min-height: 36px;
      padding: 4px 10px;
      margin: 4px;
      border: none;
      color: #cdd6f4;
      font-weight: bold;
      background-color: #1e1e2e;
      outline: none;
      border-radius: 16px;
      margin: 10px;
      margin-bottom: 2px;
    }

    #inner-box {
      margin: 4px;
      padding: 10px;
      font-weight: bold;
      border-radius: 16px;
    }

    #outer-box {
      margin: 0px;
      padding: 3px;
      border: none;
      border-radius: 12px;
      border: 2px solid #94e2d5;
    }

    #scroll {
      margin-top: 5px;
      border: none;
      border-radius: 16px;
      margin-bottom: 5px;
    }

    #text {
      color: #cdd6f4;
      border-radius: 16px;
    }

    #text:selected {
      color: #1e1e2e;
      margin: 0px 0px;
      border: none;
      border-radius: 16px;
    }

    #entry {
      margin: 0px 0px;
      border: none;
      border-radius: 16px;
      background-color: transparent;
    }

    #entry:selected {
      margin: 0px 0px;
      border: none;
      border-radius: 16px;
      background: #cba6f7;
    }
  '';

in
{
  programs.wofi = {
    enable = false;
    style = wofiStyle;
  };
}
