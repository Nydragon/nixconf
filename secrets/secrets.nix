let
  user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMvPqWPXEUOSMGMIRmirQfbrzq//NkPlEI2TmFpIkSfw";
in
{
  "user-password.age".publicKeys = [ user ];
}
