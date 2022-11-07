$PROBLEM SIR 106-104 + COV-effects(EGFR, AGE) on CL

$INPUT C NUM ID TIME SEQ CMT EVID AMT DV AGE WT HT EGFR ALB BMI SEX AAG
       SCR AST ALT CP TAFD TAD LDOS MDV BLQ PHASE OID

$DATA ../../../../data/derived/analysis3.csv IGNORE=(C='C', BLQ=1)

$SUBROUTINE ADVAN4 TRANS4

$PK
 
;log transformed PK parms
 
V2WT = LOG(WT/70)
CLWT = LOG(WT/70)*0.75
CLEGFR = LOG(EGFR/90)*THETA(6)
CLAGE = LOG(AGE/35)*THETA(7)
V3WT = LOG(WT/70)
QWT  = LOG(WT/70)*0.75
CLALB = LOG(ALB/4.5)*THETA(8)


KA   = EXP(THETA(1)+ETA(1))
V2   = EXP(THETA(2)+V2WT+ETA(2))
CL   = EXP(THETA(3)+CLWT+CLEGFR+CLAGE+CLALB+ETA(3))
V3   = EXP(THETA(4)+V3WT)
Q    = EXP(THETA(5)+QWT) 

S2 = V2/1000 ; dose in mcg, conc in mcg/mL

$ERROR
IPRED = F 
Y=IPRED*(1+EPS(1))

$THETA  ; log values
(0.442651603032437)   ;  1 KA (1/hr) - 1.5
(4.14397033299438)   ;  2 V2 (L) - 60
(1.18027140662551)   ;  3 CL (L/hr) - 3.5
(4.20197838270196)   ;  4 V3 (L) - 70
(1.28340846114881)   ;  5 Q  (L/hr) - 4
(0.517696953199288)   ;  6 CLEGFR~CL ()
(-0.00304124993197733)   ;  7 AGE~CL ()
(0.448639708993066)   ;  8 ALB~CL ()

$OMEGA BLOCK(3)
0.267533851884677                                 ;ETA(KA)
0.0779678673901038 0.0815274646206049                  ;ETA(V2)
0.135367404551408 0.0747126992197444 0.123042688166222   ;ETA(CL)

$SIGMA
0.0390610867189455     ; 1 pro error

$EST MAXEVAL=0 METHOD=1 INTER SIGL=6 NSIG=3 PRINT=1