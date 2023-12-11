# ECE585_Final_project_L1_split_cache

OBJECTIVE:
The aim of this project is to create a simulation of a split L1 Cache for a new 32-bit processor, which can be used concurrently with 3 other processors which share L2 Cache. The system will use MESI protocol.
![image](https://github.com/GayatriVemuri/ECE585_Final_project_L1_split_cache/assets/104589505/2237f146-72bd-4a4d-8774-90b0955f646a)
 
  Design block: Inputs we get and outputs we need to calculate.
DESIGN SPECIFICATION:
●	32-bit processor
○	32 address bits
■	16k sets
●	214 = 16k
●	∴ 14 bits required to for address select
■	64 byte lines
●	26 = 64 
●	∴ 6 bits required to for byte select
■	Tag bits are remaining
●	32-14-9=12 
●	∴ 12 bits for tag select
●	Cache coherence
○	MESI protocol
●	Simulate L1 Split Cache
○	L1 instruction Cache 
■	4-way associativity
■	16k sets
●	16k x 4
○	64k total cache lines
■	64k byte lines	
●	64K x 64 = 4096KB
○	4MB
■	4MB instruction cache
○	L1 data cache
■	8-way associativity
■	16k sets
●	16k x 8
○	128k total cache lines
■	64 byte line
●	128k x 64 = 8192K
○	8MB
■	8MB data cache
●	L2 cache shared by 4 processors

The simulator has two modes. In mode 0, it displays the usage statistics and responses to trace number 9; and in mode 1 it displays everything that is displayed in mode 0 along with the communication messages with L2 cache. According to the user input, the mode can be changed without recompilation. 

 ![image](https://github.com/GayatriVemuri/ECE585_Final_project_L1_split_cache/assets/104589505/64af2e3d-7ecf-4713-83c6-7b1b1cddefa4)

                                                 Fig 1: 32 bit address distribution 
BLOCK DIAGRAM:
 ![image](https://github.com/GayatriVemuri/ECE585_Final_project_L1_split_cache/assets/104589505/322f6b06-d550-42e0-a849-3573631df0c0)


STATE DIAGRAM/MESI PROTOCOL:
 ![image](https://github.com/GayatriVemuri/ECE585_Final_project_L1_split_cache/assets/104589505/423d3fb6-e1d6-4c96-8584-3cc238cb88d7)


ASSUMPTIONS GIVEN TO PERFORM MESI PROTOCOL :-

1.	Initially all the cache lines are initialized to invalid state. And since the first write is write through, it goes to the Exclusive state.
2.	Also during the first time a processor reads data, it goes to the exclusive state because no other processor is having any shared data.
3.	If the acting processor is in E state, there is a read to the same cache line, here we assume this read is from the other processor, and the acting processor will change cache line state from E to S. That is the ONLY case in this project that we assume the read is from another processor.
4.	If this processor (acting processor and the processor we are modeling/simulating) has a cache line in M state, there is a read to the same cache line, we assume this read is from the acting processor (my own processor), NOT from any other processor. Therefore, there won’t be a transition of M->S in this case.

**For instruction cache state transition will be only based on read operation as there will not be any write or RFO/Invalidate operation.**

DESIGN DECISIONS:
DATA STRUCTURE:
Bits we need to store in our cache :
●	We need to store tag, LRU, and MESI bits (metadata) for the simulation purpose..
DATA CACHE:
●	Tag = 12 bits
●	LRU = 8 ways, so for each way we need 3 bits per line
●	MESI = 2 bits
TOTAL = 12 + 3 + 2 = 17 bits per line.
INSTRUCTION CACHE:
●	Tag = 12 bits
●	LRU = 4 ways, so for each way we need 2 bits per line
●	MESI = 2 bits
TOTAL = 12 + 2 + 2 = 16 bits per line.
