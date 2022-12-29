;; =============================================================
;; CS 2110 - Fall 2022
;; Project 3 - ToLowercase
;; =============================================================
;; Name: Shreya Puvvula
;; =============================================================

;; Suggested Pseudocode (see PDF for explanation)
;; 
;; length = mem[LENGTH];
;; 
;; i = 0;
;; while (i < length) {
;;     ready = mem[mem[KBSR]] & x8000;
;;     if (ready == 0) {
;;         continue;
;;     }
;;     currentChar = mem[mem[KBDR]];
;;     if (currentChar == `\0') {
;;         break;
;;     }
;;     currentChar = currentChar | 32; // Use DeMorgan's law!
;;     mem[TEMP + i] = currentChar;
;;     i++;
;; }
;; 
;; i = 0;
;; while (i < length) {
;;     ready = mem[mem[DSR]] & x8000;
;;     if (ready == 0) {
;;         continue;
;;     }
;;     currentChar = mem[TEMP + i];
;;     mem[mem[DDR]] = currentChar;
;;     i++;
;; }

.orig x3000
    LD R0, LENGTH
    NOT R0, R0
    ADD R0, R0, 1
   
    AND R1, R1, 0

    WHILE1
    ADD R2, R1, R0
    BRzp WHILE1END
    LDI R3, KBSR
    LD R4, Bit15Mask
    AND R3, R3, R4
    BRz WHILE1
    LDI R4, KBDR
    BRz WHILE1END

    NOT R4, R4
    LD R5, ThirtyTwo
    NOT R5, R5
    AND R4, R4, R5
    NOT R4, R4
    ;;LDR R3, R1, TEMP
    LEA R3, TEMP
    ADD R5, R1, R3
    STR R4, R5, 0
    ADD R1, R1, 1
    BR WHILE1
    WHILE1END 
    ;;LD R0, LENGTH

    AND R1, R1, 0
    LD R0, LENGTH
    NOT R0, R0
    ADD R0, R0, 1
    WHILE2
    ADD R2, R1, R0
    BRzp WHILE2END
     LDI R3, DSR
    LD R4, Bit15Mask
    AND R3, R3, R4
    BRz WHILE2
    ;;LDR R3, R1, TEMP

    LEA R3, TEMP
    ADD R4, R1, R3
    LDR R4, R4, 0
    STI R4, DDR
    ADD R1, R1, 1
    BR WHILE2
    WHILE2END 

    HALT

;; Do not rename or remove any existing labels
Bit15Mask   .fill x8000
ThirtyTwo   .fill 32
KBSR        .fill xFE00
KBDR        .fill xFE02
DSR         .fill xFE04
DDR         .fill xFE06

LENGTH      .fill 8
TEMP        .blkw 100
.end