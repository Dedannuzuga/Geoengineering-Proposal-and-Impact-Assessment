;; impact-assessment contract

(define-map assessments
  { proposal-id: uint }
  {
    climate-impact: int,
    economic-impact: int,
    social-impact: int,
    last-updated: uint
  }
)

(define-constant contract-owner tx-sender)

(define-public (submit-assessment (proposal-id uint) (climate-impact int) (economic-impact int) (social-impact int))
  (begin
    (asserts! (is-eq tx-sender contract-owner) (err u403))
    (map-set assessments
      { proposal-id: proposal-id }
      {
        climate-impact: climate-impact,
        economic-impact: economic-impact,
        social-impact: social-impact,
        last-updated: block-height
      }
    )
    (ok true)
  )
)

(define-read-only (get-assessment (proposal-id uint))
  (map-get? assessments { proposal-id: proposal-id })
)

