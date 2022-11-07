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
(0.335939273851058)   ;  1 KA (1/hr) - 1.5
(4.10614262116935)   ;  2 V2 (L) - 60
(1.14810666826137)   ;  3 CL (L/hr) - 3.5
(4.18560076847793)   ;  4 V3 (L) - 70
(1.30928870754531)   ;  5 Q  (L/hr) - 4
(0.510963520817626)   ;  6 CLEGFR~CL ()
(-0.00545051658068275)   ;  7 AGE~CL ()
(0.38304592177728)   ;  8 ALB~CL ()

$OMEGA BLOCK(3)
0.181369759749703                                 ;ETA(KA)
0.0740202263987742 0.0965918579522646                  ;ETA(V2)
0.127096722376938 0.0784092090035621 0.123299324287057   ;ETA(CL)

$SIGMA
0.0409984143153635     ; 1 pro error

$EST MAXEVAL=0 METHOD=1 INTER SIGL=6 NSIG=3 PRINT=1