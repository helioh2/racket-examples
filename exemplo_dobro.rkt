;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname exemplo_dobro) (read-case-sensitive #t) (teachpacks ((lib "testing.rkt" "teachpack" "htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "testing.rkt" "teachpack" "htdp")))))

; Numero -> Numero
; Retorna o dobro do valor passado

;(define (dobro n) 0)

; Exemplos
(check-expect (dobro 2) 4)
(check-expect (dobro 3) 6)
(check-expect (dobro -3) -6)

; Template
;(define (fn-for-number n) 
;  (... n))

;; Corpo
(define (dobro n) 
  (* n 2))
