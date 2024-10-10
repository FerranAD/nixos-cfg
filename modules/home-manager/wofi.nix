{ ... }:
let
  # wofiStyle = ''
# /*
# * wofi style. Colors are from authors below.
# * Base16 Gruvbox dark, medium
# * Author: Dawid Kurek (dawikur@gmail.com), morhetz (https://github.com/morhetz/gruvbox)
# *
# */
# @define-color base00 #303446;  /* base */
# @define-color base01 #292c3c;  /* mantle */
# @define-color base02 #414559;  /* surface0 */
# @define-color base03 #51576d;  /* surface1 */
# @define-color base04 #626880;  /* surface2 */
# @define-color base05 #c6d0f5;  /* text */
# @define-color base06 #f2d5cf;  /* rosewater */
# @define-color base07 #babbf1;  /* lavender */
# @define-color base08 #e78284;  /* red */
# @define-color base09 #ef9f76;  /* peach */
# @define-color base0A #e5c890;  /* yellow */
# @define-color base0B #a6d189;  /* green */
# @define-color base0C #81c8be;  /* teal */
# @define-color base0D #8caaee;  /* blue */
# @define-color base0E #ca9ee6;  /* mauve */
# @define-color base0F #eebebe;  /* flamingo */


# window {
#     opacity: 0.9;
#     border:  0px;
#     border-radius: 10px;
#     font-family: monospace;
#     font-size: 18px;
# }

# #input {
# 	border-radius: 10px 10px 0px 0px;
#     border:  0px;
#     padding: 10px;
#     margin: 0px;
#     font-size: 28px;
# 	color: #8EC07C;
# 	background-color: #554444;
# }

# #inner-box {
# 	margin: 0px;
# 	color: @base06;
# 	background-color: @base00;
# }

# #outer-box {
# 	margin: 0px;
# 	background-color: @base00;
#     border-radius: 10px;
# }

# #selected {
# 	background-color: #608787;
# }

# #entry {
# 	padding: 0px;
#     margin: 0px;
# 	background-color: @base00;
# }

# #scroll {
# 	margin: 5px;
# 	background-color: @base00;
# }

# #text {
# 	margin: 0px;
# 	padding: 2px 2px 2px 10px;
# } 
#   '';

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