;; geo-token contract

(define-fungible-token geo-token)

(define-data-var token-name (string-ascii 32) "GeoToken")
(define-data-var token-symbol (string-ascii 10) "GEO")
(define-data-var token-uri (optional (string-utf8 256)) none)

(define-constant contract-owner tx-sender)

(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender sender) (err u403))
    (ft-transfer? geo-token amount sender recipient)
  )
)

(define-public (mint (amount uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) (err u403))
    (ft-mint? geo-token amount recipient)
  )
)

(define-read-only (get-name)
  (ok (var-get token-name))
)

(define-read-only (get-symbol)
  (ok (var-get token-symbol))
)

(define-read-only (get-balance (account principal))
  (ok (ft-get-balance geo-token account))
)

(define-read-only (get-total-supply)
  (ok (ft-get-supply geo-token))
)

