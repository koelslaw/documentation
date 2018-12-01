# CMAT Hardware Assembly
The CMAT kit contains [several hardware assets](hardware-components.md).

Here we will begin the deployment of that hardware into the stack.

# A Note about Rack Units (U's)
A Rack Unit (abbreviated U or RU) is a unit of measure defined as 1.75 in. It is most frequently used as a measurement of the overall height of 19-inch and 23-inch rack frames, as well as the height of equipment that mounts in these frames, whereby the height of the frame or equipment is expressed as multiples of rack units. For example, a typical full-size rack cage is 42U high, while equipment is typically 1U, 2U, 3U, or 4U high.

**The counting of U's starts at the bottom of the rack.**

# Case 1

## Step 1 - Disassemble Case
1. Remove doors from case - front and back
1. Turn knobs until unlatched
 - Open doors
 - Unhinge doors

## Step 2 - Install Server - U1 & U2
1.

## Step 3 - Installation of Cisco Switch - U3
1. Attach front brackets (included) to both sides using 4 mounting holes (front and rear) and 4 short-set screws per side
 - Installing power supply into switch
 - Remove blanking from back right of switch using squeeze handles
 - Insert power supply with letters facing up until latched into place

1. Inserting Cisco Networking module
 - Release two set screws from expansion plate right front and remove expansion plate
 - Insert network module and tighten captive bolts on front of network module (Do not over tighten)

1. Installation of 4 SFPs
 - Insert all SFP-10G-SR modules into available SFP slots on bottom right of switch

1. Mount switch to case
 - From front mount the switch into u3 and install 2 screws per side to attach switch to Case (use the assistance of two people)

## Step 4 - Installation of Cisco Edge Router - U4
1. Remove two set screws from each side on the back of router
1. Place bracket past extending of the rear of the router and attach with four screws into side of router.
1. Insert router with the rear facing the front of the case and mount to case with four
```
┌────────────────────────────────────┐
│              CASE 1                │
│ ┌────────────────────────────────┐ │
│ │       CISCO ROUTER 4321        │ │
│ ├────────────────────────────────┤ │
│ │       CISCO SWITCH C3850       │ │
│ ├────────────────────────────────┤ │
│ │        DELL R840 SERVER        │ │
│ └────────────────────────────────┘ │
└────────────────────────────────────┘
```

# Case 2

## Step 1 - Disassemble Case
1. Remove doors from case - front and back
1. Turn knobs until unlatched
 - Open doors
 - Unhinge doors

## Step 2 - Install Server - U1 & U2
1.

## Step 3 - Installation of Gigamon - U3
1. Attach front brackets (included) to both sides using 4 lower mounting holes and 4 short-set screws per side
1. Attach rear hanging brackets from rear of case in U3
1. Gigamon has 3 silver slide mounts on each side towards the rear of device
 - From front to back of case, insert slide mounts into rear mounts in U3
  - Above step may take some wiggling, side-to-side, of Gigamon
 - From front, insert 2 screws per side to attach device to case
1. Installation of the Tap
 - Release thumb screw on far left expansion port to remove cover
 - Release thumb screw on tap prior to installation
 - Insert tap into expansion slot (should not require much force)
 - After inserting tap, close lever and tighten thumb screws
1. Installation of 5 SFPs
 - Insert SFP 503 - 1G single mode - into slot x12
 - Insert SFP 502 - 1G multi mode - into slot x10
 - Insert SFP 501 - 1G copper - into slot X8
 - Insert SFP 533 - 10G single mode - into slot X11
 - Insert SFP 532 - 10G multi mode - into slot X9
1. Installation of power cords
 - Gigamon has redundant power on right and left
 - Insert 2 power cords into rear right and left of Gigamon

## Step 4 - Installation of Middle Atlantic Power Supply - U4
1. Insert 4 screws to secure power supply to case
```
┌────────────────────────────────────┐
│              CASE 2                │
│ ┌────────────────────────────────┐ │
│ │     MIDDLE ATLANTIC POWER      │ │
│ ├────────────────────────────────┤ │
│ │      GIGAMON GIGAVUE HC1       │ │
│ ├────────────────────────────────┤ │
│ │        DELL R840 SERVER        │ │
│ └────────────────────────────────┘ │
└────────────────────────────────────┘
```

# Hardware Wiring

| Switch Port | Device            | Device Port |
|-------------|-------------------|-------------|
| 1 - 39      | Open Use          | NA          |
| 40          | Server (Case 1)   | iDRAC       |
| 41          | Router            | Management  |
| 42          | Nuc               | Management  |
| 46          | Server (Case 2)   | iDRAC       |
| 47          | WiFi Access Point | POE         |
| 48          | Gigamon           | Management  |

