#lang racket

(require rackunit)
(require rackunit/text-ui)
(require 2htdp/image)
(require 2htdp/universe)
(require "cowabunga-racket2.rkt")

(define vaca-inicial-com-velocidade-impar-tests
  (test-suite
   "vaca-inicial-com-velocidade-impar-tests"
   (check-equal? (vaca-inicial-com-velocidade-impar (make-vaca 20 2 0 0)) (make-vaca 20 3 0 0))
   (check-equal? (vaca-inicial-com-velocidade-impar (make-vaca 20 3 0 0)) (make-vaca 20 3 0 0))
   (check-equal? (vaca-inicial-com-velocidade-impar (make-vaca 0 0 20 2)) (make-vaca 0 0 20 3))
   (check-equal? (vaca-inicial-com-velocidade-impar (make-vaca 0 0 20 3)) (make-vaca 0 0 20 3))))


(define proxima-cena-tests
  (test-suite
   "proxima-cena-tests"
   
   ;sem colisão
   (check-equal? (proxima-cena (make-jogo (make-vaca 200 3 300 0) (make-chupacabra 400 -3 300 0)))
                 (make-jogo (make-vaca (+ 200 3) 3 300 0) (make-chupacabra (- 400 3) -3 300 0))) 
   
   ;colisão com chupacabra à direita
   (check-equal? (proxima-cena (make-jogo (make-vaca (- 200 METADE-VACA-VERTICAL) 3 300 0) 
                                          (make-chupacabra (+ 206 METADE-CHUPA-CABRA-VERTICAL) -3 300 0)))
                 (make-jogo false (make-chupacabra (+ 203 METADE-CHUPA-CABRA-VERTICAL) -3 300 0))) 
   
   ;colisão com chupacabra à esquerda
   (check-equal? (proxima-cena (make-jogo (make-vaca (+ 200 METADE-VACA-VERTICAL) -3 300 0) 
                                          (make-chupacabra (- 194 METADE-CHUPA-CABRA-VERTICAL) 3 300 0)))
                 (make-jogo false (make-chupacabra (- 197 METADE-CHUPA-CABRA-VERTICAL) 3 300 0))) 
   
   ;colisão com chupacabra à direita com deslocamento de y pra cima
   (check-equal? (proxima-cena (make-jogo (make-vaca (- 200 METADE-VACA-VERTICAL) 3 (- 300 (/ METADE-CHUPA-CABRA-HORIZONTAL 2))  0) 
                                          (make-chupacabra (+ 206 METADE-CHUPA-CABRA-VERTICAL) -3 300 0)))
                 (make-jogo false (make-chupacabra (+ 203 METADE-CHUPA-CABRA-VERTICAL) -3 300 0))) 
   
   ;colisão com chupacabra à esquerda com deslocamento de y pra cima
   (check-equal? (proxima-cena (make-jogo (make-vaca (+ 200 METADE-VACA-VERTICAL) -3 (- 300 (/ METADE-CHUPA-CABRA-HORIZONTAL 2)) 0) 
                                          (make-chupacabra (- 194 METADE-CHUPA-CABRA-VERTICAL) 3 300 0)))
                 (make-jogo false (make-chupacabra (- 197 METADE-CHUPA-CABRA-VERTICAL) 3 300 0))) 
   
   
   ;colisão com chupacabra com parte de baixo com deslocamento de y pra esquerda
   (check-equal? (proxima-cena (make-jogo (make-vaca (- 300 (/ METADE-CHUPA-CABRA-VERTICAL 2)) 0 (- 200 METADE-VACA-HORIZONTAL) 3) 
                                          (make-chupacabra 300 0 (+ 206 METADE-CHUPA-CABRA-HORIZONTAL) -3)))
                 (make-jogo false (make-chupacabra 300 0 (+ 203 METADE-CHUPA-CABRA-HORIZONTAL) -3))) 
   
   ;colisão com chupacabra à esquerda com deslocamento de y pra cima
   (check-equal? (proxima-cena (make-jogo (make-vaca (- 300 (/ METADE-CHUPA-CABRA-VERTICAL 2)) 0 (+ 200 METADE-VACA-HORIZONTAL) -3) 
                                          (make-chupacabra 300 0 (- 194 METADE-CHUPA-CABRA-HORIZONTAL) 3)))
                 (make-jogo false (make-chupacabra 300 0 (- 197 METADE-CHUPA-CABRA-HORIZONTAL) 3))) 
   
   (check-equal? (proxima-cena J2) J3) ;vaca false -> jogo false
   (check-equal? (proxima-cena J3) J3) ;jogo false -> jogo false
   ))


