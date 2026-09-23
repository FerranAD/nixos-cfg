{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    host = "0.0.0.0";
    package = pkgs.ollama-vulkan;
    loadModels = [
      "qwen3:8b"
      "qwen3:4b-instruct-2507-q8_0"
      "benhaotang/Nanonets-OCR-s:latest"
    ];
    syncModels = true;
  };
}
