;;; jekyll.el --- Minor mode for working with Jekyll blogs

;; Copyright (C) 2014 Geoff Shannon

;; Author: Geoff Shannon
;; Created: 17 April 2014
;; Keywords: tools processes
;; Version: 20140417.000
;; X-Original-Version: 0.1.0
;; URL: https://github.com/RadicalZephyr/jekyll-mode

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;;; Some small helpers to deal with blogging with jekyll from emacs.
;;; The main goals are to make it trivial to compile the blog, and to
;;; make it easy to start writing new posts.

;;; Code:

(require 'calendar)

(defun jekyll-root ()
  (locate-dominating-file default-directory "_config.yml"))

(defmacro jekyll-in-root (body)
  "Execute BODY form with project root directory as
``default-directory''.  The form is not executed when no project
root directory can be found."
  `(let ((jekyll-root-dir (jekyll-root)))
     (when jekyll-root-dir
       (let ((default-directory jekyll-root-dir))
         ,body))))

(defun jekyll-start-new-post (title)
  "Prompt for the title of your new post.

Automatically sets the date and inserts some default
front-matter."
  (interactive "sEnter post title: \n")
  (jekyll-in-root
   (let* ((calendar-date-display-form '(year "-" month "-" day))
          (date (calendar-date-string (calendar-current-date)))
          (new-post-buffer
           (find-file-noselect
            (format "%s/%s-%s.md"
                    "_posts"
                    date
                    (replace-regexp-in-string " " "-"
                                              (downcase title))))))
     (with-current-buffer new-post-buffer
       (insert "---\n"
               "title: " title "\n"
               "layout: main\n"
               "comments: true\n"
               "---\n\n"))
     (switch-to-buffer new-post-buffer))))

(provide 'jekyll)

;;; jekyll.el ends here
