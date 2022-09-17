<p align="center">
  <img src="your_relative_path_here" width="350">
</p>

# Advanced Computer Architecture (ECE 350) Project - Crane Game
## Project Description
This is a project a partner and I built for an advanced computer architecture course. We incorporated a custom processor into a physical system we built to create a crane game where the user picks up boxes and drops them into a container to gain points. Our processor keeps track of the score and game logic while the rest of the system handles motors and sensors.

<p align="center">
  <img src="https://github.com/tylerfeldman321/Crane-Game/blob/main/Figures/front-view.jpg" width="700">
</p>

## Game
The goal of the game is to pickup as many boxes from the playing field and drop them into a acrylic case before time runs out. Once the user presses the start button, time will start counting down from a amount configured in the code (1 minute as default). When the game is active, the user can use the controls to rotate a PVC crane left or right, and move an electromagnet up/down that is hanging off the boom of the crane. The user can click a button to toggle the electromagnet, allowing the crane to pick up the boxes in the playing field. They can then drop them into the acrylic case, gaining points. After the time runs out, the points are recorded and game stops.

Below is a birds-eye view of the game and playing area. The boxes are outlined with red tape, as is the acrylic case on the left, where the user is meant to drop the boxes.

<p align="center">
  <img src="https://github.com/tylerfeldman321/Crane-Game/blob/main/Figures/birds-eye-view.jpg" width="500">
</p>

## Design
### Mechanical Design
#### Crane
The crane was built out of PVC and built so that the boom of the crane (the horizontal section at the top) could rotate freely. By attaching fishing wire on either side of the end of the boom, we could rotate the crane's boom by pulling on one string and providing slack in the other. To pull / provide slack to the wire, we used a stepper motor on either side that each had wheels that could wind / unwind the wire on that side. When one motor winds the wire and the other unwinds the wire, the crane's boom will be rotated in one direction. Reversing this would cause the crane's boom to rotate in the other direction.

<p align="center">
  <img src="https://github.com/tylerfeldman321/Crane-Game/blob/main/Figures/crane-movement.png" width="350">
</p>

There is also a third stepper motor placed behind the crane, which winds / unwinds a piece of fishing that runs through the boom of the crane and connects to the hanging electromagnet. When the fishing wire is wound, the electromagnet moves upwards, and when the wire is unwound, the electromagnet moves downwards.

#### Winding Wheel
We designed custom wheels that were spun by our stepper motors so that the fishing wire attached to the end of the boom of the crane could be efficiently wound up. We designed wheels that could fit the shaft of the stepper motors and provide a rod where the fishing wire could be tied and hot glued to. The wheels were also designed with a large enough radius so that the fishing wire wound wind fast enough. They were also designed with a large lip to prevent the fishing wire from slipping out of the wheel when winding or unwinding.

<p align="center">
  <img src="https://github.com/tylerfeldman321/Crane-Game/blob/main/Figures/winding-wheel-design.png" width="700">
</p>

#### Control Panel
Our control panel was designed to be visually clean and appealing for the user. To do this, we wanted to use panel-mount buttons. We found some viable options for purchase but for full customizability, it made sense to 3D print the buttons. Each button had a outer casing and a inner piece that would fit inside. The outer casing would provide enough room for a common button to be placed at the bottom. When the inner piece is pressed by the user, it would click the button inside as well. The buttons were placed the casing before being hot glued and soldering the connections. Below you can see the design for the start button (left), the front of the control panel when the relay is turned on (middle), and the back of the control panel (right).

<p align="center">
  <img src="https://github.com/tylerfeldman321/Crane-Game/blob/main/Figures/button.png" width="185">
  <img src="https://github.com/tylerfeldman321/Crane-Game/blob/main/Figures/panel-mounted-buttons-front.jpg" width="400">
  <img src="https://github.com/tylerfeldman321/Crane-Game/blob/main/Figures/panel-mounted-buttons-back.jpg" width="400">
</p>

