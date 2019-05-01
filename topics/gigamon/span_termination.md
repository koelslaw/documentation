# SPAN Port From Switch Tap Configuration

> WARNING: Using a span port will double the CPU on a switch. If a swtich is already @ 75% utilization and you decide to do a span port...your gonna have a bad day.

1. Right Click the Modules on the tap under the `Chassis` tab and select `Config`.

1. The ports you wish to be your tapping interface. for example 1/2/g1. Mouse over `Admin` and select `Enable`.

1. The ports you wish to be your sensor interface. for example 1/1/x11. Mouse over `Admin` and select `Enable`.
> NOTE: This is where the network traffic will pass through

1. Do the same for the interfaces that connect your gigamon to your sensor.

1. By default, everything should be network port. So right click on `1/2/g1` mouse over `Type` and select `Network`, do the same for 1/1/g2.

1. Setup the ports that are going to your server as tool ports in our case `1/2/g1`

1. On the left hand pane click `Maps` so we can start sending our traffic to the tool interface from the inline network interface, click `New`, give it the following parameters:
  - Map Alias: Span_to_Sensor
  - Type: Regular
  - Subtype: Pass All
  - Source : 1/2/g1
  - Destination: 1/1/x11
