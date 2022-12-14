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
(0.485636702037539)   ;  1 KA (1/hr) - 1.5
(4.11260168423208)   ;  2 V2 (L) - 60
(1.17216845160661)   ;  3 CL (L/hr) - 3.5
(4.18562316469964)   ;  4 V3 (L) - 70
(1.26168867778393)   ;  5 Q  (L/hr) - 4
(0.458778030996369)   ;  6 CLEGFR~CL ()
(0.0106510001438537)   ;  7 AGE~CL ()
(0.473897529853284)   ;  8 ALB~CL ()

$OMEGA BLOCK(3)
0.250000197078075                                 ;ETA(KA)
0.0436447143834569 0.0751961212197533                  ;ETA(V2)
0.118117293094788 0.0591069696048793 0.0991369281550603   ;ETA(CL)

$SIGMA
0.0409314302004661     ; 1 pro error

$EST MAXEVAL=0 METHOD=1 INTER SIGL=6 NSIG=3 PRINT=1