The control panel was laser cut using thin wood and then glued together after fitting the pieces together. Because our wires and electronics took a lot of space, we weren't able to close the control panel and fit everything in. The control panel and FPGA housing were designed with slots in the sides so that wires could escape out the back or through from the control panel electronics to the FPGA and vice-versa. 

#### Boxes
The boxes were laser cut from wood. To create enough sound so that the sound sensor could easily pick up when a box is dropped in the acrylic case, we put washers inside the boxes. We also hot glued varying-sized washers to the outside of each box so that the electromagnet could pick up each box.

#### Acrylic Case
The acrylic case was laser cut from acrylic. It was designed as a tall rectangular prism with no top or bottom so that boxes could be dropped into it. We also left a slot in the bottom on one of the sides so that the sound sensor or other electronics could make their way inside the case.

<p align="center">
  <img src="https://github.com/tylerfeldman321/Crane-Game/blob/main/Figures/sound-sensor-setup.jpg" width="200">
</p>

### Electrical Design
Our electrical system consisted of:
- An arduino to control the stepper motors
- Stepper motor arduino shield attached to the arduino to simplify the control and wiring of multiple stepper motors
- 12 V power suppy for the stepper motors
- Three stepper motors
- An arduino to handle toggling the electromagnet via the relay and handle input from the sound sensor. This arduino would tell the FPGA to increment the score when there were spikes in the sound sensor data.
- Sound sensor
- Relay to electronically control the electromagnet
- LED to signal to the user whether the electromagnet is turned on
- FPGA to handle game logic and send/recieve control signals
- 5V to 3.3V voltage divider to convert signals from the 5V arduino signals to 3.3V for the FPGA

Below are pictures of the electrical system in the control panel and the connections from these electronics to the FPGA.
<p align="center">
  <img src="https://github.com/tylerfeldman321/Crane-Game/blob/main/Figures/electronics.jpg" width="300">
  <img src="https://github.com/tylerfeldman321/Crane-Game/blob/main/Figures/FPGA-connections.jpg" width="300">
</p>

#### Electrical Diagram for Entire System
<p align="center">
  <img src="https://github.com/tylerfeldman321/Crane-Game/blob/main/Figures/electrical-diagram.png" width="1000">
</p>

#### Complication with Relay
After soldering all of our components together, we realized that our relay system was not electrically isolated from the rest of the system. Because of this, when we would activate the relay, a voltage spike would occur, causing other signals, like the one to increment the score, to fluctuate. Rather than rewiring / resoldering our connections to isolate the relay, we found a solution through our processor design. By debouncing the input signals to the FPGA, we were able to ignore sudden spikes in the input signals, such as when the relay is toggled.

### Software Design
Our main assembly script for the game logic worked as an event-based program. When particular input signals were recieved by the FPGA, the code would jump to a particular section to handle whatever event occured. It simply consisted of initializing our variables, and then incrementing the score and decrementing the timer when necessary.

<p align="center">
  <img src="https://github.com/tylerfeldman321/Crane-Game/blob/main/Figures/assembly-file.png" width="400">
</p>

To accomodate this event-based system, we had to add in interrupt signals into our processor design. When one of these signals was high, then the assembly program would jump directly to the assembly code section to handle the corresponding event, such as when the score needs to be incremented.

We also had arduino code to control the motors, receive and filter input from the sound sensor, and to control the relay. Most of this code was making decisions based on the inputs from the buttons on the control panel. The stepper motor controller code was quite simple since we used the AccelStepper library.

## Design Journey
We had initially decided on the idea of creating a game built like a claw machine (but with an electromagnet instead of a claw), where there is a claw able to be translated in all three directions. This mechanical system is fairly similar to a 3D printer. We also looked into alterante motor / belt configurations like CoreXY as we designed the system. When we finally began prototyping after our parts arrived, we found out that this system is much more difficult to construct that we believed. The precision in our measurements and the calibration of the belts and entire system would have to be perfect or else the system could fail or break. We also realized that the precision movement that this system offered isn't necessary for a game - as long as the user can control generally where the claw goes, they'll have a fun or at least a not-frustrating time playing the game.

