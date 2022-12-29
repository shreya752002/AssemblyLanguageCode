;; =============================================================
;; CS 2110 - Fall 2022
;; Project 3 - Bit Shifting, Multiplication, Division, and GCD
;; =============================================================
;; Name: Shreya Puvvula
;; =============================================================

;; PART 1: Bit Shifting

;; Left Shift Suggested Pseudocode (see PDF for explanation)
;;
;; val = R0;
;; amt = R1;
;; 
;; while (amt > 0) {
;;     val = val + val;
;;     amt = amt - 1;
;; }
;; 
;; R0 = val;

.orig x3600
LeftShift
    ADD R1, R1, 0
    LEFTWHILE BRnz LEFTEND
    ADD R0, R0, R0
    ADD R1, R1, -1
    BR LEFTWHILE
    LEFTEND
    RET
.end

;; Right Shift Suggested Pseudocode (see PDF for explanation)
;;
;; val = R0;
;; amt = R1;
;; 
;; result = 0;
;; 
;; while (amt < 16) {
;;     result = result + result;
;;     if (val < 0) { // check if the MSB is set
;;         result = result + 1;
;;     }
;;     val = val + val;
;;     amt = amt + 1;
;; }
;; 
;; R0 = result;

.orig x3800
RightShift
    AND R2, R2, 0            ;;result
    RIGHTWHILE
    ADD R3, R1, -16 
    BRzp RIGHTEND
    ADD R2, R2, R2
    ADD R0, R0, 0
    BRzp IFEND
    ADD R2, R2, 1
    IFEND 
    ADD R0, R0, R0
    ADD R1, R1, 1
    BR RIGHTWHILE
    RIGHTEND
    ADD R0, R2, 0
    RET
.end

;; PART 2: Multiplication and Division

;; Multiply Suggested Pseudocode (see PDF for explanation)
;; 
;; a = R0;
;; b = R1;
;; 
;; result = 0;
;; for (i = 0; i < 16; i++) {
;;     mask = 1 << i;
;;     if (b & mask != 0) {
;;         result = result + (a << i);
;;     }
;; }
;;
;; R0 = result;

.orig x3200
Multiply
    ADD R6, R6, -1      ;;stack R7
    STR R7, R6, 0
    ADD R6, R6, -1
    STR R0, R6, 0       ;;stack R0
    ADD R6, R6, -1
    STR R1, R6, 0       ;;stack R1


    AND R2, R2, 0       ;;result
    AND R3, R3, 0       ;;i
    MultFOR 
    ADD R4, R3, -16     ;;condition i-16
    BRzp MultFOREND

    AND R0, R0, 0
    ADD R0, R0, 1
    ADD R1, R3, 0       ;; R1 = R3 = i
    JSR  LeftShift
    ADD R4, R0, 0       ;;mask

    LDR R5, R6, 0       ;;b --> R5
    AND R5, R5, R4
    BRz MULTIFEND
    LDR R0, R6, 1       ;;a --> R5
    ADD R1, R3, 0
    JSR LeftShift
    ADD R5, R0, 0
    ADD R2, R2, R5

    MULTIFEND 
    ADD R3, R3, 1
    BR MultFOR
    
    MultFOREND
    ADD R0, R2, 0

    LDR R7, R6, 2
    ADD R6, R6, 3
    RET

.end

;; Divide Suggested Pseudocode (see PDF for explanation)
;;
;; a = R0;
;; b = R1;
;; 
;; quotient = 0;
;; remainder = 0;
;; 
;; for (i = 15; i >= 0; i--) {
;;     quotient = quotient + quotient;
;;     remainder = remainder + remainder;
;;     remainder = remainder + ((a >> i) & 1);
;;     
;;     if (remainder >= b) {
;;         remainder = remainder - b;
;;         quotient = quotient + 1;
;;     }
;; }
;; 
;; R0 = quotient;

.orig x3400
Divide
    ADD R6, R6, -1
    STR R7, R6, 0       ;;stack R7
    ADD R6, R6, -1
    STR R0, R6, 0       ;;stack R0
    ADD R6, R6, -1
    STR R1, R6, 0       ;;stack R1

    AND R2, R2, 0       ;;quotient
    AND R3, R3, 0       ;;remainder
    AND R4, R4, 0
    ADD R4, R4, 15      ;;i
    DIVFOR BRn DIVEND
    ADD R2, R2, R2
    ADD R3, R3, R3
    
    LDR R0, R6, 1
    ADD R1, R4, 0

    ADD R6, R6, -1
    STR R2, R6, 0
    ADD R6, R6, -1
    STR R3, R6, 0       ;; Storing R2 and R3 in stack

    JSR RightShift
    ADD R0, R0, 0       ;;value from RightShift into R4

    LDR R3, R6, 0
    ADD R6, R6, 1
    LDR R2, R6, 0
    ADD R6, R6, 1       ;;popping R2 and R3 from stack

    AND R0, R0, 1
    ADD R3, R3, R0      ;;remainder = remainder + ((a >> i) & 1);

    LDR R1, R6, 0
    NOT R1, R1
    ADD R1, R1, 1       ;; -b
    ADD R5, R3, R1      ;; R5 --> remainder-b >=0
    
    BRn IF2END
    ADD R3, R3, R1
    ADD R2, R2, 1
    IF2END
    
    ADD R4, R4, -1
    BR DIVFOR
    DIVEND
    ADD R0, R2, 0

    LDR R7, R6, 2
    ADD R6, R6, 3
    RET

    ;;labels
    RIGHTSHIFT  .blkw 1
.end

;; PART 3: GCD

;; Suggested Pseudocode (see PDF for explanation)
;;
;; a = mem[A];
;; b = mem[B];
;; 
;; R6 = mem[STACK];
;;
;; while (b > 0) {
;;     quotient = a / b;
;;     remainder = a - quotient * b;
;;     a = b;
;;     b = remainder;
;; }
;; 
;; mem[RESULT] = a;

.orig x3000
    LD R6, STACK
    LD R0, A
    LD R1, B
    
    GCDWHILE BRnz GCDEND
    
    ST R0, A
    ST R1, B
    JSR Divide   
    ADD R0, R0, 0       ;;quotient = R0

    LD R1, B
    JSR Multiply
    ADD R2, R0, 0       ;;R2 --> product
    
    
    LD R0, A
    NOT R2, R2
    ADD R2, R2, 1
    ADD R2, R0, R2      ;;remainder = a + -R2


    LD R0, B
    ADD R1, R2, 0

    ;;LDR R0, R6, 0
    ;;ADD R0, R1, 0
    ;;ADD R1, R2, 0


    BR GCDWHILE
    GCDEND

    ST R0, RESULT
    HALT

;; Do not rename or remove any existing labels
;; You may change the values of A and B for debugging
STACK       .fill xF000
A           .fill 7
B           .fill 10
RESULT      .blkw 1
.end
