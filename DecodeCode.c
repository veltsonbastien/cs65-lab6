#include "DecodeCode.h"


#include <stdio.h>

mipsinstruction decode(int value)
{
	mipsinstruction instr;

	// TODO: fill in the fields
	
	//Check if it's signed or unsigned 
	int posCheck = (value & (0x00008000))>>15 ; //will give the fifteenth position and determine if I or R 

//	printf("POS CHECK: %d\n", posCheck); 
	
	//It's an R-Type
	if(posCheck == 1){
	  instr.funct = value & (0x0000003F); 	   //should be the last 6 bits  
	  instr.immediate = ((((value & (0x0000FFFF))^(0x0000FFFF))+1) << 31) >> 31; //get the 15 bits, do a two complement's to get the number, sll all the way to the left, and then all the way back to force it to make the number negative   
	  instr.rd = value & (0x0000F800) >> 11; 	   //should be the next 5 bits 
	  instr.rt = (value & (0x001F0000)) >> 16;         //should be the next 5 bits 
	  instr.rs = (value & (0x03E00000)) >> 21;	   //should be the next 5 bits 
	  instr.opcode = (value & (0xFC000000)) >> 26;     //should be the next 6 bits  
		

	}  
	
	//It's an I-Type
	else if (posCheck == 0){
	 //printf("sanity check");
	 instr.funct = value & (0x0000003F);      
         instr.immediate = value&(0x0000FFFF); //get 15 bits 
	 instr.rd = (value & (0x0000F800)) >> 11; //there is no rd, setting to zero 
	 instr.rt = (value & (0x001F0000)) >> 16 ; //should be the next 5 bits  
	 instr.rs = (value & (0x03E00000)) >> 21 ;        //should be the next 5 bits 
	 instr.opcode = (value & (0xFC000000)) >> 26 ;    //should be the next 6 bits
 	}


	//Print everything out to test:
	/* 
	printf("Value passed in: %d \n", value); 
	printf("Funct: %d \n", instr.funct); 
	printf("Immed: %d \n", instr.immediate); 
	printf("RD: %d \n", instr.rd); 
	printf("RT: %d \n", instr.rt); 
	printf("RS: %d \n", instr.rs); 
	printf("Opcode: %d \n", instr.opcode); 
	printf("/*********");
  	*/

	return instr;
}