That led us to start prototyping and brainstorming new solutions. We landed on two potential solutions: 1) creating a 2D system where a gantry would move along a linear V-slot rail and the electromagnet could be moved up and down, and 2) a crane system where the crane could be rotated left or right. We settled on the crane system as our primary option, and built a very rudamentary initial prototype seen below. The strings could be wound to pull the end of the crane's boom in either direction to rotate it.

<p align="center">
  <img src="https://github.com/tylerfeldman321/Crane-Game/blob/main/Figures/early-prototype.png" width="350">
</p>

Our next prototype involved taping some stepper motors down, using winding wheels to wind up fishing wire connected to the boom of the crane, and using a breadboard for our electrical system to control the stepper motors.

<p align="center">
  <img src="https://github.com/tylerfeldman321/Crane-Game/blob/main/Figures/middle-stage-prototype.png" width="350">
</p>

We then moved onto more advanced prototypes and continued fabricating the different parts of the game. For score keeping, we had initially planned to use force sensors glued to the bottom of a plate. When the boxes would land on the plate, the force sensors would pick this up and the score would be increased. However, these force sensors kept breaking and were often inconsistent with their measurements. We found a spare sound sensor lying around and decided to use this instead. By filling the boxes with washers, they would make a loud clattering noise when dropped, which could be easily picked up by the sound sensor while filtering out any normal-volume noises.

We learned that, especially for mechanical systems like this, prototyping is extremely important. It should be done alongside brainstorming and designing, rather than spending time designing a system only to find out that it doesn't actually work.

# Processor Design
## Description of Design
The processor I built is a 5-stage pipelined processor. The processor is based on five stages: fetch, decode, execute, memory, and writeback. Between each stage is a latch that remembers the important information for the instruction. This information is passed from latch to latch at each clock cycle, so each stage is finished in one clock cycle. This means that once we have run enough instructions, there will be an instruction completed each clock cycle (assuming they don't involve multi-cycle operations like multiplication and division). 

In fetch, the instruction is read from RAM and the next PC is set. The decode stage is where the instruction reads the registers from the regfile. In execute, the alu is used to compute a result. This result could be a subtraction to determine if a branch should be taken or might be a simple add instruction. In the memory stage, for load word and store word instructions, they either read or write to memory. In writeback, the instructions that write to a register will do so.

## Bypassing
There are various levels of bypassing, including jump register, bypassing to the memory stage, and bypassing to the A and B operands in the execute stage. The bypassing is done from stages ahead of each particular stage. There is also priority involved with all of the bypassing in my processor,, which favors the closest instruction. For example, if an instruction in execute is reading from register 1 but there instructions in both memory and writeback that are writing to register 1, the result from the instruction in memory should be bypassed. It was also important to check that both the write enable of the instruction to bypass from is on, and also that the instruction to bypass from is not writing to register 0, since that will always stay 0.

The first level of bypassing is for the jump register instruction. This instruction is able to be executed during the decode stage, and reads from a particular register. This means that if an instruction in the execute, memory, or writeback stage is writing to the register that the JR is going to read from, bypassing is necessary.

There is bypassing from memory and writeback to the A and B register values in the execute stage. This was done by checking if the instructions in memory or writeback were going to write to a register that the instruction in execute has ready already. 

There is also bypassing to memory from writeback for the data that will be written into memory.

## Stalling
In the case that bypassing cannot handle a data hazard, stalling is used. Stalling consists of writing nops into the DX register, clearing all the datapath control signals, and disabling the FD latch and PC register. This allows the problematic instruction to run and move to the next cycle, while keeping the dependent instructions in the same location. Once the instructions are separated enough, then the pipeline can resume fetching instructions. The stalling is done only for the case of a lw instruction in execute and an instruction that will read it's result in the decode stage.

I also used stalling to complete the multiplication and division operations. Because of complexities with writing the registers and stalling on any instruction that reads or writes to the result register for multiplication or division, I decided to stall the processor while multiplication or division was running.
