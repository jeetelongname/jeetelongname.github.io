;;; example.el --- A quick example                   -*- lexical-binding: t; -*-

;; Copyright (C) 2022  Jeetaditya Chatterjee

;; Author: Jeetaditya Chatterjee <jeetelongname@gmail.com>
;; Keywords: tools
;;; Commentary:
;;; a simple function to insert a list element
;;; Code:

(defun insert-list-element ()
  "Quickly insert a list element."
  (interactive)
  (insert "<li>" (read-from-minibuffer "List element: ")))

(provide 'example)
;;; example ends here
