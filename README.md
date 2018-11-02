# Pi-VAX
Compute pi to an arbitrary number of digits using VAX FORTRAN.  Why, you ask?  Why not?

The program uses Machin's series for computation of pi.  See https://en.wikipedia.org/wiki/John_Machin for details.

Set DIGITS in the source file PI.FOR to the number of digits desired.  

To compile/link under VMS:

```
$ FORTRAN/LIS PI.FOR
$ LINK PI
```

And to run it, just:

```
$ RUN PI
```

Be prepared to wait quite a while for a large number of digits.  100,000 digits takes about 
8 hours on a newer (circa 1995) MicroVAX 3100/80.

This is a FORTRAN port of an older program I wrote for this purpose in PL/I.

K. McQuiggin
