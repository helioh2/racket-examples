;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname exemplo_par) (read-case-sensitive #t) (teachpacks ((lib "testing.rkt" "teachpack" "htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "testing.rkt" "teachpack" "htdp")))))



;; Numero -> Boolean
;; Retorna true se numero é par, false se é impar

;(define (eh-par? n) false)

;;Exemplos

(check-expect (eh-par? 3) false)
(check-expect (eh-par? 4) true)
(check-expect (eh-par? 0) true)
(check-expect (eh-par? -2) true)
(check-expect (eh-par? -5) false)

;;Template
;(define (eh-par? n)
;  (... n))
  

;;Corpo
(define (eh-par? n)
  (= (remainder n 2) 0 ))
  
  
  

