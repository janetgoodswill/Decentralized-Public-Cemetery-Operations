# Decentralized Public Cemetery Operations

A comprehensive blockchain-based system for managing public cemetery operations using Clarity smart contracts on the Stacks blockchain.

## System Overview

This system consists of five interconnected smart contracts that handle all aspects of cemetery management:

### Core Contracts

1. **Burial Plot Sales Contract** (`burial-plot-sales.clar`)
    - Manages grave site purchases and ownership records
    - Handles plot reservations and transfers
    - Tracks plot availability and pricing

2. **Funeral Scheduling Contract** (`funeral-scheduling.clar`)
    - Coordinates burial services and ceremony timing
    - Manages funeral director assignments
    - Handles scheduling conflicts and availability

3. **Maintenance Billing Contract** (`maintenance-billing.clar`)
    - Handles perpetual care fees and landscaping costs
    - Manages payment schedules and billing cycles
    - Tracks maintenance fund balances

4. **Memorial Permit Contract** (`memorial-permit.clar`)
    - Approves headstone installations and decorations
    - Manages permit applications and approvals
    - Enforces cemetery regulations and standards

5. **Genealogy Records Contract** (`genealogy-records.clar`)
    - Maintains burial databases for family research
    - Provides searchable genealogy information
    - Manages privacy and access controls

## Features

- **Transparent Operations**: All transactions recorded on blockchain
- **Immutable Records**: Permanent burial and genealogy records
- **Automated Billing**: Smart contract-based fee collection
- **Access Control**: Role-based permissions for cemetery staff
- **Family Research**: Comprehensive genealogy database
- **Regulatory Compliance**: Built-in permit and approval workflows

## Contract Architecture

Each contract operates independently while maintaining data consistency through standardized interfaces. The system uses principal-based authentication and role management.

### Data Types

- **Plot Information**: Location, size, ownership, status
- **Burial Records**: Deceased information, burial date, plot assignment
- **Maintenance Records**: Fee schedules, payment history, service logs
- **Memorial Records**: Permit details, installation status, compliance
- **Genealogy Data**: Family relationships, burial locations, historical records

## Getting Started

### Prerequisites

- Clarinet CLI installed
- Node.js and npm
- Stacks wallet for testing

### Installation

\`\`\`bash
git clone <repository-url>
cd cemetery-operations
npm install
clarinet check
\`\`\`

### Testing

\`\`\`bash
npm test
\`\`\`

### Deployment

\`\`\`bash
clarinet deploy --testnet
\`\`\`

## Usage Examples

### Purchase a Burial Plot

\`\`\`clarity
(contract-call? .burial-plot-sales purchase-plot u1 u2 "John Doe")
\`\`\`

### Schedule a Funeral

\`\`\`clarity
(contract-call? .funeral-scheduling schedule-funeral u1 u20240315 u1400 "Memorial Service")
\`\`\`

### Pay Maintenance Fees

\`\`\`clarity
(contract-call? .maintenance-billing pay-maintenance-fee u1 u500000)
\`\`\`

## Security Considerations

- All contracts implement proper access controls
- Financial transactions require sufficient balance verification
- Plot ownership is immutably recorded
- Sensitive genealogy data has privacy protections

## Contributing

Please read the PR-DETAILS.md file for contribution guidelines and development standards.

## License

This project is licensed under the MIT License.
