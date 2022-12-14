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
(0.45029189493269)   ;  1 KA (1/hr) - 1.5
(4.12121195126998)   ;  2 V2 (L) - 60
(1.18015632282418)   ;  3 CL (L/hr) - 3.5
(4.19485114711818)   ;  4 V3 (L) - 70
(1.25315553005725)   ;  5 Q  (L/hr) - 4
(0.454575133765509)   ;  6 CLEGFR~CL ()
(0.0731022094731751)   ;  7 AGE~CL ()
(0.343163731586336)   ;  8 ALB~CL ()

$OMEGA BLOCK(3)
0.269142036961543                                 ;ETA(KA)
0.0769051304292197 0.0915067888539212                  ;ETA(V2)
0.14089326525256 0.0787229300526944 0.127225312824801   ;ETA(CL)

$SIGMA
0.0397547545730478     ; 1 pro error

$EST MAXEVAL=0 METHOD=1 INTER SIGL=6 NSIG=3 PRINT=1