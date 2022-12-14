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
(0.288351000347991)   ;  1 KA (1/hr) - 1.5
(4.06844610332658)   ;  2 V2 (L) - 60
(1.13173741867392)   ;  3 CL (L/hr) - 3.5
(4.20272860609693)   ;  4 V3 (L) - 70
(1.3358170395248)   ;  5 Q  (L/hr) - 4
(0.488128621068798)   ;  6 CLEGFR~CL ()
(-0.0769907648859053)   ;  7 AGE~CL ()
(0.430541133027008)   ;  8 ALB~CL ()

$OMEGA BLOCK(3)
0.139094352564734                                 ;ETA(KA)
0.0638390990124696 0.0864705812663687                  ;ETA(V2)
0.125094786937746 0.0876896386994051 0.141091032683111   ;ETA(CL)

$SIGMA
0.0413861234159918     ; 1 pro error

$EST MAXEVAL=0 METHOD=1 INTER SIGL=6 NSIG=3 PRINT=1