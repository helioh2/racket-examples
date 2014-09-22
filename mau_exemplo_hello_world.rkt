;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname mau_exemplo_hello_world) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ())))
; string -> string 

; (greet "foo") produces "Hello foo" 


(define (greet str)             
              ;; put "Hello " before string
              (string-append "Hello " str)
)


(check-expect (greet "World!") "Hello World!")
(check-expect (greet "goodbye")  "Hello goodbye")
(check-expect (greet "lonliness")    "Hello lonliness")

;(define (accio o)  ; stub 
;  "a")

(greet "World!")
(greet "goodbye")
(greet "lonliness")