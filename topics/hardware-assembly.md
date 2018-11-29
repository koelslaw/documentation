# CMAT Hardware Assembly
The CMAT kit contains [several hardware assets](topics/hardware-components.md).

Here we will begin the deployment of that hardware into the stack.

## Hardware Kit Layout

```
┌────────────────────────────────────┐
│               KIT 1                │
│ ┌────────────────────────────────┐ │
│ │       CISCO ROUTER 4321        │ │
│ ├────────────────────────────────┤ │
│ │       CISCO SWITCH C3850       │ │
│ ├────────────────────────────────┤ │
│ │        DELL R840 SERVER        │ │
│ └────────────────────────────────┘ │
└────────────────────────────────────┘
```
```
┌────────────────────────────────────┐
│               KIT 2                │
│ ┌────────────────────────────────┐ │
│ │     MIDDLE ATLANTIC POWER      │ │
│ ├────────────────────────────────┤ │
│ │      GIGAMON GIGAVUE HC1       │ │
│ ├────────────────────────────────┤ │
│ │        DELL R840 SERVER        │ │
│ └────────────────────────────────┘ │
└────────────────────────────────────┘
```
```
┌───────────────────────────────┐
│       CISCO ROUTER 4321       │
├───────────────────────────────┤
│                               │
│  ┌───┐   ┌───┐  ┌───┐         │
│  │MGT│   │AUX│  │1GB│         │
│  ├───┼───┼───┤  ├───┤  ┌───┐  │
│  │USB│CON│AUX│  │1GB│  │SFP│  │
│  └───┴───┴───┘  └───┘  └───┘  │
│                               │
└───────────────────────────────┘
```
```
┌───────────────────────────────────────────────────────────────────────┐
│                          CISCO SWITCH C3850                           │
├───────────────────────────────────────────────────────────────────────┤
│                                                                       │
│  ┌───┬───┬───┬───┬───┬───┐┌───┬───┬───┬───┬───┬───┐┌───┬───┬───┬───┐  │
│  │ 1 │ - │ - │ - │ - │30 ││37 │38 │39 │40 │41 │42 ││SFP│SFP│SFP│SFP│  │
│  ├───┼───┼───┼───┼───┼───┤├───┼───┼───┼───┼───┼───┤└───┴───┴───┴───┘  │
│  │ 7 │ - │ - │ - │ - │36 ││43 │44 │45 │46 │47 │48 │                   │
│  └───┴───┴───┴───┴───┴───┘└───┴───┴───┴───┴───┴───┘                   │
│                                                                       │
└───────────────────────────────────────────────────────────────────────┘
```
```
┌─────────────────────────────────────────────────────────────────────┐
│                         GIGAMON GIGAVUE HC1                         │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌───┬───┬───┬───┐     ┌───┬───┐┌───┬───┐┌───┬───┬───┬───┬───┬───┐  │
│  │ 1 │ 2 │ 3 │ 4 │     │FAN│STK││ 1 │ 2 ││ 1 │ 2 │ 3 │ 4 │ 5 │ 6 │  │
│  ├───┼───┼───┼───┤┌───┐├───┼───┤├───┼───┤├───┼───┼───┼───┼───┼───┤  │
│  │ 5 │ 6 │ 7 │ 8 ││USB││MGT│STK││ 3 │ 4 ││ 7 │ 8 │ 9 │10 │11 │12 │  │
│  └───┴───┴───┴───┘└───┘└───┴───┘└───┴───┘└───┴───┴───┴───┴───┴───┘  │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```
```
┌───────────────────────────────┐
│          DELL R840            │
├───────────────────────────────┤
│                               │
│  ┌───┐┌───┐┌───┐┌───┐         │
│  │1GB││1GB││10F││SFP│         │
│  └───┘└───┘└───┘└───┘         │
│  ┌─────┐                      │
│  │iDRAC│                      │
│  └─────┘                      │
└───────────────────────────────┘
```
```
┌──────────────────────────────┐
│          INTEL NUC           │
├──────────────────────────────┤
│       ┌───┐                  │
│  ┌───┐│USB│┌───┐┌───┐┌────┐  │
│  │1GB│├───┤│DSP││PWR││HDMI│  │
│  └───┘│USB│└───┘└───┘└────┘  │
│       └───┘                  │
└──────────────────────────────┘
```
```
┌────────────────────────┐
│      ACCESS POINT      │
├────────────────────────┤
│                        │
│  ┌───┐┌───┐┌───┐┌───┐  │
│  │POE││AUX││USB││CON│  │
│  └───┘└───┘└───┘└───┘  │
│                        │
└────────────────────────┘
```

