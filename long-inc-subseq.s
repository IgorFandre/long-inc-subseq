  .text
  .global _longest_inc_subseq

  .macro push Xn
    sub sp, sp, 16
    str \Xn, [sp]
  .endm

  .macro pop Xn
    ldr \Xn, [sp]
    add sp, sp, 16
  .endm


_longest_inc_subseq:
// Save link register
  push x30

// Save args
  push x0
  push x1

  bl _malloc
  mov x1, x0

  pop x2
  pop x0

// Registers guide:
// x0 - array
// x1 - help_array
// x2 - size of array
// x3 - answer
// x4 - i for big_cycle
// x5 - j for small_cycle
// x6 - buffer
// x7 - buffer

// Prepare registers
  mov x3, 0
  mov x6, 0

// Check if size == 0
  cmp x6, x2
  bge if_empty
  mov x3, 1

if_empty:
  mov x4, 0
  mov x6, 8
  mul x2, x2, x6

big_cycle:
  cmp x4, x2
  bge exit

  mov x6, 1
  str x6, [x1, x4]
  mov x5, 0

small_cycle:
  cmp x5, x4
  bge end_small_cycle

  ldr x6, [x0, x5]
  ldr x7, [x0, x4]
  cmp x6, x7
  bge end_if

  ldr x6, [x1, x4]
  ldr x7, [x1, x5]
  add x7, x7, 1
  cmp x6, x7
  bge end_if

  str x7, [x1, x4]

  cmp x3, x7
  bge end_if
  mov x3, x7

end_if:
  add x5, x5, 8
  b small_cycle

end_small_cycle:
  add x4, x4, 8
  b big_cycle

exit:
// Save answer and call free
  push x3
  mov x0, x1
  bl _free

// Return answer
  pop x0
  pop x30
  ret

