;; climate-data contract

(define-map climate-data
  { timestamp: uint }
  {
    temperature: int,
    co2-level: uint,
    sea-level: int
  }
)

(define-constant contract-owner tx-sender)

(define-public (submit-climate-data (timestamp uint) (temperature int) (co2-level uint) (sea-level int))
  (begin
    (asserts! (is-eq tx-sender contract-owner) (err u403))
    (map-set climate-data
      { timestamp: timestamp }
      {
        temperature: temperature,
        co2-level: co2-level,
        sea-level: sea-level
      }
    )
    (ok true)
  )
)

(define-read-only (get-climate-data (timestamp uint))
  (map-get? climate-data { timestamp: timestamp })
)

