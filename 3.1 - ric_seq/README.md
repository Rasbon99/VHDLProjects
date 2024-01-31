# Exercise 3.1
Design, implement in VHDL, and test through simulation a machine capable of recognizing the sequence 101. The machine takes as input a binary signal i representing the data, a timing signal A, and a mode signal M that regulates its operation, providing a high output Y when the sequence is recognized. In particular,

if M=0, the machine evaluates incoming serial bits in groups of 3 (non-overlapping sequences),
if M=1, the machine evaluates incoming serial bits one at a time, returning to the initial state each time the sequence is correctly recognized (partially overlapping sequences).