```
                                                    ┌──────────────────────────────┐  ┌───────────────────────────────┐
                                                    │          INTEL NUC           │  │      DELL R840 SERVER 1       │
                                                    ├──────────────────────────────┤  ├───────────────────────────────┤
┌───────────────────────────────┐                   │       ┌───┐                  │  │                               │
│       CISCO ROUTER 4321       │                   │  ┌───┐│USB│┌───┐┌───┐┌────┐  │  │  ┌───┐┌───┐┌───┐┌───┐         │
├───────────────────────────────┤                 ┏━╋━━│1GB│├───┤│DSP││PWR││HDMI│  │  │  │1GB││1GB││10F││SFP│         │
│    ━━━━━━━━━━━━━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━┓   ┃ │  └───┘│USB│└───┘└───┘└────┘  │  │  └───┘└───┘└───┘└───┘         │
│  ┌───┐   ┌───┐  ┌───┐         │             ┃   ┃ │       └───┘                  │  │  ┌─────┐     ┃                │
│  │MGT│   │AUX│  │1GB│         │             ┃   ┃ └──────────────────────────────┘  │  │iDRAC│     ┃                │
│  ├───┼───┼───┤  ├───┤  ┌───┐  │             ┃   ┃                                   │  └─────┘     ┃                │
│  │USB│CON│AUX│  │1GB│  │SFP│  │             ┃   ┃                                   └─────┳────────╋────────────────┘
│  └───┴───┴───┘  └───┘  └───┘  │             ┃   ┃                                         ┃        ┃
│                               │             ┃   ┃                                         ┃        ┃
└───────────────────────────────┘             ┃   ┃                                         ┃        ┃
                                          ┏━━━╋━━━╋━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛        ┃
┌─────────────────────────────────────────┻───┻───┻─────────────────────┐                            ┃
│                          CISCO SWITCH C3850                           │                            ┃
├─────────────────────────────────────────┳───┳───┳─────────────────────┤                            ┃
│                                         ┃   ┃   ┃                     │                            ┃
│  ┌───┬───┬───┬───┬───┬───┐┌───┬───┬───┬───┬───┬───┐┌───┬───┬───┬───┐  │                            ┃
│  │ 1 │ - │ - │ - │ - │30 ││37 │38 │39 │40 │41 │42 ││SFP│SFP│SFP│SFP│━━╋━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
│  ├───┼───┼───┼───┼───┼───┤├───┼───┼───┼───┼───┼───┤└───┴───┴───┴───┘  │
│  │ 7 │ - │ - │ - │ - │36 ││43 │44 │45 │46 │47 │48 │          ┃        │
│  └───┴───┴───┴───┴───┴───┘└───┴───┴───┴───┴───┴───┘          ┃        │    ┌───────────────────────────────┐
│                                         ┃   ┃   ┃            ┗━━━━━━━━╋━━━━┫      DELL R840 SERVER 2       │
└─────────────────────────────────────────╋───╋───╋─────────────────────┘    ├──────────────┳────────────────┤
                                          ┃   ┃   ┃                          │              ┃                │
     ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╋━━━┛   ┃                          │  ┌───┐┌───┐┌───┐┌───┐         │
┌────┻───────────────────┐          ┏━━━━━╋━━━━━━━╋━━━━━━━━━━━━━━━━━━━━━━━━━━╋━━│1GB││1GB││10F││SFP│         │
│      ACCESS POINT      │          ┃     ┃       ┃                          │  └───┘└───┘└───┘└───┘         │
├────┳───────────────────┤          ┃     ┃       ┃                          │  ┌─────┐┃                     │
│    ┃                   │          ┃     ┗━━━━━━━╋━━━━━━━━━━━━━━━━━━━━━━━━━━╋━━│iDRAC│┃                     │
│  ┌───┐┌───┐┌───┐┌───┐  │ ┏━━━━━━━━╋━━━━━━━━━━━━━┛                          │  └─────┘┃                     │
│  │POE││AUX││USB││CON│  │ ┃        ┃                                        └─────────╋─────────────────────┘
│  └───┘└───┘└───┘└───┘  │ ┃        ┃                                                  ┃
│                        │ ┃        ┃   ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
└────────────────────────┘ ┃        ┃   ┃
┌──────────────────────────┻────────┻───┻─────────────────────────────┐
│                         GIGAMON GIGAVUE HC1                         │
├──────────────────────────┳────────┳───┳─────────────────────────────┤
│                          ┃        ┃   ┃                             │
│  ┌───┬───┬───┬───┐     ┌───┬───┐┌───┬───┐┌───┬───┬───┬───┬───┬───┐  │
│  │ 1 │ 2 │ 3 │ 4 │     │MGT│STK││ 1 │ 2 ││ 1 │ 2 │ 3 │ 4 │ 5 │ 6 │  │
│  ├───┼───┼───┼───┤┌───┐├───┼───┤├───┼───┤├───┼───┼───┼───┼───┼───┤  │
│  │ 5 │ 6 │ 7 │ 8 ││USB││CON│STK││ 3 │ 4 ││ 7 │ 8 │ 9 │10 │11 │12 │  │
│  └───┴───┴───┴───┘└───┘└───┴───┘└───┴───┘└───┴───┴───┴───┴───┴───┘  │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

Move onto [Hardware Configuration](hardware-configuration.md)
