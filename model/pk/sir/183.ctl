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
(0.491735697093774)   ;  1 KA (1/hr) - 1.5
(4.0825204008683)   ;  2 V2 (L) - 60
(1.16152882419953)   ;  3 CL (L/hr) - 3.5
(4.18770468145499)   ;  4 V3 (L) - 70
(1.28142573400082)   ;  5 Q  (L/hr) - 4
(0.409812641964589)   ;  6 CLEGFR~CL ()
(-0.101085968837481)   ;  7 AGE~CL ()
(0.355250016463774)   ;  8 ALB~CL ()

$OMEGA BLOCK(3)
0.220278138790954                                 ;ETA(KA)
0.0587933150788615 0.0854809128980071                  ;ETA(V2)
0.114137474049323 0.072666980294781 0.119194917790303   ;ETA(CL)

$SIGMA
0.0411375535571677     ; 1 pro error

$EST MAXEVAL=0 METHOD=1 INTER SIGL=6 NSIG=3 PRINT=1