(define colisao-vaca-chupacabra?-tests
  (test-suite
   "colisao-vaca-chupacabra?-tests"
   
   ;sem colisao
   (check-equal? (colisao-vaca-chupacabra? (make-vaca 100 3 300 0) (make-chupacabra 500 -3 300 0)) 
                 false)
   
   ;colisao à direita
   (check-equal? (colisao-vaca-chupacabra? (make-vaca (- 203 METADE-VACA-VERTICAL) 3 (- 300 (/ METADE-CHUPA-CABRA-HORIZONTAL 2))  0) 
                                           (make-chupacabra (+ 203 METADE-CHUPA-CABRA-VERTICAL) -3 300 0))
                 true)
   
   ;colisão à esquerda
   (check-equal? (colisao-vaca-chupacabra? (make-vaca (+ 197 METADE-VACA-VERTICAL) -3 (- 300 (/ METADE-CHUPA-CABRA-HORIZONTAL 2)) 0) 
                                           (make-chupacabra (- 197 METADE-CHUPA-CABRA-VERTICAL) 3 300 0))
                 true) 
   
   ;colisão baixo
   (check-equal? (colisao-vaca-chupacabra? (make-vaca (- 300 (/ METADE-CHUPA-CABRA-VERTICAL 2)) 0 (- 203 METADE-VACA-HORIZONTAL) 3) 
                                           (make-chupacabra 300 0 (+ 203 METADE-CHUPA-CABRA-HORIZONTAL) -3))
                 true) 
   
   ;colisão cima
   (check-equal? (colisao-vaca-chupacabra? (make-vaca (- 300 (/ METADE-CHUPA-CABRA-VERTICAL 2)) 0 (+ 197 METADE-VACA-HORIZONTAL) -3) 
                                           (make-chupacabra 300 0 (- 197 METADE-CHUPA-CABRA-HORIZONTAL) 3))
                 true) 
   
   ))


