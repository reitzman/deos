(include "draw.scm")

(addLatexPackage "{pst-circ}")

(set! pst-unit "1.5cm")

(define none nil)
(define plusSign "{\\bf +}")
(define minusSign "{\\bf --}")

(define batteryID "\\Ucc")
(define currentSourceID "\\Ucc")
(define resistorID "\\resistor")

(define pointLabelOffset 0.5)
(define resistorLabelOffset 0.5)
(define batteryLabelOffset 0.75)
(define wireLabelOffset 0.25)
(define currentLabelOffset 0.75)

(define up 'up)
(define down 'down)
(define left 'left)
(define right 'right)
(define north up)
(define south down)
(define west left)
(define east right)

;(define open 'open) open is already defined
(define closed 'closed)
(define arrow 'arrow)
(define dependent 'dependent)
(define rpolarity 'rpolarity)
(define reverse-polarity rpolarity)

(define short 'short)
(define none nil)

(define in 'in)
(define out 'out)
(define nudgefactor 0.1)
(define in1 'in1)
(define in2 'in2)

(define ohms "$\\Omega$")
(define ohm ohms)
(define kiloohms "k$\\Omega$")
(define kiloohm kiloohms)
(define megaohms "M$\\Omega$")
(define megaohm megaohms)
(define milliohms "m$\\Omega$")
(define milliohm milliohms)
(define microohms "$\\mu\\Omega$")
(define microohm microohms)

(define volts "V")
(define volt volts)
(define kilovolts "kV")
(define kilovolt kilovolts)
(define megavolts "MV")
(define megavolt megavolts)
(define millivolts "mV")
(define millivolt millivolts)
(define microvolts "$\\mu$V")
(define microvolt microvolts)

(define amps "A")
(define amp amps)
(define kiloamps "kA")
(define kiloamp kiloamps)
(define megaamps "MA")
(define megaamp megaamps)
(define milliamps "mA")
(define milliamp milliamps)
(define microamps "$\\mu$A")
(define microamp microamps)

(define plus 'plus)
(define minus 'minus)
(define positive plus)
(define negative minus)

(define unit 'unit)

(define not-gate-size 0.4)

(define (flipDirection d)
    (cond
        ((eq? d left) right)
        ((eq? d right) left)
        ((eq? d up) down)
        ((eq? d down) up)
        ((eq? d east) west)
        ((eq? d west) east)
        ((eq? d north) south)
        ((eq? d south) north)
        (else d)
        )
    )

(define mainLabelShifts
    (list
        (list right north)
        (list left south)
        (list down east)
        (list up west)
        )
    )

(define labelShift 0.6)

(define (vertical? d) (member? d (list up down)))

(define (flipDirection d)
    (cond
        ((eq? d right) left)
        ((eq? d left) right)
        ((eq? d east) west)
        ((eq? d west) east)
        ((eq? d up) down)
        ((eq? d down) up)
        ((eq? d north) south)
        ((eq? d south) north)
        (else d)
        )
    )

(define dipoleShifts
    (list
        '(up 0 2)
        '(down 0 -2)
        '(left -2 0)
        '(right 2 0)
        )
    )

(define (unitsToLabel value units)
    (if (valid? units)
        (string+ (string value) " " units)
        (string value)
        )
    )

(define (psdipole type args direction flip)
    (define shifty (assoc direction dipoleShifts))
    (psnode currentX currentY "psdipoleA")
    (apply shift (cdr shifty))
    (psnode currentX currentY "psdipoleB")
    (if flip
        (println type
            "[" args "]"
            "(psdipoleB)(psdipoleA){}"
            )
        (println type
            "[" args "]"
            "(psdipoleA)(psdipoleB){}"
            )
        )

    )
(define (psnode x y z)
    (println "\\pnode(" (zeroize x) "," (zeroize y) "){" z "}")
    )

(define (polarity sign direction shifts)
    (mark 'a$$polarity$$a)
    (define shifty (assoc direction shifts))
    (apply shift (cdr shifty))
    (label (if (eq? sign plus) plusSign minusSign))
    (moveToMark 'a$$polarity$$a)
    )

(define (resistorPolarityAdjust direction which)
    (currentPolarityAdjust direction which)
    )

(define (resistor direction value units @)
    (define startx currentX)
    (define starty currentY)
    (define finishx 0)
    (define finishy 0)
    (if (not (member? short @)) (wire direction 1))
    (apply shift (resistorPolarityAdjust direction 'start))
    (cond ((or (and (member? polarity @) (member? reverse @))
               (member? rpolarity @))
            (addLabel resistorLabelOffset (flipDirection direction) minusSign))
          ((member? polarity @)
            (addLabel resistorLabelOffset (flipDirection direction) plusSign)))
    (apply shift (resistorPolarityAdjust direction 'end))
    (psdipole resistorID "dipolestyle=zigzag" direction (member? reverse @))
    (apply shift (resistorPolarityAdjust direction 'end))
    (cond ((or (and (member? polarity @) (member? reverse @))
               (member? rpolarity @))
            (addLabel resistorLabelOffset (flipDirection direction) plusSign))
          ((member? polarity @)
            (addLabel resistorLabelOffset (flipDirection direction) minusSign)))
    (apply shift (resistorPolarityAdjust direction 'start))
    (if (not (member? short @)) (wire direction 1))
    (set! finishx currentX)
    (set! finishy currentY)
    (moveTo (* 0.5 (+ startx finishx)) (* 0.5 (+ starty finishy)))
    (addMainLabel resistorLabelOffset direction value units)
    (addLabels resistorLabelOffset @)
    (moveTo finishx finishy)
    )

(define (batteryPolarityAdjust sign direction which)
    (cond
        ((and (eq? direction up) (eq? which 'start) (eq? sign 'plus))
            '(0 0.8))
        ((and (eq? direction up) (eq? sign 'plus))
            '(0 -0.8))
        ((and (eq? direction up) (eq? which 'start))
            '(0 0.7))
        ((eq? direction up)
            '(0 -0.7))
        ((and (eq? direction down) (eq? which 'start) (eq? sign 'plus))
            '(0 -0.8))
        ((and (eq? direction down) (eq? sign 'plus))
            '(0 0.8))
        ((and (eq? direction down) (eq? which 'start))
            '(0 -0.725))
        ((eq? direction down)
            '(0 0.725))
        ((and (eq? direction left) (eq? which 'start) (eq? sign 'plus))
            '(-0.8 0))
        ((and (eq? direction left) (eq? sign 'plus))
            '(0.8 0))
        ((and (eq? direction left) (eq? which 'start))
            '(-0.75 0))
        ((eq? direction left)
            '(0.75 0))
        ((and (eq? direction right) (eq? which 'start) (eq? sign 'plus))
            '(0.8 0))
        ((and (eq? direction right) (eq? sign 'plus))
            '(-0.8 0))
        ((and (eq? direction right) (eq? which 'start))
            '(0.75 0))
        ((eq? direction right)
            '(-0.75 0))
        (else '(0 0))
        )
    )

(define (battery direction value units @)
    (define startx currentX)
    (define starty currentY)
    (define finishx 0)
    (define finishy 0)
    (if (not (member? short @)) (wire direction 1))
    (cond ((or (and (member? polarity @) (member? reverse @))
               (member? rpolarity @))
            (apply shift (batteryPolarityAdjust 'plus direction 'start))
            (label plusSign)
            (apply shift (batteryPolarityAdjust 'plus direction 'end)))
          ((member? polarity @)
            (apply shift (batteryPolarityAdjust 'minus direction 'start))
            (label minusSign)
            (apply shift (batteryPolarityAdjust 'minus direction 'end)))
        )
    (cond
        ((member? dependent @)
            (psdipole batteryID "dipolestyle=diamond" direction  (member? reverse @)))
        (else
            (psdipole batteryID "dipolestyle=normal" direction  (member? reverse @)))
        )
    (cond ((or (and (member? polarity @) (member? reverse @))
               (member? rpolarity @))
            (apply shift (batteryPolarityAdjust 'minus direction 'end))
            (label minusSign)
            (apply shift (batteryPolarityAdjust 'minus direction 'start)))
          ((member? polarity @)
            (apply shift (batteryPolarityAdjust 'plus direction 'end))
            (label plusSign)
            (apply shift (batteryPolarityAdjust 'plus direction 'start)))
        )
    (if (not (member? short @)) (wire direction 1))
    (set! finishx currentX)
    (set! finishy currentY)
    (moveTo (* 0.5 (+ startx finishx)) (* 0.5 (+ starty finishy)))
    (addMainLabel batteryLabelOffset direction value units)
    (addLabels batteryLabelOffset @)
    (moveTo finishx finishy)
    )

(define (currentPolarityAdjust direction which)
    (cond
        ((and (eq? direction up) (eq? which 'start)) '(0 0.4))
        ((eq? direction up) '(0 -0.4))
        ((and (eq? direction down) (eq? which 'start)) '(0 -0.4))
        ((eq? direction down) '(0 0.4))
        ((and (eq? direction right) (eq? which 'start)) '(0.25 0))
        ((eq? direction right) '(-0.25 0))
        ((and (eq? direction left) (eq? which 'start)) '(-0.25 0))
        ((eq? direction left) '(0.25 0))
        (else '(0 0))
        )
    )

(define (current-source direction value units @)
    (define startx currentX)
    (define starty currentY)
    (define finishx 0)
    (define finishy 0)
    (if (not (member? short @)) (wire direction 1))
    (apply shift (currentPolarityAdjust direction 'start))
    (cond ((and (member? polarity @) (member? reverse @))
            (addLabel currentLabelOffset (flipDirection direction) plusSign))
          ((and (member? rpolarity @) (member? reverse @))
            (addLabel currentLabelOffset (flipDirection direction) minusSign))
          ((member? polarity @)
            (addLabel currentLabelOffset (flipDirection direction) minusSign))
          ((member? rpolarity @)
            (addLabel currentLabelOffset (flipDirection direction) plusSign))
          )
    (apply shift (currentPolarityAdjust direction 'end))
    (if (member? 'dependent @)
        (psdipole currentSourceID "dipolestyle=diamond,labelInside=1" direction (member? reverse @))
        (psdipole currentSourceID "labelInside=1" direction (member? reverse @))
        )
    (apply shift (currentPolarityAdjust direction 'end))
    (cond ((and (member? polarity @) (member? reverse @))
            (addLabel currentLabelOffset (flipDirection direction) minusSign))
          ((and (member? rpolarity @) (member? reverse @))
            (addLabel currentLabelOffset (flipDirection direction) plusSign))
          ((member? polarity @)
            (addLabel currentLabelOffset (flipDirection direction) plusSign))
          ((member? rpolarity @)
            (addLabel currentLabelOffset (flipDirection direction) minusSign))
          )
    (apply shift (currentPolarityAdjust direction 'start))
    (if (not (member? short @)) (wire direction 1))
    (set! finishx currentX)
    (set! finishy currentY)
    (moveTo (* 0.5 (+ startx finishx)) (* 0.5 (+ starty finishy)))
    (addMainLabel currentLabelOffset direction value units)
    (addLabels currentLabelOffset @)
    (moveTo finishx finishy)
    )

(define (wire direction len @)
    (define startx currentX)
    (define starty currentY)
    (define finishx 0)
    (define finishy 0)
    (define liner 
        (cond
            ((and (member? arrow @) (member? reverse @))
                (lambda (x y)
                    (define as (setArrowStyle "<-"))
                    (arrowShift x y)
                    (setArrowStyle as)
                    )
                )
            ((member? arrow @)
                arrowShift
                )
            (else
                lineShift)
            )
        )
    (cond
        ((eq? direction up)
            (liner 0 len)
            )
        ((eq? direction down)
            (liner 0 (- len))
            )
        ((eq? direction left)
            (liner (- len) 0)
            )
        ((eq? direction right)
            (liner len 0)
            )
        (else
            (throw 'unknownParameter
                (string+
                    (string direction) " was given as a wire direction"
                    )
                )
            )
        )
    (set! finishx currentX)
    (set! finishy currentY)
    (moveTo (* 0.5 (+ startx finishx)) (* 0.5 (+ starty finishy)))
    (addLabels wireLabelOffset @)
    (moveTo finishx finishy)
    )

(define (node style @)
    (define startx currentX)
    (define starty currentY)
    (point 5 black style)
    (addLabels pointLabelOffset @)
    (moveTo startx starty)
    )
    
(define (not-gate-old in out @)
    (mark in)
    ;(point 3 red closed)
    (addLogicLabel 'in @)
    (shift 0 -1)
    (define gx (zeroize currentX))
    (define gy (zeroize currentY))
    (println "\\logicnot[invertoutput=true](" gx "," gy "){}")
    (shift 3.5 1)
    ;(point 3 blue closed)
    (mark out)
    (addLogicLabel 'out @)
    )

(define (not-gate in out @)
    (define gress (/ (- 2 (^ (/ not-gate-size 2.0) 0.5)) 2))
    (mark in)
    (inspect (getLocation))
    ;(point 3 red closed)
    (addLogicLabel 'in @)
    (lineShift gress 0)
    (lineShift 0 not-gate-size)
    (lineShift not-gate-size (- not-gate-size))
    (define p (getLocation))
    (lineShift gress 0)
    (lineShift (- gress) 0)
    (lineShift (- not-gate-size) (- not-gate-size))
    (lineShift 0 not-gate-size)
    (moveTo p)
    (shift 0.20 0)
    (point 3 white closed)
    (shift -0.20 0)
    (shift gress 0)
    (mark out)
    (addLogicLabel 'out @)
    )

(define (and-gate in1 in2 out @)
    (mark in1)
    ;(point 3 red closed)
    (addLogicLabel 'in1 @)
    (shift 0 -1.5)
    (shift 0 0.5)
    (mark in2)
    ;(point 3 green closed)
    (addLogicLabel 'in2 @)
    (shift 0 -0.5)
    (define gx (zeroize currentX))
    (define gy (zeroize currentY))
    (println "\\logicand[ninputs=2](" gx "," gy "){}")
    (shift 4.5 1.0)
    (mark out)
    ;(point 3 blue closed)
    (addLogicLabel 'out @)
    )

(define (nand-gate in1 in2 out @)
    (mark in1)
    ;(point 3 red closed)
    (addLogicLabel 'in1 @)
    (shift 0 -1.5)
    (shift 0 0.5)
    (mark in2)
    ;(point 3 green closed)
    (addLogicLabel 'in2 @)
    (shift 0 -0.5)
    (define gx (zeroize currentX))
    (define gy (zeroize currentY))
    (println "\\logicand[ninputs=2,invertoutput=true](" gx "," gy "){}")
    (shift 4.5 1.0)
    (mark out)
    ;(point 3 blue closed)
    (addLogicLabel 'out @)
    )

(define (nand-gate2 in1 in2 out @)
    (mark in1)
    ;(point 3 red closed)
    (addLogicLabel 'in1 @)
    (shift 0 -1.5)
    (shift 0 0.5)
    (mark in2)
    ;(point 3 green closed)
    (addLogicLabel 'in2 @)
    (shift 0 -0.5)
    (define gx (zeroize currentX))
    (define gy (zeroize currentY))
    (println "\\logicor[ninputs=2,invertinputa=true,invertinputb=true]("
        gx "," gy "){}")
    (shift 4.5 1.0)
    (mark out)
    ;(point 3 blue closed)
    (addLogicLabel 'out @)
    )

(define (or-gate in1 in2 out @)
    (mark in1)
    ;(point 3 red closed)
    (addLogicLabel 'in1 @)
    (shift 0 -1.5)
    (shift 0 0.5)
    (mark in2)
    ;(point 3 green closed)
    (addLogicLabel 'in2 @)
    (shift 0 -0.5)
    (define gx (zeroize currentX))
    (define gy (zeroize currentY))
    (println "\\logicor[ninputs=2](" gx "," gy "){}")
    (shift 4.5 1.0)
    (mark out)
    ;(point 3 blue closed)
    (addLogicLabel 'out @)
    )

(define (nor-gate in1 in2 out @)
    (mark in1)
    ;(point 3 red closed)
    (addLogicLabel 'in1 @)
    (shift 0 -1.5)
    (shift 0 0.5)
    (mark in2)
    ;(point 3 green closed)
    (addLogicLabel 'in2 @)
    (shift 0 -0.5)
    (define gx (zeroize currentX))
    (define gy (zeroize currentY))
    (println "\\logicor[ninputs=2,invertoutput=true](" gx "," gy "){}")
    (shift 4.5 1.0)
    (mark out)
    ;(point 3 blue closed)
    (addLogicLabel 'out @)
    )

(define (nor-gate2 in1 in2 out @)
    (mark in1)
    ;(point 3 red closed)
    (addLogicLabel 'in1 @)
    (shift 0 -1.5)
    (shift 0 0.5)
    (mark in2)
    ;(point 3 green closed)
    (addLogicLabel 'in2 @)
    (shift 0 -0.5)
    (define gx (zeroize currentX))
    (define gy (zeroize currentY))
    (println "\\logicand[ninputs=2,invertinputa=true,invertinputb=true](" gx "," gy "){}")
    (shift 4.5 1.0)
    (mark out)
    ;(point 3 blue closed)
    (addLogicLabel 'out @)
    )


(define (xor-gate in1 in2 out @)
    (mark in1)
    ;(point 3 red closed)
    (addLogicLabel 'in1 @)
    (shift 0 -1.5)
    (shift 0 0.5)
    (mark in2)
    ;(point 3 green closed)
    (addLogicLabel 'in2 @)
    (shift 0 -0.5)
    (define gx (zeroize currentX))
    (define gy (zeroize currentY))
    (println "\\logicxor[ninputs=2](" gx "," gy "){}")
    (shift 4.5 1.0)
    (mark out)
    ;(point 3 blue closed)
    (addLogicLabel 'out @)
    )

(define (nxor-gate in1 in2 out @)
    (mark in1)
    ;(point 3 red closed)
    (addLogicLabel 'in1 @)
    (shift 0 -1.5)
    (shift 0 0.5)
    (mark in2)
    ;(point 3 green closed)
    (addLogicLabel 'in2 @)
    (shift 0 -0.5)
    (define gx (zeroize currentX))
    (define gy (zeroize currentY))
    (println "\\logicxor[ninputs=2,invertoutput=true](" gx "," gy "){}")
    (shift 4.5 1.0)
    (mark out)
    ;(point 3 blue closed)
    (addLogicLabel 'out @)
    )

(define (connect m1 m2 @)
    (define s1 (getMark m1))
    (define s2 (getMark m2))
    ;check if on the same level
    (moveToMark m1)
    (if (= (cadr s1) (cadr s2))
        (lineToMark m2)
        (begin
            (define hway (/ (- (car s2) (car s1)) 2.0))
            (lineShift (+ hway (if (valid? @) (car @) 0)) 0) 
            (lineShift 0 (- (cadr s2) (cadr s1)))
            (lineShift (- hway (if (valid? @) (car @) 0)) 0) 
            )
        )
    )

(define (addMainLabel offset direction value units)
    (if (valid? value)
        (addLabel offset direction (unitsToLabel value units))
        )
    )

(define (addLabel offset direction text)
    (define where (cadr (assoc direction mainLabelShifts)))
    (addLabels offset (list where text))
    )

(define (addLabels offset args)
    (define oj (getJustification))
    (while (valid? args)
        (cond
            ((eq? (car args) north)
                (set! args (cdr args))
                (shift 0 offset)
                (setJustification 'B)
                (label (car args))
                (shift 0 (* -1 offset))
                )
            ((eq? (car args) south)
                (set! args (cdr args))
                (shift 0 (* -1 offset))
                (setJustification 't)
                (label (car args))
                (shift 0 offset)
                )
            ((eq? (car args) east)
                (set! args (cdr args))
                (shift offset 0)
                (setJustification 'l)
                (label (car args))
                (shift (* -1 offset) 0)
                )
            ((eq? (car args) west)
                (set! args (cdr args))
                (shift (* -1 offset) 0)
                (setJustification 'r)
                (label (car args))
                (shift offset 0)
                )
            )
        (set! args (cdr args))
        )
    (setJustification oj)
    )

(define (addLogicLabel type args)
    (while (valid? args)
        (cond
            ((eq? (car args) type)
                (addLabels wireLabelOffset (list (cadr args) (caddr args)))
                )
            )
        (set! args (cdddr args))
        )
    )

(if #f
    (begin
            (openImage "a")
            (psset unit "0.5cm")

            (mark 1)
            (not-gate 'X 'b in west "A")
            (moveToMark 1)
            (shift 0 -3)
            (not-gate 'X 'd in west "B")
            (shift 1 2)
            (and-gate 'e 'f 'X out east "C")
            (connect 'b 'e)
            (connect 'd 'f)
            
            (moveToMark 1)
            (shift 13 -1)
            (mark 2)
            (and-gate 'X 'X 'X in1 west "A" in2 west "B")
            (not-gate 'X 'X out east "C")

            (moveToMark 2)
            (shift 12 1)
            (mark 3)
            (not-gate 'X 'b in west "A")
            (moveToMark 3)
            (shift 0 -3)
            (not-gate 'X 'd in west "B")
            (shift 1 2)
            (and-gate 'e 'f 'X)
            (not-gate 'X 'X out east "C")
            (connect 'b 'e)
            (connect 'd 'f)
            
            (closeImage)
            (convertImage "png")
            (println "done")
        )
    )