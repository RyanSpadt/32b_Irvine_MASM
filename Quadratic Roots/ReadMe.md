<p>
<b>Tool Information:</b><br/>
Microsoft Visual Studio Community 2019 Version 16.4.4
Microsoft .NET Framework Version 4.8.04084

<b>Description:</b><br/>
Program accepts three coefficients from the user in the console, it then takes those coefficients and calculates the roots via the quadratic formula. If A of Ax^2+Bx+C is 0
it will tell the user A cannot be 0. If the root is an imaginary number it will not calculate the root and instead display an error message.

<b>Potential Problems:</b><br/>
  1. When using the FST instruction it is possible that the number provided may be too small and throw an underflow exception.
  2. It is possible a result may be too large for the memory location when using the FST instruction to transfer a floating point value to memory location. At the current time 
      REAL4 is the size allocated to the memory locations used in the program, this could be increased to a larger value if needed.
  3. Currently the FWAIT instruction is not being used after loading values onto the FPU Stack. If an exception occurred while loading values onto the stack it would go unhandled.
      This could be solved by adding FWAIT after each instruction that loads a value onto the stack.
  4. When moving values from our FPU Stack into CPU register AX via the fnstsw instruction, we are also not checking for pending exceptions. This could be resolved by using the
      fstfw instruction.
  5. Program does not calculate roots if there are imaginary numbers inside of the square root portion of the calculation. 
  6. Program does not calculate roots if the A coefficient is 0.

<b>Images:</b><br/>
 </p> 
 <img src="Quadratic Roots/imgs/pa-08-session-01.png">
 
 <img src="Quadratic Roots/imgs/pa-08-session-02.png">
 
 <img src="Quadratic Roots/imgs/pa-08-session-03.png">
