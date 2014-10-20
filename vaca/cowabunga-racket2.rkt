#lang racket

(require 2htdp/image)
(require 2htdp/universe)

(provide (all-defined-out))

;; Programa da vaca na cerca

;; =================
;; Constants:

(define VACA-INO (bitmap "./vaca-ino.png"))
(define VACA-VORTANO (flip-horizontal VACA-INO))

(define CHUPA-CABRA-VORTANO (bitmap "./chupacabra.jpg"))
(define CHUPA-CABRA-INO (flip-horizontal CHUPA-CABRA-VORTANO))

(define COMPRIMENTO 600)
(define ALTURA 400)

(define CENA (empty-scene COMPRIMENTO ALTURA))

(define VACA-INO+ (rotate 5 VACA-INO))
(define VACA-INO- (rotate -5 VACA-INO))
(define VACA-VORTANO+ (rotate 5 VACA-VORTANO))
(define VACA-VORTANO- (rotate -5 VACA-VORTANO))

(define METADE-VACA-VERTICAL (/ (image-width VACA-INO) 2))
(define METADE-VACA-HORIZONTAL (/ (image-height VACA-INO) 2))
(define POSICAO-VACA-LIMITE-ESQUERDO METADE-VACA-VERTICAL)
(define POSICAO-VACA-LIMITE-DIREITO (- COMPRIMENTO METADE-VACA-VERTICAL))
(define POSICAO-VACA-LIMITE-CIMA METADE-VACA-HORIZONTAL)
(define POSICAO-VACA-LIMITE-BAIXO (- ALTURA METADE-VACA-HORIZONTAL))


(define METADE-CHUPA-CABRA-VERTICAL (/ (image-width CHUPA-CABRA-INO) 2))
(define METADE-CHUPA-CABRA-HORIZONTAL (/ (image-height CHUPA-CABRA-INO) 2))
(define POSICAO-CHUPA-CABRA-LIMITE-ESQUERDO METADE-CHUPA-CABRA-VERTICAL)
(define POSICAO-CHUPA-CABRA-LIMITE-DIREITO (- COMPRIMENTO METADE-CHUPA-CABRA-VERTICAL))
(define POSICAO-CHUPA-CABRA-LIMITE-CIMA METADE-CHUPA-CABRA-HORIZONTAL)
(define POSICAO-CHUPA-CABRA-LIMITE-BAIXO (- ALTURA METADE-CHUPA-CABRA-HORIZONTAL))

;; =================
;; Data definitions:

