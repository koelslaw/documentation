1. Login to the gigamon using at `10.[state].cmat.lan`

1. Navigate
1. Ensure the that port 2/2/g1 is active and configured as a network port

1. Ensure that your outbound interface is active and configured as a tool port.


port 2/2/g3 type network
port 2/2/g3 params admin enable taptx active
port 2/2/g3 comment "Tap2 Ports"