(define proxima-vaca-tests
  (test-suite
   "proxima-vaca-tests"
   
   (check-equal? (proxima-vaca (make-vaca 200 3 300 0)) (make-vaca (+ 200 3) 3 300 0))
   (check-equal? (proxima-vaca (make-vaca 200 -3 300 0)) (make-vaca (- 200 3) -3 300 0))
   (check-equal? (proxima-vaca (make-vaca 200 0 300 3)) (make-vaca 200 0 (+ 300 3) 3))
   (check-equal? (proxima-vaca (make-vaca 200 0 300 -3)) (make-vaca 200 0 (- 300 3) -3)) 
   
   (check-equal? (proxima-vaca (make-vaca (- POSICAO-VACA-LIMITE-DIREITO 3) 3 300 0)) 
                 (make-vaca POSICAO-VACA-LIMITE-DIREITO 3 300 0))     ;pára no limite x
   
   (check-equal? (proxima-vaca (make-vaca (- POSICAO-VACA-LIMITE-DIREITO 2) 3 300 0)) 
                 (make-vaca POSICAO-VACA-LIMITE-DIREITO -3 300 0)) ;passa do limite x = POSICAO-VACA-LIMITE-DIREITO -> volta
   
   (check-equal? (proxima-vaca (make-vaca (+ POSICAO-VACA-LIMITE-ESQUERDO 3) -3 300 0)) 
                 (make-vaca POSICAO-VACA-LIMITE-ESQUERDO -3 300 0))     ;pára no limite x
   
   (check-equal? (proxima-vaca (make-vaca (+ POSICAO-VACA-LIMITE-ESQUERDO 2) -3 300 0)) 
                 (make-vaca POSICAO-VACA-LIMITE-ESQUERDO 3 300 0)) ;passa do limite x = POSICAO-VACA-LIMITE-ESQUERDO -> volta
   
   
   (check-equal? (proxima-vaca (make-vaca 300 0 (- POSICAO-VACA-LIMITE-BAIXO 3) 3)) 
                 (make-vaca 300 0 POSICAO-VACA-LIMITE-BAIXO 3))     ;pára no limite y
   
   (check-equal? (proxima-vaca (make-vaca 300 0 (- POSICAO-VACA-LIMITE-BAIXO 2) 3)) 
                 (make-vaca 300 0 POSICAO-VACA-LIMITE-BAIXO -3)) ;passa do limite y = POSICAO-VACA-LIMITE-CIMA -> volta
   
   (check-equal? (proxima-vaca (make-vaca 300 0 (+ POSICAO-VACA-LIMITE-CIMA 3) -3)) 
                 (make-vaca 300 0 POSICAO-VACA-LIMITE-CIMA -3))     ;pára no limite y
   
   (check-equal? (proxima-vaca (make-vaca 300 0 (+ POSICAO-VACA-LIMITE-CIMA 2) -3)) 
                 (make-vaca 300 0 POSICAO-VACA-LIMITE-CIMA 3)) ;passa do limite y = POSICAO-VACA-LIMITE-BAIXO -> volta
   ))


(define proximo-chupacabra-tests
  (test-suite
   "proximo-chupacabra-tests"
   
   (check-equal? (proximo-chupacabra (make-chupacabra 200 3 300 0)) (make-chupacabra (+ 200 3) 3 300 0))
   (check-equal? (proximo-chupacabra (make-chupacabra 200 -3 300 0)) (make-chupacabra (- 200 3) -3 300 0))
   (check-equal? (proximo-chupacabra (make-chupacabra 200 0 300 3)) (make-chupacabra 200 0 (+ 300 3) 3))
   (check-equal? (proximo-chupacabra (make-chupacabra 200 0 300 -3)) (make-chupacabra 200 0 (- 300 3) -3)) 
   
   (check-equal? (proximo-chupacabra (make-chupacabra (- POSICAO-CHUPA-CABRA-LIMITE-DIREITO 3) 3 300 0)) 
                 (make-chupacabra POSICAO-CHUPA-CABRA-LIMITE-DIREITO 3 300 0))     ;pára no limite x
   
   (check-equal? (proximo-chupacabra (make-chupacabra (- POSICAO-CHUPA-CABRA-LIMITE-DIREITO 2) 3 300 0)) 
                 (make-chupacabra POSICAO-CHUPA-CABRA-LIMITE-DIREITO -3 300 0)) ;passa do limite x = POSICAO-CHUPA-CABRA-LIMITE-DIREITO -> volta
   
   (check-equal? (proximo-chupacabra (make-chupacabra (+ POSICAO-CHUPA-CABRA-LIMITE-ESQUERDO 3) -3 300 0)) 
                 (make-chupacabra POSICAO-CHUPA-CABRA-LIMITE-ESQUERDO -3 300 0))     ;pára no limite x
   
   (check-equal? (proximo-chupacabra (make-chupacabra (+ POSICAO-CHUPA-CABRA-LIMITE-ESQUERDO 2) -3 300 0)) 
                 (make-chupacabra POSICAO-CHUPA-CABRA-LIMITE-ESQUERDO 3 300 0)) ;passa do limite x = POSICAO-CHUPA-CABRA-LIMITE-ESQUERDO -> volta
   
   
   (check-equal? (proximo-chupacabra (make-chupacabra 300 0 (- POSICAO-CHUPA-CABRA-LIMITE-BAIXO 3) 3)) 
                 (make-chupacabra 300 0 POSICAO-CHUPA-CABRA-LIMITE-BAIXO 3))     ;pára no limite y
   
   (check-equal? (proximo-chupacabra (make-chupacabra 300 0 (- POSICAO-CHUPA-CABRA-LIMITE-BAIXO 2) 3)) 
                 (make-chupacabra 300 0 POSICAO-CHUPA-CABRA-LIMITE-BAIXO -3)) ;passa do limite y = POSICAO-CHUPA-CABRA-LIMITE-CIMA -> volta
   
   (check-equal? (proximo-chupacabra (make-chupacabra 300 0 (+ POSICAO-CHUPA-CABRA-LIMITE-CIMA 3) -3)) 
                 (make-chupacabra 300 0 POSICAO-CHUPA-CABRA-LIMITE-CIMA -3))     ;pára no limite y
   
   (check-equal? (proximo-chupacabra (make-chupacabra 300 0 (+ POSICAO-CHUPA-CABRA-LIMITE-CIMA 2) -3)) 
                 (make-chupacabra 300 0 POSICAO-CHUPA-CABRA-LIMITE-CIMA 3)) ;passa do limite y = POSICAO-CHUPA-CABRA-LIMITE-BAIXO -> volta
   
   ))



