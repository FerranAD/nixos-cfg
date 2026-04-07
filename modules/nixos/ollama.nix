{pkgs, ...}:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan;
    loadModels = [
      "qwen3:4b-instruct-2507-q8_0"
    ];
  };
}