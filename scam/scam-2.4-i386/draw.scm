(define port)
(define baseName "template")
(define factor 1)
(define lineWidth 0.03)

;;; define directions for turtle graphic style drawing functions

(define up 'up)
(define down 'down)
(define left 'left)
(define right 'right)
(define north up)
(define south down)
(define west left)
(define east right)

;;; define variables so user don't have to quote common symbols 

;(define open 'open) open is already defined
(define closed 'closed)
(define arrow 'arrow)
(define unit 'unit)

(define black 'black)
(define darkgray 'darkgray)
(define gray 'gray)
(define lightgray 'lightgray)
(define white 'white)

(define red 'red)
(define green 'green)
(define blue 'blue)
(define cyan 'cyan)
(define magenta 'magenta)
(define yellow 'yellow)

(define solid 'solid)


(define latexPackages (list "{pstricks}" "{auto-pst-pdf}" "{calc}"))

(define pst-unit "1cm")

(define locations nil)

(define (openImage name)
    (set! baseName name)
    (set! port (open (string+ baseName ".pic") 'write))
    (setPort port)
    (println "\\begin{pspicture}(0,0)")
    (psset 'unit pst-unit)
    (setLineWidth lineWidth)
    (psset 'arrowsize "3pt 4")
    )

(define (closeImage)
    (println "\\end{pspicture}")
    (close port)
    (setPort 'stdout);
    )

(define (convertImage extension)
    (define p latexPackages)
    (define port (open (string+ baseName ".tex") 'write))
    (setPort port)
    (println "\\documentclass{article}")
    (println "\\usepackage[landscape,margin=0in]{geometry}")
    (while (valid? p)
        (println "\\usepackage" (car p))
        (set! p (cdr p))
        )
    (println)
    (println "\\begin{document}")
    (println "\\thispagestyle{empty}")
    (println "\\input{" baseName ".pic}")
    (println "\\end{document}")
    (close port)
    (setPort 'stdout)
    ;(println "creating " baseName ".png...");
    (system (string+ "pdflatex -shell-escape " baseName ".tex | grep \"l\\.[0-9]\""))
    (if (not (equal? extension ".pdf"))
        (system
            (string+ "convert -scale 30% -density 300 -trim +repage "
            baseName "-pics.pdf " baseName "." extension)
            )
        )
    (println "image " baseName " rendered")
    )

(define (addLatexPackage p)
    (if (not (member? p latexPackages))
        (set! latexPackages (append latexPackages (list p)))
        )
    )

(define (saveFunction f)
    (define fp (open (string+ (string (get 'name f)) "-saved.scm") 'write))
    (define p (setPort fp))
    (println (cons 'define (cons (cons (get 'name f) (get 'parameters f))
        (cdr (get 'code f)))))
    (close fp)
    (setPort p)
    )

(define (readFunction # name)
    (define fp (open (string+ name "-saved.scm") 'read))
    (define p (setPort fp))
    (define f (readExpr))
    (eval f #)
    (close fp)
    (setPort p)
    )
    
(define (pscommand @)
    (apply println @)
    )

(define (psset attribute value)
    (println "\\psset{" attribute "=" value "}")
    )

(define (zeroize x)
    (if (and (< x 0.00000001) (> x -0.00000001))
        0
        x
        )
    )

(define (psframe x y width height)
    (define gx (zeroize x))
    (define gy (zeroize y))
    (define gw (zeroize (+ x width)))
    (define gh (zeroize (+ y height)))
    (println "\\psframe(" gx "," gy ")(" gw "," gh ")")
    )

(define (pspolygon points)
    (println "\\pspolygon" points)
    )

(define (rput j x y str)
    (define gx (zeroize x))
    (define gy (zeroize y))
    (if (eq? textColor 'black)
        (println "\\rput[" j "](" gx "," gy "){\\Large " str "}")
        (println "\\rput[" j "](" gx "," gy "){\\color{" textColor "}\\Large " str "}")
        )
    )

(define (psline x1 y1 x2 y2)
    (define gx1 (zeroize x1))
    (define gy1 (zeroize y1))
    (define gx2 (zeroize x2))
    (define gy2 (zeroize y2))

    (println "\\psline(" gx1 "," gy1 ")(" gx2 "," gy2 ")")
    )

(define (pscircle x y r)
    (define gx (zeroize x))
    (define gy (zeroize y))
    (println "\\pscircle(" gx "," gy "){" r "}")
    )

(define (psarc x y r a1 a2)
    (define gx (zeroize x))
    (define gy (zeroize y))
    (println "\\psarc(" gx "," gy "){" r "}{" a1 "}{" a2 "}")
    )

(define (psellipse x y r1 r2)
    (define gx (zeroize x))
    (define gy (zeroize y))
    (println "\\psellipse(" gx "," gy ")(" r1 "," r2 ")")
    )

(define (pscurve x1 y1 x2 y2 x3 y3)
    (define gx1 (zeroize x1))
    (define gy1 (zeroize y1))
    (define gx2 (zeroize x2))
    (define gy2 (zeroize y2))
    (define gx3 (zeroize x3))
    (define gy3 (zeroize y3))
    (println "\\pscurve(" gx1 "," gy1 ")(" gx2 "," gy2 ")(" gx3 "," gy3 ")")
    )

(define (psbezier x1 y1 x2 y2 x3 y3 x4 y4)
    (define gx1 (zeroize x1))
    (define gy1 (zeroize y1))
    (define gx2 (zeroize x2))
    (define gy2 (zeroize y2))
    (define gx3 (zeroize x3))
    (define gy3 (zeroize y3))
    (define gx4 (zeroize x4))
    (define gy4 (zeroize y4))
    (println "\\psbezier"
            "(" gx1 "," gy1 ")(" gx2 "," gy2 ")(" gx3 "," gy3 ")(" gx4 "," gy4 ")")
    )

;;;;;;;;;;;;; high level functions ;;;;;;;;;;;;;;;;;

(define currentX 0)
(define currentY 0)
(define frameArc 0.2)
(define fillStyle 'none)
(define fillColor 'black)
(define lineColor 'black)
(define lineStyle solid)
(define textColor 'black)
(define hatchColor 'black)
(define arrowStyle "->")
(define justification 'c)

;;;;;; possible text justification values
;
; tl, t, tr: top left, center, and right
; l,  c, r : middle left, center, and right
; Bl, B, Br: baseline left, center, and right
; bl, b, br: bottom left, center, and right

(define (setJustification ju)
    (define temp justification)
    (set! justification ju)
    temp
    )

(define (getJustification)
    justification
    )

;;;;;; possible colors
;
; black darkgray gray lightgray white
; red green blue cyan magenta yellow
;

(define (setTextColor co)
    (define temp textColor)
    (set! textColor co)
    temp
    )

(define (getTextColor)
    textColor
    )

(define (setLineColor co)
    (define temp lineColor)
    (set! lineColor co)
    (psset 'linecolor co)
    temp
    )

(define (getLineColor)
    lineColor
    )

(define (setFillColor co)
    (define temp fillColor)
    (set! fillColor co)
    (psset 'fillcolor co)
    temp
    )

(define (getFillColor)
    fillColor
    )

(define (setHatchColor co)
    (define temp hatchColor)
    (set! hatchColor co)
    (psset 'hatchcolor co)
    temp
    )

(define (getHatchColor)
    hatchColor
    )

;;;;;; possible arrowhead values
;
; none: -
; right arrowheads: > >> | *| ] ) o * oo ** c cc C
; left arrowheads:  < << | |* [ ( o * oo ** c cc C
;
; left and right arrowheads do need to be the same, as in |->
;

(define (setArrowStyle ju)
    (define temp arrowStyle)
    (set! arrowStyle ju)
    temp
    )

(define (getArrowStyle)
    arrowStyle
    )

;;;;;; possible line styles
;
; none solid dashed dotted
;

(define (setLineStyle ls)
    (define temp lineStyle)
    (set! lineStyle ls)
    (psset 'linestyle ls)
    temp
    )
   
(define (getLineStyle)
    lineStyle
    )

;;;;;; possible fill styles
;
; none solid vlines vlines* hlines hlines* crosshatch crosshatch*
;

(define (setFillStyle st)
    (define temp fillStyle)
    (set! fillStyle st)
    (psset 'fillstyle st)
    temp
    )

(define (getFillStyle)
    fillStyle
    )

(define (setFrameArc fa)
    (define temp frameArc)
    (set! frameArc fa)
    temp
    )

(define (getFrameArc)
    frameArc
    )

(define (setLineWidth fa)
    (define temp lineWidth)
    (set! lineWidth fa)
    (psset 'linewidth fa)
    temp
    )

(define (setLocation @)
    (define temp (list currentX currentY))
    (cond
        ((list? (car @))
            (set! currentX (car (car @)))
            (set! currentY (cadr (car @)))
            )
        (else
            (set! currentX (car @))
            (set! currentY (cadr @))
            )
        )
    temp
    )

(define (getLocation)
    (list currentX currentY)
    )

(define (getLineWidth)
    lineWidth
    )

(define moveTo setLocation)

(define (shift dx dy)
    (moveTo (+ currentX dx) (+ currentY dy))
    )

(define (getMark m)
    (define spot (assoc m locations))
    (if (eq? spot #f)
        (throw 'markNotFoundException
            (string+ "mark " (string m) " does not exist.")))
    (cdr spot)
    )
    
(define (moveToMark name)
    (define spot (getMark name))
    (moveTo (car spot) (cadr spot))
    )

(define (mark name)
    (set! locations (cons (list name currentX currentY) locations))
    )

(define (shiftsToAbsolutes pts)
    (define x currentX)
    (define y currentY)
    (define abspts (list (list x y)))
    (while (valid? pts)
        (set! x (+ x (car (car pts))))
        (set! y (+ y (cadr (car pts))))
        (set! abspts (cons (list x y) abspts))
        (set! pts (cdr pts))
        )
    abspts
    )

(define (pointsToPSPoints pts)
    (define pspts "")
    (while (valid? pts)
        (set! pspts
            (string+ "(" (car (car pts)) "," (cadr (car pts)) ")" pspts))
        (set! pts (cdr pts))
        )
    pspts
    )


(define (square size)
    (psframe currentX currentY size size)
    )

(define (filledSquare size color style)
    (define cf (if (eq? style solid) setFillColor setHatchColor))
    (define c (cf color))
    (define s (setFillStyle style))
    (square size)
    (setFillStyle s)
    (cf c)
    )

(define (roundedSquare size)
    (psset 'framearc frameArc)
    (psframe currentX currentY size size)
    (psset 'framearc 0)
    )

(define (filledRoundedSquare size color style)
    (define cf (if (eq? style solid) setFillColor setHatchColor))
    (define c (cf color))
    (define s (setFillStyle style))
    (roundedSquare size)
    (setFillStyle s)
    (cf c)
    )

(define (rectangle width height)
    (psframe currentX currentY width height)
    )

(define (filledRectangle width height color style)
    (define cf (if (eq? style solid) setFillColor setHatchColor))
    (define c (cf color))
    (define s (setFillStyle style))
    (rectangle width height)
    (setFillStyle s)
    (cf c)
    )

(define (roundedRectangle width height)
    (psset 'framearc frameArc)
    (psframe currentX currentY width height)
    (psset 'framearc 0)
    )

(define (filledRoundedRectangle width height color style)
    (define cf (if (eq? style solid) setFillColor setHatchColor))
    (define c (cf color))
    (define s (setFillStyle style))
    (roundedRectangle width height)
    (setFillStyle s)
    (cf c)
    )
    
(define (polygon points)
    (pspolygon (pointsToPSPoints points))
    )

(define (filledPolygon color style points)
    (define cf (if (eq? style solid) setFillColor setHatchColor))
    (define c (cf color))
    (define s (setFillStyle style))
    (polygon points)
    (setFillStyle s)
    (cf c)
    )

(define (polygonShifts points)
    (pspolygon (pointsToPSPoints (shiftsToAbsolutes points)))
    )

(define (filledPolygonShifts color style points)
    (define cf (if (eq? style solid) setFillColor setHatchColor))
    (define c (cf color))
    (define s (setFillStyle style))
    (polygonShifts points)
    (setFillStyle s)
    (cf c)
    )


(define (circle radius)
    (pscircle currentX currentY radius)
    )

(define (filledCircle radius color style)
    (define cf (if (eq? style solid) setFillColor setHatchColor))
    (define c (cf color))
    (define s (setFillStyle style))
    (circle radius)
    (setFillStyle s)
    (cf c)
    )

(define (ellipse horizontalRadius verticalRadius)
    (psellipse currentX currentY horizontalRadius verticalRadius)
    )

(define (filledEllipse horizontalRadius verticalRadius color style)
    (define cf (if (eq? style solid) setFillColor setHatchColor))
    (define c (cf color))
    (define s (setFillStyle style))
    (ellipse horizontalRadius verticalRadius)
    (setFillStyle s)
    (cf c)
    )

(define (label str)
    (rput justification currentX currentY str)
    )

(define (lineTo x y)
    (psline currentX currentY x y)
    (set! currentX x)
    (set! currentY y)
    )

(define (lineShift dx dy)
    (lineTo (+ currentX dx) (+ currentY dy))
    )

(define (lineToMark name)
    (define spot (getMark name))
    (lineTo (car spot) (cadr spot))
    )

(define (lineToLocation spot)
    (lineTo (car spot) (cadr spot))
    )

(define (arrowTo x y)
    (psset 'arrows arrowStyle)
    (psline currentX currentY x y)
    (psset 'arrows "-")
    (set! currentX x)
    (set! currentY y)
    )

(define (arrowShift dx dy)
    (arrowTo (+ currentX dx) (+ currentY dy))
    )

(define (arrowToMark x y)
    (define spot (getMark name))
    (arrowTo (car spot) (cadr spot))
    )

(define (arrowToLocation spot)
    (arrowTo (car spot) (cadr spot))
    )

(define (hbarrowTo x y wiggle)
    (define dx (- x currentX))
    (psset 'arrows arrowStyle)
    (psbezier
        currentX currentY 
        (+ currentX (* wiggle dx)) currentY
        (- x (* wiggle dx)) y
        x y
        )
    (psset 'arrows "-")
    (set! currentX x)
    (set! currentY y)
    )

(define (hbarrowToMark name wiggle)
    (define spot (getMark name))
    (hbarrowTo (car spot) (cadr spot) wiggle)
    )

(define (hbarrowToLocation spot wiggle)
    (hbarrowTo (car spot) (cadr spot) wiggle)
    )

(define (hbarrowShift dx dy wiggle)
    (hbarrowTo (+ currentX dx) (+ currentY dy) wiggle)
    )

(define (vbarrowTo x y wiggle)
    (define dy (- y currentY))
    (psset 'arrows arrowStyle)
    (psbezier
        currentX currentY 
        currentX (+ currentY (* wiggle dy))
        x (- y (* wiggle dy))
        x y
        )
    (psset 'arrows "-")
    (set! currentX x)
    (set! currentY y)
    )

(define (vbarrowToMark name wiggle)
    (define spot (getMark name))
    (vbarrowTo (car spot) (cadr spot) wiggle)
    )

(define (vbarrowToLocation spot wiggle)
    (vbarrowTo (car spot) (cadr spot) wiggle)
    )

(define (vbarrowShift dx dy wiggle)
    (vbarrowTo (+ currentX dx) (+ currentY dy) wiggle)
    )

(define (arc radius startingAngle endingAngle)
    (psarc currentX currentY startingAngle endingAngle)
    )

;;; turtle style drawing functions

(define lineLabelOffset 0.5)
(define pointLabelOffset 0.5)
(define pointSize 4)

(define (line direction len @)
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
            (liner 0 len))
        ((eq? direction down)
            (liner 0 (- len)))
        ((eq? direction left)
            (liner (- len) 0))
        ((eq? direction right)
            (liner len 0))
        (else
            (throw 'unknownParameter
                (string+
                    (string direction) " was given as a line direction"
                    )
                )
            )
        )
    (set! finishx currentX)
    (set! finishy currentY)
    (moveTo (* 0.5 (+ startx finishx)) (* 0.5 (+ starty finishy)))
    (addLabels lineLabelOffset @)
    (moveTo finishx finishy)
    )

(define (point size color style @)
    (define lc (setLineColor (if (eq? style open) color black)))
    (cond
        ((eq? style open)
            (filledCircle (string+ (string size) "pt") white solid))
        ((eq? style closed)
            (filledCircle (string+ (string size) "pt") color solid))
        (else
            (throw 'unknownParameter
                (string+ "point style " (string style)
                    " is not understood"))
            )
        )
    (setLineColor lc)
    (addLabels pointLabelOffset @)
    )
    
;;; functions for adding labels to features

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

(define (pointlist @)
    (define pts nil)
    (while (valid? @)
        (if (null? (cdr @))
            (throw 'drawException "pointlist was given an odd number of values")
            )
        (set! pts (append pts (list (list (car @) (cadr @)))))
        (set! @ (cddr @))
        )
    pts
    )

(if #f
    (begin
        (openImage "a")
        (moveTo 1 1)
        (line up 2 west "west" arrow)
        (line right 3 north "north")
        (line down 2 east "east")
        (line left 3 south "south")
        (point 6 red closed)
        (closeImage)
        (println "converting the image...")
        (convertImage "png")
        (println "done")
        )
    )

