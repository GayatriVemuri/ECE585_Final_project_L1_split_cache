#ifndef _DEFINES_H
#define _GNU_SOURCE

#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <inttypes.h>
//#define DEBUG 1
#define COVERAGE

#ifdef DEBUG
#define D if (1)
#else
#define D if (0)
#endif

#ifdef COVERAGE
#define C if (1)
#else
#define C if (0)
#endif

#define MRU_DATA (WAYS_DATA - 1)
#define MRU_INSTR (WAYS_INSTR - 1)
#define LRU 0

#define SETS 16 * 1024			  // Same number of sets for both cache.
#define WAYS_DATA 8				  // ways for data cache
#define WAYS_INSTR 4			  // ways for instruction cache
#define BYTES sizeof(stored_data) // these three extra lines are for our calculations.
#define CACHE_SIZE_DATA (SETS * WAYS_DATA * BYTES)
#define CACHE_SIZE_INSTR (SETS * WAYS_INSTR * BYTES)
#define LINE_LENGTH 250
#define FILE_NAME  "traceFile.txt"

// MESI states:-
#define I 0
#define M 1
#define E 2
#define S 3

// Data structures:-
typedef union // this union will have 32 bits memory space allocated to it
{
	struct __attribute__((__packed__))
	{
		uint8_t byte : 6;
		uint16_t index : 14;
		uint16_t tag : 12;
	} bits;
	uint32_t addr_store; // we will store the retrived address from the file and will access them by the size we need (as given in the above structure).
} input_addr;

typedef struct __attribute__((__packed__)) // this structure will have 16 bits allocated to it.
{
	uint16_t tag_store : 12;
	uint8_t MESI : 2;
	uint8_t reserved : 1;
	bool line_accessed : 1;
} stored_data;

typedef struct address_s
{
	int n;
	uint32_t addr;
} address_t, *addressPtr_t;

// Global variables:-
extern int read_result;
extern int write_result;
extern int hits;
extern int hitsI;
extern int misses;
extern int missesI;
extern int way_num;
extern int wayflag;
// extern int mode;
// int way_num;
stored_data instruction_cache[SETS][WAYS_INSTR]; // to store instruction cache line data which are of type stored_data (structure).
stored_data data_cache[SETS][WAYS_DATA];		 // to store data cache line .
uint8_t LRU_instruction[SETS][WAYS_INSTR];
uint8_t LRU_data[SETS][WAYS_DATA];
uint8_t lru_count[SETS][WAYS_DATA];

// Function definitions :-
/* This function is checking if the tag is valid or not. */
bool valid_tag(uint8_t mesi);

/* This function is checking if the tag is valid or not. */
bool hit_or_miss(uint16_t tag_select, uint16_t ip_index, uint8_t op_n);

/* This function is checking if the line is invalid or not. */
int lru_invalid_line(uint16_t ip_index, uint8_t n_op);

/* This function is checking if the line is invalid or not. */
bool invalid_line(uint16_t index, uint8_t n);

/* This function is reading the file and storing the address of the file in the address_t structure. */
address_t *read_file(const char *filename, int *size);

/* This function is converting the integer value to string. */
char *itoa(int value, char *result, int base);

/* This function is checking if the line is valid or not. */
bool lru_counter_instruction(int index, int way_num);

/* This function is checking if the line is valid or not. */
bool lru_counter_data(int index, int way_num);

/* This function is checking if the line is valid or not. */
void cache_behaviour(int N, uint16_t index, int way_num);

/* This function is printing the hit and miss count. */
void print_hit_miss(void);

/* This function is printing the accessed lines in the cache. */
void print_accessed_lines(void);

/* This function is clearing the cache and resetting the LRU counter. */
void clear_reset(void);

/* This function is updating the LRU counter for the instruction cache. */
void UpdateLRUInstr(uint16_t index, int way);

/* This function is updating the LRU counter for the data cache. */
void UpdateLRUData(uint16_t index, int way);

/* This function is setting the LRU counter for the data cache. */
void set_lru();

/* This function is checking if the line is valid or not. */
int victim_line(uint16_t index, uint8_t n);

/* This function is printing the bits of the address. */
void printBits(size_t const size, void const *const ptr);

/* This function is checking if the tag of the line is same as the tag of the address. */
bool same_tag(uint16_t index, uint8_t n, uint16_t tag);

/* This function is checking if the way number is valid or not. */
void check_waynum(uint16_t index);
#endif
