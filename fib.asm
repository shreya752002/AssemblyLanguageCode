;; =============================================================
;; CS 2110 - Fall 2022
;; Project 3 - Fibonacci
;; =============================================================
;; Name:Shreya Puvvula
;; =============================================================

;; Suggested Pseudocode (see PDF for explanation)
;;
;; n = mem[N];
;; result = mem[RESULT];
;; 
;; if (n == 1) {
;;     mem[result] = 0;
;; } else if (n > 1) {
;;     mem[result] = 0;
;;     mem[result + 1] = 1;
;;     for (i = 2; i < n; i++) {
;;         x = mem[result + i - 1];
;;         y = mem[result + i - 2];
;;         mem[result + i] = x + y;
;;     }
;; }

.orig x3000
    ;; Your code here!!
    LD R0, N
    LD R1, RESULT

    ADD R2, R0, -1      ;; put n-1 into R2 to see if it is == 0 or > 0
    BRz IF
    BRp ELSE
    IF AND R5, R5, 0
    STR R5, R1, 0
    BR END 

    ELSE AND R5, R5, 0
    STR R5, R1, 0 
    ADD R5, R5, 1
    STR R5, R1, 1 
    
    AND R2, R2, 0       ;; for loop
    ADD R2, R2, 2
    FOR
    NOT R0, R0
    ADD R0, R0, 1
    ADD R3, R2, R0      ;; i-n < 0
    BRzp END
    ADD R4, R1, R2
    LDR R0, R4, -1

    LDR R5, R4, -2

    ADD R5, R0, R5

    STR R5, R4, 0
    LD R0, N
    LD R1, RESULT


    ADD R2, R2, 1
    BR FOR
    
    END 
    HALT

;; Do not rename or remove any existing labels
;; You may change the value of N for debugging
N       .fill 1
RESULT  .fill x4000
Savei   .blkw 1
.end

.orig x4000
.blkw 100
.end
