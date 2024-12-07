;; voting contract

(define-map votes
  { proposal-id: uint, voter: principal }
  { amount: uint }
)

(define-map proposal-votes
  { proposal-id: uint }
  { total-votes: uint }
)

(define-public (vote (proposal-id uint) (amount uint))
  (let
    (
      (proposal (unwrap! (contract-call? .proposal-review get-proposal proposal-id) (err u404)))
      (voter-balance (unwrap! (contract-call? .geo-token get-balance tx-sender) (err u500)))
    )
    (asserts! (>= voter-balance amount) (err u401))
    (try! (contract-call? .geo-token transfer amount tx-sender (as-contract tx-sender)))

    (map-set votes
      { proposal-id: proposal-id, voter: tx-sender }
      { amount: (default-to u0 (get amount (map-get? votes { proposal-id: proposal-id, voter: tx-sender }))) }
    )

    (map-set proposal-votes
      { proposal-id: proposal-id }
      {
        total-votes: (+ (default-to u0 (get total-votes (map-get? proposal-votes { proposal-id: proposal-id }))) amount)
      }
    )

    (ok true)
  )
)

(define-read-only (get-vote (proposal-id uint) (voter principal))
  (map-get? votes { proposal-id: proposal-id, voter: voter })
)

(define-read-only (get-proposal-votes (proposal-id uint))
  (map-get? proposal-votes { proposal-id: proposal-id })
)

