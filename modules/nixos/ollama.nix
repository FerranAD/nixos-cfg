{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    host = "0.0.0.0";
    package = pkgs.ollama-vulkan;
    environmentVariables = {
      OLLAMA_IGPU_ENABLE = "1";
      OLLAMA_VULKAN = "1";
      OLLAMA_DEBUG = "1";
      GGML_VK_VISIBLE_DEVICES = "0";
    };
    loadModels = [
      "qwen3:8b"
      "qwen3:4b-instruct-2507-q8_0"
      "benhaotang/Nanonets-OCR-s:latest"
    ];
    syncModels = true;
  };
}
