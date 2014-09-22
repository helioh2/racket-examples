;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname exemplo_maior) (read-case-sensitive #t) (teachpacks ((lib "testing.rkt" "teachpack" "htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "testing.rkt" "teachpack" "htdp")))))
;; String String -> String
;; Verifica e retorna a palavra com maior quantidade de caracteres

;(define (maior-palavra palavra1 palavra2) "") ;<-- cabeçalho (stub)

;; Exemplos
(check-expect (maior-palavra "pneumoultramicroscopicossilicovulcanoconiotico" "bobo") 
              "pneumoultramicroscopicossilicovulcanoconiotico")
(check-expect (maior-palavra "mané" "otorrinolaringologista") "otorrinolaringologista")
(check-expect (maior-palavra "raposa" "coelho") "raposa")

;;Template
;(define (maior-palavra palavra1 palavra2)
;  (... palavra1 palavra2))

;;Corpo
(define (maior-palavra palavra1 palavra2)
  (if (>= (string-length palavra1) (string-length palavra2) )
      palavra1
      palavra2))