(define desenha-cena-tests
  (test-suite
   "desenha-cena-tests"
   
   (check-equal? (desenha-cena (make-jogo (make-vaca 200 3 300 0) (make-chupacabra 400 -3 300 0)))
                 (place-image VACA-INO+ 200 300 (place-image CHUPA-CABRA-VORTANO 400 300 CENA)))
   (check-equal? (desenha-cena (make-jogo (make-vaca 200 -3 300 0) (make-chupacabra 400 -3 300 0)))
                 (place-image VACA-VORTANO+ 200 300 (place-image CHUPA-CABRA-VORTANO 400 300 CENA)))
   (check-equal? (desenha-cena (make-jogo false (make-chupacabra 400 -3 300 0)))
                 (place-image CHUPA-CABRA-VORTANO 400 300 CENA))
   (check-equal? (desenha-cena false) 
                 (place-image (text "Game Over" 100 "red") (/ COMPRIMENTO 2) (/ ALTURA 2) CENA))
   
   ))


(define escolher-imagem-chupacabra-tests
  (test-suite
   "escolher-imagem-chupacabra-tests"
   
   (check-equal? (escolher-imagem-chupacabra (make-chupacabra 100 3 200 0)) CHUPA-CABRA-INO)
   (check-equal? (escolher-imagem-chupacabra (make-chupacabra 100 0 200 3)) CHUPA-CABRA-INO)
   (check-equal? (escolher-imagem-chupacabra (make-chupacabra 100 -3 200 0)) CHUPA-CABRA-VORTANO)
   ))


(define desenha-vaca-tests
  (test-suite
   "desenha-vaca-tests"
   (check-equal? (desenha-vaca (make-vaca 200 3 400 0)) (place-image VACA-INO+ 200 400 CENA))
   (check-equal? (desenha-vaca (make-vaca 100 -3 400 0)) (place-image VACA-VORTANO+ 100 400 CENA)) 
   (check-equal? (desenha-vaca false) CENA)
   ))


(define escolher-imagem-tests
  (test-suite
   "escolher-imagem-tests"
   (check-equal? (escolher-imagem (make-vaca 20 3 0 0)) VACA-INO+)
   (check-equal? (escolher-imagem (make-vaca 20 -3 0 0)) VACA-VORTANO+)
   (check-equal? (escolher-imagem (make-vaca 23 3 0 0)) VACA-INO-)
   (check-equal? (escolher-imagem (make-vaca 23 -3 0 0)) VACA-VORTANO-)
   
   (check-equal? (escolher-imagem (make-vaca 0 0 20 3)) VACA-INO+)
   (check-equal? (escolher-imagem (make-vaca 0 0 23 3)) VACA-INO-)
   
   (check-equal? (escolher-imagem (make-vaca 360 0 106.5 5)) VACA-INO+)
   (check-equal? (escolher-imagem (make-vaca 360 0 111.5 5)) VACA-INO-)
   
   ))