## Hardware Wiring
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
│  ┌───┐┌───┐┌───┐┌───┐  │          ┃             ┃                          │  └─────┘┃                     │
│  │POE││AUX││USB││CON│  │          ┃             ┃                          └─────────╋─────────────────────┘
│  └───┘└───┘└───┘└───┘  │          ┃             ┃                                    ┃
│                        │          ┃   ┏━━━━━━━━━╋━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
└────────────────────────┘          ┃   ┃         ┃
┌───────────────────────────────────┻───┻─────────┻───────────────────┐
│                         GIGAMON GIGAVUE HC1                         │
├───────────────────────────────────┳───┳─────────┳───────────────────┤
│                                   ┃   ┃         ┃                   │
│  ┌───┬───┬───┬───┐     ┌───┬───┐┌───┬───┐┌───┬──┻┬───┬───┬───┬───┐  │
│  │ 1 │ 2 │ 3 │ 4 │     │FAN│STK││ 1 │ 2 ││ 1 │ 2 │ 3 │ 4 │ 5 │ 6 │  │
│  ├───┼───┼───┼───┤┌───┐├───┼───┤├───┼───┤├───┼───┼───┼───┼───┼───┤  │
│  │ 5 │ 6 │ 7 │ 8 ││USB││MGT│STK││ 3 │ 4 ││ 7 │ 8 │ 9 │10 │11 │12 │  │
│  └───┴───┴───┴───┘└───┘└───┴───┘└───┴───┘└───┴──┳┴───┴───┴───┴───┘  │
│                          ┃                      ┃                   │
└──────────────────────────╋──────────────────────╋───────────────────┘
                           ┗━━━━━━━━━━━━━━━━━━━━━━┛
```
 # U1 is nearest bottom working their way up from bottom to top
 # Use supplied square nuts and bolts for installations
 Step 1 - Remove doors from case - front and back
   - Turn knobs until unlatched
   - Open doors
   - unhinge doors
 Step 2 - Install server
   - Server goes in U1 and U2
   - mention brackets
   - mention power cables
 Step 3 - Installation of Gigamon - U3
   - Attach front brackets (included) to both sides using 4 lower mounting holes and 4 short-set screws per side
   - Attach rear hanging brackets from rear of case in U3
     - Gigamon has 3 silver slide mounts on each side towards the rear of device
       - From front to back of case, insert slide mounts into rear mounts in U3
         - Above step may take some wiggling, side-to-side, of Gigamon
       - From front, insert 2 screws per side to attach device to case
 Step 3.A - Installation of the Tap
   - Release thumb screw on far left expansion port to remove cover
   - Release thumb screw on tap prior to installation
   - Insert tap into expansion slot (should not require much force)
   - After inserting tap, close lever and tighten thumb screws
 Step 3.B - Installation of 5 SFPs
   - Insert SFP 503 - 1G single mode - into slot x12
   - Insert SFP 502 - 1G multi mode - into slot x10
   - Insert SFP 501 - 1G copper - into slot X8
   - Insert SFP 533 - 10G single mode - into slot X11
   - Insert SFP 532 - 10G multi mode - into slot X9
 Step 3.C - Installation of power cords
   - Gigamon has redundant power on right and left
   - Insert 2 power cords into rear right and left of Gigamon
 Step 4 - Installation of Power Supply (Middle Atlantic Products PD-920RC-20)
   - Power supply goes in U4
   - Comes with mounting brackets attached
   - Insert 4 screws to secure power supply to case
 Step 5 - Installation of server
   - See Step 2
 #Case 1
 Step 1 - Remove doors from case - front and back
   - Turn knobs until unlatched
   - Open doors
   - unhinge doors
 Step 2 - Install server
     - Server goes in U1 and U2
     - mention brackets
     - mention power cables
 Step 3 - Installation of Cisco Switch - U3 (Cisco Catalyst 3850 48 Core Switch with expansion)
     - Attach front brackets (included) to both sides using 4 mounting holes (front and rear) and 4 short-set screws per side
 Step 3.A - Installing power supply into switch
     -Remove blanking from back right of switch using squeeze handles
      -Insert power supply with letters facing up until latched into place
 Step 3.B - Inserting Cisco Networking module
     - Release two set screws from expansion plate right front and remove expansion plate
      -Insert network module and tighten captive bolts on front of network module (Do not over tighten)
 Step 3.C - Installation of 4 SFPs
     -Insert all SFP-10G-SR modules into available SFP slots on bottom right of switch
 Step 4.D - Mount switch to case
       -From front mount the switch into u3 and install 2 screws per side to attach switch to Case (use the assistance of two people)
 Step 5 - Installation of Edge Router - U4 (Cisco 4321 Edge Router)
     - Remove two set screws from each side on the back of router
      - Place bracket past extending of the rear of the router and attach with four screws into side of router.
       -Insert router with the rear facing the front of the case and mount to case with four
