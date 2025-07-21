;; Enhanced Donation Contract - Core Infrastructure

;; Error constants
(define-constant ERR_INSUFFICIENT_AMOUNT (err u100))
(define-constant ERR_UNAUTHORIZED (err u101))
(define-constant ERR_CONTRACT_PAUSED (err u102))
(define-constant ERR_WITHDRAWAL_FAILED (err u103))
(define-constant ERR_MINIMUM_NOT_MET (err u104))
(define-constant ERR_INVALID_BENEFICIARY (err u105))

;; Contract constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant MINIMUM_DONATION u1000000) ;; 1 STX minimum

;; Data variables
(define-data-var total-donations uint u0)
(define-data-var total-donors uint u0)
(define-data-var contract-paused bool false)
(define-data-var beneficiary principal CONTRACT_OWNER)
(define-data-var withdrawal-enabled bool true)
(define-data-var campaign-goal uint u0)
(define-data-var campaign-deadline uint u0)

;; Data maps
(define-map donations { donor: principal } { amount: uint, timestamp: uint })
(define-map donor-list { index: uint } { donor: principal })

;; Events (using print for logging)
(define-private (log-donation (donor principal) (amount uint))
  (print { event: "donation", donor: donor, amount: amount, timestamp: block-height })
)

(define-private (log-withdrawal (beneficiary principal) (amount uint))
  (print { event: "withdrawal", beneficiary: beneficiary, amount: amount, timestamp: block-height })
)

;; Main donation function with enhanced features
(define-public (donate (amount uint))
  (begin
    (asserts! (not (var-get contract-paused)) ERR_CONTRACT_PAUSED)
    (asserts! (>= amount MINIMUM_DONATION) ERR_MINIMUM_NOT_MET)
    (asserts! (> amount u0) ERR_INSUFFICIENT_AMOUNT)
    
    ;; Check if campaign deadline has passed (if set)
    (if (> (var-get campaign-deadline) u0)
      (asserts! (<= block-height (var-get campaign-deadline)) ERR_UNAUTHORIZED)
      true
    )
    
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
    
    (let ((current-donation-data (map-get? donations { donor: tx-sender }))
          (current-amount (default-to u0 (get amount current-donation-data))))
      
      ;; If this is a new donor, add to donor list
      (if (is-none current-donation-data)
        (let ((donor-index (var-get total-donors)))
          (map-set donor-list { index: donor-index } { donor: tx-sender })
          (var-set total-donors (+ (var-get total-donors) u1))
        )
        false
      )
      
      ;; Update donation record
      (map-set donations 
        { donor: tx-sender } 
        { amount: (+ current-amount amount), timestamp: block-height })
      
      ;; Update total donations
      (var-set total-donations (+ (var-get total-donations) amount))
      
      ;; Log the donation
      (log-donation tx-sender amount)
      
      (ok true)
    )
  )
)