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
(0.536733317627007)   ;  1 KA (1/hr) - 1.5
(4.15531711372494)   ;  2 V2 (L) - 60
(1.20131885507079)   ;  3 CL (L/hr) - 3.5
(4.21286941943798)   ;  4 V3 (L) - 70
(1.28034871870504)   ;  5 Q  (L/hr) - 4
(0.449984315585206)   ;  6 CLEGFR~CL ()
(-0.0472261959752909)   ;  7 AGE~CL ()
(0.184116105151063)   ;  8 ALB~CL ()

$OMEGA BLOCK(3)
0.234021855658013                                 ;ETA(KA)
0.078292450937666 0.0801327977946136                  ;ETA(V2)
0.141554327077744 0.0659048586901236 0.11161043872433   ;ETA(CL)

$SIGMA
0.0404005447188456     ; 1 pro error

$EST MAXEVAL=0 METHOD=1 INTER SIGL=6 NSIG=3 PRINT=1