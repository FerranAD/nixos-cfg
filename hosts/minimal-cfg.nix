{ hostname, ... }:
{
  networking.hostName = hostname;

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDhmrNzsfb3fmufOfByUNngG4CeeyrsYrGX3mfx4N1FGTUOO/x3+0TqnAgHlm1J8SdfYxC8uM38VQa8TcwsYPGkjvLUuv8vnnZQj6BScpOs7TesUtL9j6qUU++1y60tRkpBF9MeGPQ4ADQRZG6XCvMh3l5MvLNLWhPMWw3+PUMoA2ogXw4kj8TrkXHBoUdrkjb8AW6AG17SIOLhqmnHtrcymkHyC4PWG4zUYZgHGWYOIz5yKGB7jYnjw/UAxPlcbSWZJlvuIaII6aUNJeEI87K+7QfmQzMfIuBzmx1AFSwt3yV5TRoWDN4u3Ns+Cxb+uei9xxEzCqHITE+VTIIgOBf6HPB28HnYgE4wetaEmgg0gfl3tUwNOBIQEDJxsmfvLs7Ws3NAqOziESMlJfv38TClTc/6WYQ0sNJXr721nsRfjwTREbRYEYlrOK2CxoS0OokcRPKuaTVOqznbp8MvBEy38/jRA+9CpChZshkJ6vVWaxO2/EK+SkPCgddtva9u9EIih/mlSGXam2vTd/hSJpJ9W35VDZvp/labRPWTmYTICiKE1Ii9LLBiZJINHHipnlaFYuEioWR5mh+qP41UNCsvaCv/XQuhXhJvm93P3tWHi3A72cOeH5gKuMnC5oQVX4Fi7+qMusT29Z4lB2LmyXGsFrbfXt3NeyfbJer+PKSPvw== cardno:24_684_025"
    ];
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "yes";
  };

  system.stateVersion = "25.05";
}