(define trata-tecla-tests
  (test-suite
   "trata-tecla-tests"
   (check-equal? (trata-tecla (make-jogo (make-vaca 20 3 40 0) CC1) "a") (make-jogo (make-vaca 20 -3 40 0) CC1))
   (check-equal? (trata-tecla (make-jogo (make-vaca 20 -3 40 0) CC1) "d") (make-jogo (make-vaca 20 3 40 0) CC1))
   (check-equal? (trata-tecla (make-jogo (make-vaca 20 0 40 3) CC1) "w") (make-jogo (make-vaca 20 0 40 -3) CC1))
   (check-equal? (trata-tecla (make-jogo (make-vaca 20 0 40 -3) CC1) "s") (make-jogo (make-vaca 20 0 40 3) CC1))
   (check-equal? (trata-tecla (make-jogo (make-vaca 20 3 40 4) CC1) "0") (make-jogo (make-vaca 20 3 40 4) CC1))
   ))


(define trata-a-tests
  (test-suite
   "trata-a-tests"
   (check-equal? (trata-a (make-vaca 20 3 40 0)) (make-vaca 20 -3 40 0))
   (check-equal? (trata-a (make-vaca 20 -3 40 0)) (make-vaca 20 -3 40 0))
   (check-equal? (trata-a (make-vaca 20 0 40 3)) (make-vaca 20 -3 40 0))
   (check-equal? (trata-a (make-vaca 20 0 40 -3)) (make-vaca 20 -3 40 0))
   ))


(define trata-d-tests
  (test-suite
   "trata-d-tests"
   (check-equal? (trata-d (make-vaca 20 3 40 0)) (make-vaca 20 3 40 0))
   (check-equal? (trata-d (make-vaca 20 -3 40 0)) (make-vaca 20 3 40 0))
   (check-equal? (trata-d (make-vaca 20 0 40 3)) (make-vaca 20 3 40 0))
   (check-equal? (trata-d (make-vaca 20 0 40 -3)) (make-vaca 20 3 40 0))
   ))


(define trata-w-tests
  (test-suite
   "trata-w-tests"
   (check-equal? (trata-w (make-vaca 20 3 40 0)) (make-vaca 20 0 40 -3))
   (check-equal? (trata-w (make-vaca 20 -3 40 0)) (make-vaca 20 0 40 -3))
   (check-equal? (trata-w (make-vaca 20 0 40 3)) (make-vaca 20 0 40 -3))
   (check-equal? (trata-w (make-vaca 20 0 40 -3)) (make-vaca 20 0 40 -3))
   ))


(define trata-s-tests
  (test-suite
   "trata-s-tests"
   (check-equal? (trata-s (make-vaca 20 3 40 0)) (make-vaca 20 0 40 3))
   (check-equal? (trata-s (make-vaca 20 -3 40 0)) (make-vaca 20 0 40 3))
   (check-equal? (trata-s (make-vaca 20 0 40 3)) (make-vaca 20 0 40 3))
   (check-equal? (trata-s (make-vaca 20 0 40 -3)) (make-vaca 20 0 40 3))
   ))


;;;;;;;;;;;;;;;;;;;;
;; Funções para auxiliar nos testes

;; Teste ... -> Void
;; Executa um conjunto de testes.
(define (executa-testes . testes)
  (run-tests (test-suite "Todos os testes" testes))
  (void))

;; Chama a função para executar os testes.
(executa-testes 
 vaca-inicial-com-velocidade-impar-tests
 proxima-cena-tests
 colisao-vaca-chupacabra?-tests
 proxima-vaca-tests
 proximo-chupacabra-tests
 desenha-cena-tests
 escolher-imagem-chupacabra-tests
 desenha-vaca-tests
 escolher-imagem-tests
 trata-tecla-tests
 trata-a-tests
 trata-d-tests
 trata-w-tests
 trata-s-tests)
