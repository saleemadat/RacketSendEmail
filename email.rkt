#lang racket

(require net/dns)
(require net/head)
(require net/smtp)
(require openssl/mzssl)




(define sendmessage (λ (x)
(smtp-send-message
(dns-get-address (dns-find-nameserver) "smtp.live.com")
"kl@hotmail.co.uk" ;;sender
`(,x) ;;reciever
(standard-message-header
 "Sender Name <account@hotmail.co.uk>" ;;account
 `(,x)
 '("kl@yahoo.co.uk") ;;cc
 '() ;bcc
 "hello fds saleem") ;;subject
'("good afternoon") ;message
#:port-no 587
#:auth-user "account@hotmail.co.uk" ;;account
#:auth-passwd "password" ;;password
#:tcp-connect tcp-connect
#:tls-encode ports->ssl-ports)))


(require web-server/servlet
         web-server/servlet-env)

(define (myresponse request)
  (define bindings (request-bindings request)) 

  (cond
    ((exists-binding? 'email bindings)
    (define reciever (extract-binding/single 'email bindings))
    
    (define surname (extract-binding/single 'surname bindings))
    (sendmessage reciever)
    
    
    (response/xexpr
     `(html (head (title "Simple Page"))
           (body
            (h1 "Simple Page")
            (div ((class "name"))
                 (p "Hi " ,reciever ,surname)
                 
            )))))
(else
 (response/xexpr
  `(html (head (title "Simple page"))
         (body
          (h1 "A simple dynamic page")
          (form
           (input ((name "email")))
           (input ((name "Surname")))
           (input ((type "Submit"))))))))))

(serve/servlet myresponse)


