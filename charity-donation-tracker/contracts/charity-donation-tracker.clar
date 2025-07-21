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