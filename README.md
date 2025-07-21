# Charity Donation Tracker

A Clarity smart contract for tracking STX donations to a charity on the Stacks blockchain.

## Overview
This project allows users to:
- Donate STX to a charity pool.
- View their donation amount.
- Check the total donations received.

## Contract Details
- **File**: `donation-tracker.clar`
- **Functions**:
  - `(donate amount)`: Donates a specified amount of STX.
  - `(get-donation donor)`: Retrieves a donor’s total contributions.
  - `(get-total-donations)`: Returns the total donated STX.

## Getting Started
1. Clone the repository.
2. Run `clarinet check` to verify the contract.
3. Deploy to a Stacks testnet.
4. Build a UI to display donation stats.

## Testing
Run tests with:
```bash
clarinet test