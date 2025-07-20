;; Funeral Scheduling Contract
;; Coordinates burial services and ceremony timing

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u200))
(define-constant ERR-SLOT-NOT-AVAILABLE (err u201))
(define-constant ERR-INVALID-DATE (err u202))
(define-constant ERR-FUNERAL-NOT-FOUND (err u203))
(define-constant ERR-INVALID-INPUT (err u204))

;; Data Variables
(define-data-var next-funeral-id uint u1)

;; Data Maps
(define-map funeral-schedules
  { funeral-id: uint }
  {
    plot-id: uint,
    deceased-name: (string-ascii 100),
    funeral-date: uint,
    funeral-time: uint,
    service-type: (string-ascii 50),
    funeral-director: principal,
    family-contact: principal,
    status: (string-ascii 20),
    created-at: uint
  }
)

(define-map daily-schedule
  { date: uint, time-slot: uint }
  {
    funeral-id: (optional uint),
    available: bool,
    chapel-assigned: (string-ascii 20)
  }
)

(define-map funeral-directors
  { director: principal }
  {
    name: (string-ascii 100),
    license-number: (string-ascii 50),
    active: bool,
    specialties: (string-ascii 100)
  }
)

(define-map authorized-staff
  { staff: principal }
  { role: (string-ascii 20), active: bool }
)

;; Private Functions
(define-private (is-authorized (caller principal))
  (or
    (is-eq caller CONTRACT-OWNER)
    (default-to false (get active (map-get? authorized-staff { staff: caller })))
  )
)

(define-private (is-time-slot-available (date uint) (time-slot uint))
  (default-to true (get available (map-get? daily-schedule { date: date, time-slot: time-slot })))
)

(define-private (is-valid-date (date uint))
  (> date block-height)
)

;; Public Functions

;; Schedule a funeral service
(define-public (schedule-funeral
  (plot-id uint)
  (deceased-name (string-ascii 100))
  (funeral-date uint)
  (funeral-time uint)
  (service-type (string-ascii 50))
  (funeral-director principal)
)
  (let ((funeral-id (var-get next-funeral-id)))
    (asserts! (is-authorized tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (is-valid-date funeral-date) ERR-INVALID-DATE)
    (asserts! (is-time-slot-available funeral-date funeral-time) ERR-SLOT-NOT-AVAILABLE)
    (asserts! (> plot-id u0) ERR-INVALID-INPUT)

    ;; Create funeral record
    (map-set funeral-schedules
      { funeral-id: funeral-id }
      {
        plot-id: plot-id,
        deceased-name: deceased-name,
        funeral-date: funeral-date,
        funeral-time: funeral-time,
        service-type: service-type,
        funeral-director: funeral-director,
        family-contact: tx-sender,
        status: "scheduled",
        created-at: block-height
      }
    )

    ;; Reserve time slot
    (map-set daily-schedule
      { date: funeral-date, time-slot: funeral-time }
      {
        funeral-id: (some funeral-id),
        available: false,
        chapel-assigned: "main-chapel"
      }
    )

    (var-set next-funeral-id (+ funeral-id u1))
    (ok funeral-id)
  )
)

;; Update funeral status
(define-public (update-funeral-status (funeral-id uint) (new-status (string-ascii 20)))
  (let (
    (funeral-data (unwrap! (map-get? funeral-schedules { funeral-id: funeral-id }) ERR-FUNERAL-NOT-FOUND))
  )
    (asserts! (is-authorized tx-sender) ERR-NOT-AUTHORIZED)

    (map-set funeral-schedules
      { funeral-id: funeral-id }
      (merge funeral-data { status: new-status })
    )

    ;; If cancelled, free up the time slot
    (if (is-eq new-status "cancelled")
      (map-set daily-schedule
        { date: (get funeral-date funeral-data), time-slot: (get funeral-time funeral-data) }
        {
          funeral-id: none,
          available: true,
          chapel-assigned: ""
        }
      )
      true
    )

    (ok true)
  )
)

;; Register funeral director
(define-public (register-funeral-director
  (director principal)
  (name (string-ascii 100))
  (license-number (string-ascii 50))
  (specialties (string-ascii 100))
)
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)

    (map-set funeral-directors
      { director: director }
      {
        name: name,
        license-number: license-number,
        active: true,
        specialties: specialties
      }
    )

    (ok true)
  )
)

;; Add authorized staff
(define-public (add-staff (staff-member principal) (role (string-ascii 20)))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (map-set authorized-staff
      { staff: staff-member }
      { role: role, active: true }
    )
    (ok true)
  )
)

;; Read-only Functions

;; Get funeral details
(define-read-only (get-funeral-details (funeral-id uint))
  (map-get? funeral-schedules { funeral-id: funeral-id })
)

;; Check time slot availability
(define-read-only (check-availability (date uint) (time-slot uint))
  (is-time-slot-available date time-slot)
)

;; Get daily schedule
(define-read-only (get-daily-schedule (date uint))
  (ok date) ;; Simplified - would return full day schedule
)

;; Get funeral director info
(define-read-only (get-funeral-director-info (director principal))
  (map-get? funeral-directors { director: director })
)

;; Get funerals by date
(define-read-only (get-funerals-by-date (date uint))
  (ok date) ;; Simplified - would filter by date
)
