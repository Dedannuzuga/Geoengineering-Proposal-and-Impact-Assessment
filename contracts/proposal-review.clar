;; proposal-review contract

(define-data-var last-proposal-id uint u0)

(define-map proposals
  { id: uint }
  {
    author: principal,
    title: (string-ascii 64),
    description: (string-ascii 256),
    data-url: (string-ascii 256),
    status: (string-ascii 20),
    created-at: uint
  }
)

(define-map reviews
  { proposal-id: uint, reviewer: principal }
  {
    score: uint,
    comment: (string-ascii 256),
    timestamp: uint
  }
)

(define-read-only (get-last-proposal-id)
  (var-get last-proposal-id)
)

(define-public (submit-proposal (title (string-ascii 64)) (description (string-ascii 256)) (data-url (string-ascii 256)))
  (let
    (
      (new-proposal-id (+ (var-get last-proposal-id) u1))
    )
    (map-set proposals
      { id: new-proposal-id }
      {
        author: tx-sender,
        title: title,
        description: description,
        data-url: data-url,
        status: "pending",
        created-at: block-height
      }
    )
    (var-set last-proposal-id new-proposal-id)
    (ok new-proposal-id)
  )
)

(define-public (submit-review (proposal-id uint) (score uint) (comment (string-ascii 256)))
  (let
    (
      (proposal (unwrap! (map-get? proposals { id: proposal-id }) (err u404)))
    )
    (asserts! (and (>= score u1) (<= score u5)) (err u400))
    (asserts! (not (is-eq (get author proposal) tx-sender)) (err u403))
    (map-set reviews
      { proposal-id: proposal-id, reviewer: tx-sender }
      {
        score: score,
        comment: comment,
        timestamp: block-height
      }
    )
    (ok true)
  )
)

(define-read-only (get-proposal (proposal-id uint))
  (map-get? proposals { id: proposal-id })
)

(define-read-only (get-review (proposal-id uint) (reviewer principal))
  (map-get? reviews { proposal-id: proposal-id, reviewer: reviewer })
)

