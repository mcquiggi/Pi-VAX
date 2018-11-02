C
C     COMPUTATION OF PI UP TO ~400,000 DIGITS USING MACHIN'S SERIES.  
C     See Wikipedia:
C         https://en.wikipedia.org/wiki/John_Machin
C
C     K. MCQUIGGIN, AUGUST 2018
C     
C     MODIFICATION OF ORIGINAL PL/I PROGRAM 
	
      INTEGER*4 DIGITS, CARRY, SIZE, I
      INTEGER*4 P(100000)
      INTEGER*4 R5(100000)
      INTEGER*4 R239(100000)
      INTEGER*4 A(100000)
      COMMON SIZE 

C     ***********************************************************
C     * SETUP - SET DESIRED NUMBER OF DIGITS                    *
C     *                                                         *
C     * SET 'DIGITS' TO THE DESIRED NUMBER OF DIGITS OF PI      *
C     ***********************************************************
      DIGITS=100000
      SIZE=DIGITS/4+3

C     PRINT TITLES
      PRINT 55,'C O M P U T A T I O N   O F   P I'
  55  FORMAT(//,5X,A)
	
C     COMPUTE ARCCOT(5) 
      CALL ARCCOT(5, R5)

C     COMPUTE ARCCOT(239) 
      CALL ARCCOT(239, R239)

C     COMPUTE 4 * ARCCOT(5)
      CARRY=0
      DO 5 I=SIZE,1,-1
      P(I)=4*R5(I)+CARRY
      IF(P(I).LE.9999) GO TO 10
      CARRY=P(I)/10000
      P(I)=P(I)-CARRY*10000
      GO TO 5
  10  CARRY=0
   5  CONTINUE

C     ***************************************
C     * COMPUTE 4 * ARCCOT(5) - ARCCOT(239) *
C     ***************************************
      DO 15 I=SIZE,2,-1
      A(I)=P(I)-R239(I)
      IF(A(I).GE.0) GO TO 15
      P(I-1)=P(I-1)-1
      A(I)=A(I)+10000
  15  CONTINUE
      A(1)=P(1)-R239(1)

C     ****************************************************
C     * COMPUTE PI, OR 4 * (4 * ARCCOT(5) - ARCCOT(239)) *
C     ****************************************************
      CARRY=0
      DO 20 I=SIZE,1,-1
      P(I)=4*A(I)+CARRY
      IF(P(I).LE.9999) GO TO 25
      CARRY=P(I)/10000
      P(I)=P(I)-CARRY*10000
      GO TO 20
  25  CARRY=0
  20  CONTINUE

C     *********************
C     * PRINT THE RESULTS *
C     *********************
      PRINT 65,'PI COMPUTED TO ',DIGITS,' DECIMAL PLACES: '
   65 FORMAT(/,5X,A,I7.2,A,/)

      DO 30 I=1,(SIZE-2),10
      K=I+9
      IF(K.LE.(SIZE-2)) GO TO 40
      K=SIZE-2
   40 PRINT 35, (P(J), J=I,K)
   35 FORMAT(5X,10(I4.4,1X))
   30 CONTINUE

      PRINT 60, 'DONE!'
  60  FORMAT(/,5X,A)
      END
      

C     **************************************
C     * SUBROUTINE TO COMPUTE ARC COTANGET *
C     **************************************
      SUBROUTINE ARCCOT(DIVISOR, RESULT)
      INTEGER DIVISOR
      INTEGER RESULT(100000)

      INTEGER SUM(100000)
      INTEGER XPOWER(100000)
      INTEGER TERM(100000)
      INTEGER*4 A(100000)
      INTEGER*4 SIZE
      COMMON SIZE
 
      INTEGER Q, R, X, N, SIGN
            
      DO 5 I=1,SIZE
   5  A(I)=0
      A(1)=1
      
      DO 15 I=1,SIZE
      Q=A(I)/DIVISOR
      R=MOD(A(I), DIVISOR)
      RESULT(I)=Q
      IF(I.GE.SIZE) GO TO 15 
      A(I+1)=A(I+1)+R*10000
  15  CONTINUE          
   
      DO 20 I=1,SIZE
      SUM(I)=RESULT(I)
      XPOWER(I)=RESULT(I)
  20  CONTINUE
  
      N=3
      SIGN=-1                                                          
      X=DIVISOR*DIVISOR
   
 100  DO 25 I=1,SIZE
  25  A(I)=XPOWER(I)
      
      DO 30 I = 1,SIZE
      Q=A(I)/X
      R=MOD(A(I), X)
      RESULT(I)=Q
      IF(I.GE.SIZE) GO TO 30
      A(I+1)=A(I+1)+R*10000
  30  CONTINUE	

      DO 35 I=1,SIZE
  35  XPOWER(I)=RESULT(I)

      DO 40 I=1,SIZE
  40  A(I)=XPOWER(I)

      DO 45 I = 1,SIZE
      Q=A(I)/N
      R=MOD(A(I), N)
      RESULT(I)=Q
      IF(I.GE.SIZE) GO TO 45
      A(I+1)=A(I+1)+R*10000
  45  CONTINUE	

      DO 50 I=1,SIZE
  50  TERM(I)=RESULT(I)

      DO 55 I= 1,SIZE
      IF(TERM(I).NE.0) GO TO 200
  55  CONTINUE

      DO 60 I=1,SIZE
  60  RESULT(I)=SUM(I)
      
      RETURN 
 
C     FINALLY, COMPUTE THE ARCCOT SERIES (SUM=SUM+/-(SIGN*TERM) ETC)
  200 IF(SIGN.NE.1) GO TO 300
      DO 65 I = SIZE,2,-1
      SUM(I)=SUM(I)+TERM(I)
      IF(SUM(I).LT.10000) GO TO 65
      SUM(I-1)=SUM(I-1)+1
      SUM(I)=SUM(I)-10000
  65  CONTINUE
      SUM(1)=SUM(1)+TERM(1)
      GO TO 400
    
 300  DO 70 I=SIZE,2,-1
      SUM(I)=SUM(I)-TERM(I)
      IF(SUM(I).GE.0) GO TO 70
      SUM(I-1)=SUM(I-1)-1
      SUM(I)=SUM(I)+10000
  70  CONTINUE
      SUM(1)=SUM(1)-TERM(1)

 400  SIGN=-SIGN
      N=N+2
      GO TO 100
      END
