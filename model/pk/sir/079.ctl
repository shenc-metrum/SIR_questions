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
(0.461534701658031)   ;  1 KA (1/hr) - 1.5
(4.10888548957552)   ;  2 V2 (L) - 60
(1.13441495294761)   ;  3 CL (L/hr) - 3.5
(4.19404344195679)   ;  4 V3 (L) - 70
(1.26570242116999)   ;  5 Q  (L/hr) - 4
(0.505223659354842)   ;  6 CLEGFR~CL ()
(-0.067001792868334)   ;  7 AGE~CL ()
(0.3687301446357)   ;  8 ALB~CL ()

$OMEGA BLOCK(3)
0.176150571957663                                 ;ETA(KA)
0.0400820208009177 0.0699701222684425                  ;ETA(V2)
0.104793674940158 0.0592273428157874 0.106686115718434   ;ETA(CL)

$SIGMA
0.0390677949172101     ; 1 pro error

$EST MAXEVAL=0 METHOD=1 INTER SIGL=6 NSIG=3 PRINT=1