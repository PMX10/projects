#include <stdio.h>
#include <stdlib.h>

#include "processor.h"
#include "disassemble.h"

void execute_one_inst(processor_t* p, int prompt, int print_regs)
{
  inst_t inst;

  /* fetch an instruction */
  inst.bits = load_mem(p->pc, SIZE_WORD);
  //prompt = 1;
  /* interactive-mode prompt */
  if(prompt)
  {
    if (prompt == 1) {
      printf("simulator paused, enter to continue...");
      while(getchar() != '\n')
        ;
    }
    printf("%08x: ",p->pc);
    disassemble(inst);
  }
  
  int sign_bit=0, signext_imm=0;// zeroext_imm=0;
  uint32_t lb=0, lh=0, temp;

  //handles sign extended immediate value instructions
  //(beq, bne, addiu, slti, sltiu, lb, lh, lw, lbu, lhu, sb, sh, sw)
  if ((inst.itype.opcode == 0x4) || (inst.itype.opcode == 0x5) ||
      (inst.itype.opcode == 0x9) || (inst.itype.opcode == 0xa) ||
      (inst.itype.opcode == 0xb) || (inst.itype.opcode == 0x20) ||
      (inst.itype.opcode == 0x21) || (inst.itype.opcode == 0x23) ||
      (inst.itype.opcode == 0x24) || (inst.itype.opcode == 0x25) ||
      (inst.itype.opcode == 0x28) || (inst.itype.opcode == 0x29) ||
      (inst.itype.opcode == 0x2b)){
          if ((inst.itype.imm >> 15) == 1){ // if immediate < 0
             signext_imm = 0xFFFF0000 | inst.itype.imm;
          }
          else{                           // if immediate > 0
             signext_imm = 0x0000FFFF & inst.itype.imm;
          }
      }
      
  //handles zero extended immediate value instructions
  /*(andi, ori, xori)
  if ((inst.itype.opcode == 0xc) || (inst.itype.opcode == 0xd) ||
      (inst.itype.opcode == 0xe)){
      zeroext_imm = zeroext_imm | inst.itype.imm;
  }*/
  switch (inst.rtype.opcode) /* could also use e.g. inst.itype.opcode */
  {
  case 0x0: // opcode == 0x0 (SPECIAL)

    switch (inst.rtype.funct)
    {
    case 0x0: // funct == 0x0 (sll)**
      p->R[inst.rtype.rd] = p->R[inst.rtype.rt] << inst.rtype.shamt;
      p->pc += 4;
      break;
      
    case 0x2: // funct == 0x2 (srl)**
      p->R[inst.rtype.rd] = p->R[inst.rtype.rt] >> inst.rtype.shamt;
      p->pc += 4;
      break;
      
    case 0x3: // funct == 0x3 (sra) **
      sign_bit = p->R[inst.rtype.rt] >> 31;
      if (sign_bit == 0)
         p->R[inst.rtype.rd] = p->R[inst.rtype.rt] >> inst.rtype.shamt;
      else{
           int n=1;
           while (n<=inst.rtype.shamt){
                 sign_bit *= 2;
                 n++;
           }
           sign_bit -= 1;      
           sign_bit = sign_bit << (32 - inst.rtype.shamt);
           p->R[inst.rtype.rd] = sign_bit | (p->R[inst.rtype.rt] >> inst.rtype.shamt);
      }
      p->pc += 4;
      break;
    
    case 0x8: // funct == 0x8 (jr)**
      p->pc = p->R[inst.rtype.rs];
      break;
    
    case 0x9: // funct == 0x9 (jalr) **
      temp = p->pc + 4;
      p->pc = p->R[inst.rtype.rs]; 
      p->R[inst.rtype.rd] = temp;
      break;
      
    case 0xc: // funct == 0xc (SYSCALL) **
      handle_syscall(p);
      p->pc += 4;
      break;
    
    case 0x21: // funct == 0x21 (addu)**
      p->R[inst.rtype.rd] = p->R[inst.rtype.rs] + p->R[inst.rtype.rt];
      p->pc += 4;
      break;
      
    case 0x23: // funct == 0x23 (subu)**
      p->R[inst.rtype.rd] = p->R[inst.rtype.rs] - p->R[inst.rtype.rt];
      p->pc += 4;
      break;
    
    case 0x24: // funct == 0x24 (and)**
      p->R[inst.rtype.rd] = p->R[inst.rtype.rs] & p->R[inst.rtype.rt];
      p->pc += 4;
      break;

    case 0x25: // funct == 0x25 (OR)
      p->R[inst.rtype.rd] = p->R[inst.rtype.rs] | p->R[inst.rtype.rt];
      p->pc += 4;
      break;
    
    case 0x26: // funct == 0x26 (xor)**
      p->R[inst.rtype.rd] = p->R[inst.rtype.rs] ^ p->R[inst.rtype.rt];
      p->pc += 4;
      break;
    
    case 0x27: // funct == 0x27 (nor) **
      p->R[inst.rtype.rd] = ~(p->R[inst.rtype.rs] | p->R[inst.rtype.rt]);
      p->pc += 4;
      break;
    
    case 0x2a: // funct == 0x2a (slt) **
       if  ((int)p->R[inst.rtype.rs] < (int)p->R[inst.rtype.rt])
             p->R[inst.rtype.rd] = 1;
       else
             p->R[inst.rtype.rd] = 0;
       p->pc += 4;
      break;
    
    case 0x2b: // funct == 0x2b (sltu) **
       if  (p->R[inst.rtype.rs] < p->R[inst.rtype.rt])
             p->R[inst.rtype.rd] = 1;
       else
             p->R[inst.rtype.rd] = 0;
       p->pc += 4;
      break;

    default: // undefined funct
      fprintf(stderr, "%s: pc=%08x, illegal instruction=%08x\n", __FUNCTION__, p->pc, inst.bits);
      exit(-1);
      break;
    }
    break;


  case 0x2: // opcode == 0x2 (J)
    p->pc = ((p->pc+4) & 0xf0000000) | (inst.jtype.addr << 2);
    break;

  case 0x3: // opcode == 0x3 (jal)**
    p->R[31] = p->pc + 4;
    p->pc = ((p->pc+4) & 0xf0000000) | (inst.jtype.addr << 2);
    break;
  
  case 0x4: // opcode == 0x4 (beq) **
    if (p->R[inst.itype.rs] == p->R[inst.itype.rt])
       p->pc = p->pc + 4 + (signext_imm << 2);
    else
        p->pc = p->pc + 4;
    break;
  
  case 0x5: // opcode == 0x5 (bne) **
    if (p->R[inst.itype.rs] != p->R[inst.itype.rt])
       p->pc = p->pc + 4 + (signext_imm << 2);
    else
        p->pc = p->pc + 4;
    break;
  
  case 0x9: // opcode == 0x9 (addiu) **
    p->R[inst.itype.rt] = p->R[inst.itype.rs] + signext_imm;
    p->pc = p->pc + 4;
    break;
  
  case 0xa: // opcode == 0xa (slti) **
    if ((int)p->R[inst.itype.rs] < signext_imm)
       p->R[inst.itype.rt] = 1;
    else
        p->R[inst.itype.rt] = 0;
    p->pc = p->pc + 4;
    break;
  
  case 0xb: // opcode == 0xb (sltiu) **
    if (p->R[inst.itype.rs] < signext_imm)
        p->R[inst.itype.rt] = 1;
    else
        p->R[inst.itype.rt] = 0;
    p->pc = p->pc + 4;
    break;
  
  case 0xc: // opcode == 0xc (andi) **
    p->R[inst.rtype.rt] = p->R[inst.rtype.rs] & inst.itype.imm;
    p->pc += 4;
    break;
    
  case 0xd: // opcode == 0xd (ORI)
    p->R[inst.itype.rt] = p->R[inst.itype.rs] | inst.itype.imm;
    p->pc += 4;
    break;
  
  case 0xe: // opcode == 0xe (xori) **
    p->R[inst.rtype.rt] = p->R[inst.rtype.rs] ^ inst.itype.imm;
    p->pc += 4;
    break;

  case 0xf: // opcode == 0xf (lui) **
    p->R[inst.itype.rt] = (inst.itype.imm << 16);
    p->pc = p->pc + 4;
    break;
  
  case 0x20: // opcode == 0x20 (lb) **
    lb = load_mem((p->R[inst.itype.rs] + signext_imm), SIZE_BYTE);
    sign_bit = (lb >> 7) % 2;
    if (sign_bit == 1)
       p->R[inst.itype.rt] = lb | 0xffffff00;
    else 
         p->R[inst.itype.rt] = lb & 0x000000ff;
    p->pc = p->pc + 4;
    break;
  
  case 0x21: // opcode == 0x21 (lh) **
    lh = load_mem((p->R[inst.itype.rs] + signext_imm), SIZE_HALF_WORD);
    sign_bit = (lh >> 15) % 2;
    if (sign_bit == 1)
       p->R[inst.itype.rt] = lh | 0xffff0000;
    else 
         p->R[inst.itype.rt] = lh & 0x0000ffff;
    p->pc = p->pc + 4;
    break;
    
  case 0x23: // opcode == 0x23 (lw) **
    p->R[inst.itype.rt] = load_mem((p->R[inst.itype.rs] + signext_imm), SIZE_WORD);
    p->pc = p->pc + 4;
    break;
  
  case 0x24: // opcode == 0x24 (lbu)**
    p->R[inst.itype.rt] = load_mem((p->R[inst.itype.rs] + signext_imm), SIZE_BYTE);
    p->pc = p->pc + 4;
    break;
  
  case 0x25: // opcode == 0x25 (lhu)**
    p->R[inst.itype.rt] = load_mem((p->R[inst.itype.rs] + signext_imm), SIZE_HALF_WORD);
    p->pc = p->pc + 4;
    break;
  
  case 0x28: // opcode == 0x28 (sb)**
    store_mem((p->R[inst.itype.rs] + signext_imm), SIZE_BYTE, p->R[inst.itype.rt]);
    p->pc = p->pc + 4;
    break;
  
  case 0x29: // opcode == 0x29 (sh)**
    store_mem((p->R[inst.itype.rs] + signext_imm), SIZE_HALF_WORD, p->R[inst.itype.rt]);
    p->pc = p->pc + 4;
    break;
  
  case 0x2b: // opcode == 0x2b (sw)**
    store_mem((p->R[inst.itype.rs] + signext_imm), SIZE_WORD, p->R[inst.itype.rt]);
    p->pc = p->pc + 4;
    break;
  

  default: // undefined opcode
    fprintf(stderr, "%s: pc=%08x, illegal instruction: %08x\n", __FUNCTION__, p->pc, inst.bits);
    exit(-1);
    break;
  }

  // enforce $0 being hard-wired to 0
  p->R[0] = 0;

  if(print_regs)
    print_registers(p);
}

void init_processor(processor_t* p)
{
  int i;

  /* initialize pc to 0x1000 */
  p->pc = 0x1000;

  /* zero out all registers */
  for (i=0; i<32; i++)
  {
    p->R[i] = 0;
  }
}

void print_registers(processor_t* p)
{
  int i,j;
  for (i=0; i<8; i++)
  {
    for (j=0; j<4; j++)
      printf("r%2d=%08x ",i*4+j,p->R[i*4+j]);
    puts("");
  }
}

void handle_syscall(processor_t* p)
{
  reg_t i;

  switch (p->R[2]) // syscall number is given by $v0 ($2)
  {
  case 1: // print an integer
    printf("%d", p->R[4]);
    break;

  case 4: // print a string
    for(i = p->R[4]; i < MEM_SIZE && load_mem(i, SIZE_BYTE); i++)
      printf("%c", load_mem(i, SIZE_BYTE));
    break;

  case 10: // exit
    printf("exiting the simulator\n");
    exit(0);
    break;

  case 11: // print a character
    printf("%c", p->R[4]);
    break;

  default: // undefined syscall
    fprintf(stderr, "%s: illegal syscall number %d\n", __FUNCTION__, p->R[2]);
    exit(-1);
    break;
  }
}
