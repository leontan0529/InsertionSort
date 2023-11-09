/*
 * insertion_sort.s
 *
 *  Created on: 10/08/2023
 *      Author: Ni Qingqing
 */
   .syntax unified
	.cpu cortex-m4
	.fpu softvfp
	.thumb

		.global insertion_sort

@ Start of executable code
.section .text

@ EE2028 Assignment 1, Sem 1, AY 2023/24
@ (c) ECE NUS, 2023
@ Insertion sort arr in ascending order

@ Write Student 1’s Name here: Leon Tan Li Yang 
@ Write Student 2’s Name here: Foo Xin Hui, Kelly 

@ You could create a look-up table of registers here:

@ R0: Pointer to the array, number of swaps will be put here at the end of insertion_sort
@ R1: Number of elements (size) in the array, check if all elements are sorted
@ R2: Swap counter, count the total of number of swaps made and initialised counter=0
@ R3: Check counter, identify the current element is at nth position of the array
@ R4: Sort counter, replicate check counter during check to identify the number of elements on the left of current element, hence the number of left swaps that might be required
@ R5: Current element/array[pointer]
@ R6: Next element/array[pointer+1]

@ write your program from here:

@ Back up return address, initiate insertion sort and return number of swaps to main.c
insertion_sort:
	PUSH {R14} //put return address into the stack
    MOV R2,#0 //initialise swap counter
    MOV R3,#0 //initialise check counter

    BL check //branch to check, LR remember address of next line

	MOV R0,R2 //transfer swap counter/number of swaps from R2 to R0
    POP {R14} //fetch return address from LR
	BX LR //PC<-LR, branch back to main.c based on the value (memory address) in R14 (link register)


@ Check and iterate the elements in the array
check:
    CMP R1,#1 //check if all elements have been sorted
    BLE done //if all elements have been sorted, branch to done and prepare to exit

	ADD R3,R3,#1 //increment check counter
    MOV R4, R3 //initialise sort counter, with reference to current check counter
    PUSH {R0} //put return address/working address of array into LR


@ Compare elements
compare:
    LDR R5,[R0] //load current element (array[pointer])
    LDR R6,[R0,#4] //load next element (array[pointer+1])

    CMP R6,R5 //compare array[pointer+1] and array[pointer]
    BGE continue //if array[pointer+1] => array[pointer], branch to continue


@ Sort elements
sort:
    STR R5,[R0,#4] //store array[pointer+1] into array[pointer]
    STR R6,[R0] //store array[pointer] into array[pointer+1]
	ADD R2,R2,#1 //increment swap counter

	SUB R0,R0,#4 //decrement pointer of array to prepare to compare with previous element

	SUBS R4,R4,#1 //decrement sort counter to tell us how many elements to the left of the array to sort
	BLE continue //branch to continue if sort counter is equals to or less than 1

    B compare //branch to compare


@ Prepare to continue to next element of the array
continue:
	POP {R0} //fetch return address/working address of array into LR
    ADD R0,R0,#4 //increment pointer of array
    SUBS R1,R1,#1 //decrement counter for number of elements left to swap
	BNE check //branch to check if R1 is not equals to 0


@ The sorted array is now in place, branch back to main function
done:
	BX LR //PC<-LR, branch back to insertion_sort, prepare to branch back to main.c

