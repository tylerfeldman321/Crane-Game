# Advanced Computer Architecture (ECE 350) Project - Crane Game
## Project Description
This is a project a partner and I built for an advanced computer architecture course. We incorporated a custom processor into a physical system we built to create a crane game where the user picks up boxes and drops them into a container to gain points. Our processor keeps track of the score and game logic while the rest of the system handles motors and sensors.

## Game
The goal of the game is to pickup as many boxes from the playing field and drop them into a acrylic case before time runs out. Once the user presses the start button, time will start counting down from a amount configured in the code (1 minute as default). When the game is active, the user can use the controls to rotate a PVC crane left or right, and move an electromagnet up/down that is hanging off the boom of the crane. The user can click a button to toggle the electromagnet, allowing the crane to pick up the boxes in the playing field. They can then drop them into the acrylic case, gaining points. After the time runs out, the points are recorded and game stops.

### Design
### Mechanical Design

### Electrical Design

### Software Design

## Design Journey

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