(define-struct vaca (x dx y dy)  #:transparent)
;; Vaca é um desses:
;;   - (make-vaca Natural[0, COMPRIMENTO] Integer Natural[0, ALTURA] Integer)
;;   - ou false
;; interp. 
;;    - Quando vaca está andando livremente (sem ordernhador)
;;        - uma vaca na posição (x y) em pixels na tela, 
;;        - andando a uma velocidade no eixo x: dx  
;;        - e a uma velocidade no eixo y: dy (pixel por tick)
;;    - Quando deu de cara com um chupacabra:
;;        - é false, que significa que o jogo acabou

(define V1 (make-vaca 40 3 25 2))  ;andando pra frente e baixo
(define V2 (make-vaca 40 -5 25 2))  ;andando pra trás e baixo
(define V3 (make-vaca 40 -5 25 -2))  ;andando pra trás e cima
(define V4 (make-vaca 40 5 25 -2))  ;andando pra frente e cima

(define V5 (make-vaca 40 3 25 0))  ;andando pra frente
(define V6 (make-vaca 40 -5 25 0))  ;andando pra trás
(define V7 (make-vaca 40 0 25 2))  ;andando pra baixo
(define V8 (make-vaca 40 0 25 -2))  ;andando pra cima

(define V9 false)  ;vaca pêga pelo chupacabra

#;
(define (fn-for-vaca v)
  (cond [false? v] (...)
        [vaca? v] (... (vaca-x v)
                       (vaca-dx v)
                       (vaca-y v)
                       (vaca-dy v))))


(define-struct chupacabra (x dx y dy) #:transparent)
;; ChupaCabra é um desses:
;;   - (make-chupacabra Natural[0, COMPRIMENTO] Integer Natural[0, ALTURA] Integer)
;;   - ou false
;; interp.
;;   Quando chupacabra está inativo/morto é false, 
;;   senão ele representa a posição x e y na tela e velocidades dx e dy

(define CC1 (make-chupacabra 40 3 25 0))  ;andando pra frente
(define O2 (make-chupacabra 40 -5 25 0))  ;andando pra trás
(define O3 (make-chupacabra 40 0 25 2))  ;andando pra baixo
(define O4 (make-chupacabra 40 0 25 -2))  ;andando pra cima

(define O5 false)  ;morto

#;
(define (fn-for-chupacabra v)
  (cond [false? v] (...)
        [chupacabra? v] (... (chupacabra-x v)
                             (chupacabra-dx v)
                             (chupacabra-y v)
                             (chupacabra-dy v))))


(define-struct jogo (vaca chupacabra) #:transparent)
;; Jogo é um desses:
;;   - (make-jogo Vaca ChupaCabra)
;;   - ou false
;;   - ou true
;; Interp.
;;   Quando vaca é false (pêga por chupacabra) jogo é false (Game Over).
;;   Se chupacabra é false (morto) jogo é ganho
;;   Senão, jogo está correndo, tendo uma vaca controlada pelo jogador,
;;   e um chupacabra andando em algum lugar.

(define J1 (make-jogo (make-vaca 100 3 300 0) (make-chupacabra 400 -3 300 0))) ;jogo em andamento
(define J2 (make-jogo false (make-chupacabra 400 -3 300 0)))  ; vaca morta
(define J3 false)   ; game over
(define J4 (make-jogo (make-vaca 200 3 300 0) false))   ; chupacabra morto
(define J5 true)   ; vitoria

(define JM (make-jogo (make-vaca 100 3 100 0) (make-chupacabra 400 -5 300 0))) ;jogo em andamento

#;
(define (fn-for-jogo j)
  (cond [(false? j) (...)]
        [(true? j) (...) ]
        [(jogo? j) (... (jogo-vaca j)
                        (jogo-chupacabra j))]))



;; =================
;; Funções:

;; Jogo -> Jogo
;; inicie o mundo com (main (make-jogo J1))
;; 
(define (main j)
  (big-bang (make-jogo (vaca-inicial-com-velocidade-impar (jogo-vaca j)) (jogo-chupacabra j))  ; Jogo
            (on-tick   proxima-cena)     ; Jogo -> Jogo
            (to-draw   desenha-cena)      ; Jogo -> Image
            (on-key    trata-tecla)))     ; Jogo KeyEvent -> Jogo


;; Vaca -> Vaca
;; muda a velocidade dx ou dy da vaca para impar caso forem par

;(define (vaca-inicial-com-velocidade-impar v) v)

(define (vaca-inicial-com-velocidade-impar v)
  (if (= (vaca-dx v) 0)
      (if (even? (vaca-dy v))
          (make-vaca (vaca-x v) (vaca-dx v) (vaca-y v) (add1 (vaca-dy v)))
          v)
      (if (even? (vaca-dx v))
          (make-vaca (vaca-x v) (add1 (vaca-dx v)) (vaca-y v) (vaca-dy v))
          v)))



;; Jogo -> Jogo
;; produz a próxima cena do jogo de acordo com o estado (cena) atual do jogo

;(define (proxima-cena j) j)


(define (proxima-cena j)
  
  (cond [(false? j) false]
        [(jogo? j) 
           (if (false? (jogo-vaca j))
               false
               (let ([possivel-proxima-vaca (proxima-vaca (jogo-vaca j))]
                     [possivel-proximo-chupacabra (proximo-chupacabra (jogo-chupacabra j))])
                 
                 (if (colisao-vaca-chupacabra? possivel-proxima-vaca possivel-proximo-chupacabra)
                   (make-jogo false possivel-proximo-chupacabra)
                   (make-jogo possivel-proxima-vaca possivel-proximo-chupacabra))))]))



;; Vaca ChupaCabra -> Boolean
;; Retorna true se há colisão entre vaca e chupacabra dados, false caso contrário

;(define (colisao-vaca-chupacabra? v o) false)


(define (colisao-vaca-chupacabra? v o) 
  (let* ([vaca-direita (+ (vaca-x v) METADE-VACA-VERTICAL) ]
         [vaca-esquerda (- (vaca-x v) METADE-VACA-VERTICAL) ]
         [chupacabra-direita (+ (chupacabra-x o) METADE-CHUPA-CABRA-VERTICAL)]
         [chupacabra-esquerda (- (chupacabra-x o) METADE-CHUPA-CABRA-VERTICAL)]
         [vaca-baixo (+ (vaca-y v) METADE-VACA-HORIZONTAL) ]
         [vaca-cima (- (vaca-y v) METADE-VACA-HORIZONTAL) ]
         [chupacabra-baixo (+ (chupacabra-y o) METADE-CHUPA-CABRA-HORIZONTAL)]
         [chupacabra-cima (- (chupacabra-y o) METADE-CHUPA-CABRA-HORIZONTAL)]
         [colisao-direita? (>= vaca-direita chupacabra-esquerda)]
         [colisao-esquerda? (<=  vaca-esquerda chupacabra-direita)]
         [colisao-baixo? (>=  vaca-baixo chupacabra-cima)]
         [colisao-cima? (<=  vaca-cima chupacabra-baixo)])
    (and colisao-direita? colisao-esquerda? colisao-baixo? colisao-cima?)))

;; Vaca -> Vaca
;; produz o próxima posição x da vaca de acordo com velocidade dx
;; e a próxima posição y da vaca de acordo com velocidade dy

;(define (proxima-vaca v) v)  ;stub


;usei template da vaca

(define (proxima-vaca v)
  (let ([proxima-posicao-x (+ (vaca-x v) (vaca-dx v))]
        [proxima-posicao-y (+ (vaca-y v) (vaca-dy v))]
        [direcao-oposta-x (- (vaca-dx v))]
        [direcao-oposta-y (- (vaca-dy v))])
    (cond [(> proxima-posicao-x POSICAO-VACA-LIMITE-DIREITO) 
           (make-vaca POSICAO-VACA-LIMITE-DIREITO direcao-oposta-x (vaca-y v) (vaca-dy v)) ]
          [(< proxima-posicao-x POSICAO-VACA-LIMITE-ESQUERDO) 
           (make-vaca POSICAO-VACA-LIMITE-ESQUERDO direcao-oposta-x (vaca-y v) (vaca-dy v))]
          [(> proxima-posicao-y POSICAO-VACA-LIMITE-BAIXO) 
           (make-vaca (vaca-x v) (vaca-dx v) POSICAO-VACA-LIMITE-BAIXO direcao-oposta-y) ]
          [(< proxima-posicao-y POSICAO-VACA-LIMITE-CIMA) 
           (make-vaca (vaca-x v) (vaca-dx v) POSICAO-VACA-LIMITE-CIMA direcao-oposta-y )]
          [else 
           (make-vaca proxima-posicao-x (vaca-dx v) proxima-posicao-y (vaca-dy v))])))


;; ChupaCabra -> ChupaCabra
;; produz o próxima posição x do chupacabra de acordo com velocidade dx
;; e a próxima posição y da chupacabra de acordo com velocidade dy

;(define (proximo-chupacabra cc) cc)



(define (proximo-chupacabra cc)
  (let ([proxima-posicao-x (+ (chupacabra-x cc) (chupacabra-dx cc))]
        [proxima-posicao-y (+ (chupacabra-y cc) (chupacabra-dy cc))]
        [direcao-oposta-x (- (chupacabra-dx cc))]
        [direcao-oposta-y (- (chupacabra-dy cc))])
    (cond [(> proxima-posicao-x POSICAO-CHUPA-CABRA-LIMITE-DIREITO) 
           (make-chupacabra POSICAO-CHUPA-CABRA-LIMITE-DIREITO direcao-oposta-x (chupacabra-y cc) (chupacabra-dy cc)) ]
          [(< proxima-posicao-x POSICAO-CHUPA-CABRA-LIMITE-ESQUERDO) 
           (make-chupacabra POSICAO-CHUPA-CABRA-LIMITE-ESQUERDO direcao-oposta-x (chupacabra-y cc) (chupacabra-dy cc))]
          [(> proxima-posicao-y POSICAO-CHUPA-CABRA-LIMITE-BAIXO) 
           (make-chupacabra (chupacabra-x cc) (chupacabra-dx cc) POSICAO-CHUPA-CABRA-LIMITE-BAIXO direcao-oposta-y) ]
          [(< proxima-posicao-y POSICAO-CHUPA-CABRA-LIMITE-CIMA) 
           (make-chupacabra (chupacabra-x cc) (chupacabra-dx cc) POSICAO-CHUPA-CABRA-LIMITE-CIMA direcao-oposta-y )]
          [else 
           (make-chupacabra proxima-posicao-x (chupacabra-dx cc) proxima-posicao-y (chupacabra-dy cc))])))

;; Vaca -> Image
;; Desenha cena com vaca e chupacabra

;(define (desenha-cena j) CENA)


(define (desenha-cena j)
  (cond [(false? j) 
         (place-image (text "Game Over" 100 "red") (/ COMPRIMENTO 2) (/ ALTURA 2) CENA)]
        [(jogo? j) 
         (place-image (escolher-imagem-chupacabra (jogo-chupacabra j))
                      (chupacabra-x (jogo-chupacabra j)) (chupacabra-y (jogo-chupacabra j)) 
                      (desenha-vaca (jogo-vaca j)))]))


;; ChupaCabra -> Image
;; desenha chupacabra indo ou voltando dependendo do dx

;(define (escolher-imagem-chupacabra cc) CHUPA-CABRA-INO)

(define (escolher-imagem-chupacabra cc)
  (if (>= (chupacabra-dx cc) 0)
      CHUPA-CABRA-INO
      CHUPA-CABRA-VORTANO))


;; Vaca -> Image
;; renderiza a vaca no cercado (quadrado)

;(define (desenha-vaca estado) CENA)   ;stub


(define (desenha-vaca v)
  (cond [(false? v) CENA]
        [else (place-image (escolher-imagem v) (vaca-x v) (vaca-y v) CENA)]))



;; Vaca -> Image
;; quando velocidade dx é maior ou igual a 0 escolhe VACA-INO senão VACA-VORTANO

;(define (escolher-imagem v) VACA-INO)


(define (escolher-imagem v)
  (let ([posicao-x-par? (even? (floor (vaca-x v)))]
        [posicao-y-par? (even? (floor (vaca-y v)))])
    (cond 
      [(< (vaca-dx v) 0)
       (if posicao-x-par?
           VACA-VORTANO+
           VACA-VORTANO-)]
      [(> (vaca-dx v) 0) 
       (if posicao-x-par?
           VACA-INO+
           VACA-INO-)]
      [else 
       (if posicao-y-par?
           VACA-INO+
           VACA-INO-)])))


;; Jogo KeyEvent -> Jogo
;; quando teclar "a" produz vaca em direção x negativa, 
;; quando teclar "d" produz vaca em direção x positiva,
;; quando teclar "w" produz vaca em direção y negativa (cima),
;; quando teclar "s" produz vaca em direção y positiva (baixo)

;(define (handle-key j ke) j)


(define (trata-tecla j ke)
  (cond [(key=? ke "a") (make-jogo (trata-a (jogo-vaca j)) (jogo-chupacabra j))  ]
        [(key=? ke "d") (make-jogo (trata-d (jogo-vaca j)) (jogo-chupacabra j)) ]
        [(key=? ke "w") (make-jogo (trata-w (jogo-vaca j)) (jogo-chupacabra j))]
        [(key=? ke "s") (make-jogo (trata-s (jogo-vaca j)) (jogo-chupacabra j)) ]
        [else j]))


;; Vaca -> Vaca
;; Retorna uma vaca com velocidade da vaca dx invertida caso dx>0
;; ou com velocidade dx = - abs(dy) caso contrario, deixando dy = 0

;(define (trata-a v) v) ;stub


(define (trata-a v)
  (if (= (vaca-dx v) 0)
      (make-vaca (vaca-x v) (- (abs (vaca-dy v))) (vaca-y v) 0)
      (make-vaca (vaca-x v) (- (abs (vaca-dx v))) (vaca-y v) 0)))


;; Vaca -> Vaca
;; Retorna uma vaca com velocidade da vaca dx invertida caso dx<0
;; ou com velocidade dx = abs(dy) caso contrario, deixando dy = 0

;(define (trata-d v) v) (stub)


(define (trata-d v)
  (if (= (vaca-dx v) 0)
      (make-vaca (vaca-x v) (abs (vaca-dy v)) (vaca-y v) 0)
      (make-vaca (vaca-x v) (abs (vaca-dx v)) (vaca-y v) 0)))


;; Vaca -> Vaca
;; Retorna uma vaca com velocidade da vaca dy invertida caso dy>0
;; ou com velocidade dy = - abs(dx) caso contrario, deixando dx = 0

;(define (trata-w v) v)  ;stub

(define (trata-w v)
  (if (= (vaca-dy v) 0)
      (make-vaca (vaca-x v) 0 (vaca-y v) (- (abs (vaca-dx v))) )
      (make-vaca (vaca-x v) 0 (vaca-y v) (- (abs (vaca-dy v))) ) ))


;; Vaca -> Vaca
;; Retorna uma vaca com velocidade da vaca dy invertida caso dy<0
;; ou com velocidade dy = abs(dx) caso contrario, deixando dx = 0

;(define (trata-s v) v) stub


(define (trata-s v)
  (if (= (vaca-dy v) 0)
      (make-vaca (vaca-x v) 0 (vaca-y v) (abs (vaca-dx v))) 
      (make-vaca (vaca-x v) 0 (vaca-y v) (abs (vaca-dy v))) ) )


