;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname tall) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")))))
(require 2htdp/image)

;; PROBLEMA
;; Dada uma imagem verificar se ela é alta

;; Imagem -> Boolean
;; Retorna true se a imagem é alta e false caso contrário

;(define (alto? imagem) false)

(check-expect (alto? (rectangle 30 60 "solid" "red")) true)
(check-expect (alto? (rectangle 100 20 "solid" "red")) false)
(check-expect (alto? (rectangle 30 30 "solid" "red")) true)

;Template
;(define (fn-for-image img)
;  (... img))

(define (alto? imagem)
  (if (>= (image-height imagem) (image-width imagem))
      true
      false))


