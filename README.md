# intersection
> CSC258 Final Project

A simulation of a traffic control system. We will simulate the intersection of a major road and a small side road. The intersection will have pedestrian crossings, a left turn signal and a ‘red light camera’ (a sensor on the floor actually). The lights will be green for the main road most of the time to allow for flow of traffic. We will use a sensor to detect when a toy car pulls up at the intersection from the smaller road, and a switch to detect when a pedestrian walks up the intersection and presses the cross button. These will trigger the main road to turn red to allow the toy car  or the pedestrian through. After some amount of time, the small road will turn red. This will trigger the larger roads light cycle. This consists of a pedestrian crossing period (i.e. pedestrians are allowed to cross anyway they want for a certain amount of time), then a left turn period (the left turn signals go green), then a general green light period. This cycle will then repeat when the sensor on the smaller road is triggered again.

This whole cycle is essentially a finite state machine. The intersection can have several different states, such as red, green, yellow, left turn, and pedestrian crossing. The movement between these states will be governed by the input from the sensor and counters.

The red light camera is a feature separate from this FSM. It uses the existing sensors and the current state of the light FSM to determine if a car is running a red light. If it detects a car moving off a sensor while the light is in the red state, it triggers an LED (this simulates taking a picture of the license plate)

## Table of Contents

- [Modules](#modules)
- [Milestones](#milestones)
- [Motivations](#motivations)
- [License](#license)

## Modules:

- FSM to govern the state of the intersection
- Connection to LED’s (FSM states to the traffic lights)
- Counters to determine when to change light
- Connection to sensors to detect when a toy car rolls over or stops at a light
- Red light camera

### FSM:

![fsm](./img/fsm.png)

## Milestones

### First Milestone:
In this milestone we will set up the top level modules of the intersection. We will create a module which controls different LEDs (i.e. lights denoting the current state the intersection is in) based on input. These inputs will eventually come from the FSM in milestone 3.
We will also create the counter modules that will be used as one of the factors which will change states in the FSM in milestone 3.

### Second Milestone:
In this milestone, we will add modules to handle input from the sensor to detect when a toy car rolls over a sensor and stops at the intersection, and when a car moves through the intersection. We will use this input to determine when to change the light using the finite state machines that we will work on in milestone 3, and to determine if a car is running a red light. We will also add an ‘emergency’ feature. This features simulates a situation where an emergency vehicle is coming towards an intersection and sends a signal to turn the light green in it’s direction of travel. We will use switches to simulate a signal from an emergency vehicle being sent, and to indicate the direction the vehicle is coming from. This signal will trigger the FSM to go into a state where the emergency vehicle has a clear path.

### Third Milestone:
In this milestone we will create a module for the finite state machine that governs the different states of the intersection. Transitions between the states will occur based upon counters and the input detected by the sensors. We will also implement a module for the red light camera feature, which uses the current state of the FSM and the sensors to determine if a car is running a red light, and triggers an LED if so. Also has the ability to store the time (relative to the start of the simulation) which a driver runs a red light. We will do this using a timer (implemented via a counter) and RAM on the board. Successive runnings of red lights will be stored on different addresses of RAM.


## Motivations

### How does this project relate to material covered in CSC258?
Our project will utilize various concepts from the course, such as counters and flip flops as well as finite state machines. The project will directly utilize the DE1 board to run our verilog code.

### What's cool about this project (to CSC258 students and non-CSC258 students)?
I think that traffic lights are one of the most visible examples of 258 concepts in the real world. While most people don’t realize that their computer also runs on this stuff, a traffic light is pretty easy to figure out that it runs on counters and sensors. I think this project is cool because it’s a very real world application just shrunk down for toy cars.

### Why does the idea of working on this appeal to you personally?
I’ve always been enthused about how traffic lights and traffic control systems work, and I have a lot of toy cars that I need to justify having in my room. This kind of system would have been the ultimate toy for me when I was a kid, it would have made my imaginary cities so much cooler.

## License

MIT © Patrick Harris and Anmar Akhtar
