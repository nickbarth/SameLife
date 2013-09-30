(defconstant LIVE "XX ")
(defconstant DEAD "   ")
(defconstant EMPTY "")
(defconstant NEWLINE (string #\Newline))

(defclass cell ()
  ((state :accessor get-state
          :initarg :state)
  (neighbours :accessor get-neighbours
              :initform 0
              :initarg :neighbours)))

(defun make-cell (state neighbours)
  (make-instance (quote cell) :state state :neighbours neighbours))

(defmethod live ((self cell))
  (cond
    ((string-equal (eval (get-state self)) LIVE)
      (cond
        ((< (get-neighbours self) 2) (setf (get-state self) (quote DEAD)))
        ((or (= (get-neighbours self) 2) (= (get-neighbours self) 3)) (setf (get-state self) (quote LIVE)))
        ((> (get-neighbours self) 3) (setf (get-state self) (quote DEAD)))))
    ((string-equal (eval (get-state self)) DEAD)
      (cond
        ((= (get-neighbours self) 3) (setf (get-state self) (quote LIVE)))))))

(defclass board ()
  ((height :accessor height
           :initform 12
           :initarg :height)
  (width :accessor width
         :initform 38
         :initarg :height)
  (board :accessor board
         :initarg :board
         :initform (quote ((LIVE DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD)
                           (DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD LIVE DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD)
                           (DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD LIVE DEAD LIVE DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD)
                           (DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD LIVE LIVE DEAD DEAD DEAD DEAD DEAD DEAD LIVE LIVE DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD LIVE LIVE DEAD)
                           (DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD LIVE DEAD DEAD DEAD LIVE DEAD DEAD DEAD DEAD LIVE LIVE DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD LIVE LIVE DEAD)
                           (DEAD LIVE LIVE DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD LIVE DEAD DEAD DEAD DEAD DEAD LIVE DEAD DEAD DEAD LIVE LIVE DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD)
                           (DEAD LIVE LIVE DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD LIVE DEAD DEAD DEAD LIVE DEAD LIVE LIVE DEAD DEAD DEAD DEAD LIVE DEAD LIVE DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD)
                           (DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD LIVE DEAD DEAD DEAD DEAD DEAD LIVE DEAD DEAD DEAD DEAD DEAD DEAD DEAD LIVE DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD)
                           (DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD LIVE DEAD DEAD DEAD LIVE DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD)
                           (DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD LIVE LIVE DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD)
                           (DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD)
                           (DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD DEAD))))))

(defun make-board ()
  (make-instance (quote board)))

(defmethod is-same-position ((self board) y1 x1 y2 x2)
  (and (= y1 y2) (= x1 x2)))

(defmethod count-neighbours ((self board) y-pos x-pos)
  (let ((num 0)
        (start-y (if (> (- y-pos 1) 0) (- y-pos 1) 0))
        (start-x (if (> (- x-pos 1) 0) (- x-pos 1) 0))
        (end-y (if (< (+ y-pos 1) (height self)) (+ y-pos 1) (- (height self) 1)))
        (end-x (if (< (+ x-pos 1) (width self)) (+ x-pos 1) (- (width self) 1))))
    (loop for y from start-y to end-y do
      (loop for x from start-x to end-x do
        (cond ((and (eq (get-state (make-cell (nth x (nth y (board self))) 0)) (quote LIVE)) (not (is-same-position self y x y-pos x-pos)))
          (setq num (+ 1 num))))))
    num))

(defmethod play ((self board))
  (let ((output EMPTY) (updated-board (list)))
    (loop for y from 0 to (- (height self) 1) do
      (let ((row (quote ())))
        (loop for x from 0 to (- (width self) 1) do
          (let ((current-cell (make-cell (nth x (nth y (board self))) (count-neighbours self y x ))))
            (live current-cell)
            (setq output (concatenate (quote string) output (eval (get-state current-cell))))
            (setq row (append row (list (get-state current-cell))))))
        (setq updated-board (append updated-board (list row)))
        (setq output (concatenate (quote string) output NEWLINE))))
  (format t output)
  (setf (board self) updated-board)))

(defclass game ()
  ((board :accessor board
          :initarg :board)))

(defun make-game ()
  (make-instance (quote game) :board (make-board)))

(defmethod run ((self game))
  (sleep 0.2)
  (play (board self))
  (run self))

(run (make-game))
