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
(0.489545826771166)   ;  1 KA (1/hr) - 1.5
(4.13240343513657)   ;  2 V2 (L) - 60
(1.18794542231483)   ;  3 CL (L/hr) - 3.5
(4.20709849037119)   ;  4 V3 (L) - 70
(1.22031432952117)   ;  5 Q  (L/hr) - 4
(0.465697457744522)   ;  6 CLEGFR~CL ()
(0.0082534662996154)   ;  7 AGE~CL ()
(0.380725349641229)   ;  8 ALB~CL ()

$OMEGA BLOCK(3)
0.130788098471287                                 ;ETA(KA)
0.0299818638869321 0.0581856790378535                  ;ETA(V2)
0.0871923394968206 0.0543127867248785 0.0987200751214277   ;ETA(CL)

$SIGMA
0.0394543659268495     ; 1 pro error

$EST MAXEVAL=0 METHOD=1 INTER SIGL=6 NSIG=3 PRINT=1